//
//  NFCoreDataStackManager+Import.m
//  Igrejas Rio
//
//  Created by Fernando Lemos on 20/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "CHCSVParser.h"
#import "NFCoreDataStackManager+Import.h"
#import "NFDailyEvent.h"
#import "NFIgreja.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"
#import "NSString+NFNormalizing.h"


@interface NFCSVParserDelegate : NSObject <CHCSVParserDelegate>

@property (nonatomic, strong) void (^lineBlock)(NSArray *);

@end

@implementation NFCSVParserDelegate {
    NSMutableArray *_line;
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"Error parsing CSV: %@", error);
    abort();
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    _line = [NSMutableArray array];
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    [_line addObject:field];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if (_line.count && [_line[0] length]) {
        self.lineBlock(_line);
    }
}

@end


@implementation NFCoreDataStackManager (Import)

- (NSString *)importOutputDatabasePath
{
    static NSString *path;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *baseDir = dirs[0];
        path = [baseDir stringByAppendingPathComponent:@"IgrejasRio.sqlite"];
    });
    return path;
}

- (NSDate *)dateWithImportedString:(NSString *)string
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });

    return [formatter dateFromString:string];
}

- (NSString *)stringOrNilWithImportedString:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string.length ? string : nil;
}

- (NSString *)stringByNormalizingImportedString:(NSString *)string
{
    return string ? [string nf_searchNormalizedString] : nil;
}

- (NSDictionary *)importIgrejasWithContext:(NSManagedObjectContext *)moc
{
    NSLog(@"Importing igrejas...");

    NSString *csvPath = [[NSBundle mainBundle] pathForResource:@"igrejas" ofType:@"csv"];
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:csvPath];

    CHCSVParser *parser = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:NULL delimiter:';'];
    parser.sanitizesFields = YES;

    NFCSVParserDelegate *parserDelegate = [NFCSVParserDelegate new];
    parser.delegate = parserDelegate;

    NSMutableDictionary *igrejas = [NSMutableDictionary dictionary];

    parserDelegate.lineBlock = ^(NSArray *fields) {
        NSAssert(fields.count == 21, @"Expected 21 fields, got %d", fields.count);

        // Skip the header
        if ([fields[0] isEqualToString:@"id_igreja"]) {
            return;
        }

        NFIgreja *igreja = [NFIgreja insertInManagedObjectContext:moc];
        igreja.nome = [self stringOrNilWithImportedString:fields[1]];
        igreja.paroco = [self stringOrNilWithImportedString:fields[2]];
        igreja.endereco = [self stringOrNilWithImportedString:fields[3]];
        igreja.bairro = [self stringOrNilWithImportedString:fields[4]];
        igreja.cep = [self stringOrNilWithImportedString:fields[8]];
        igreja.telefones = [self stringOrNilWithImportedString:fields[9]];
        igreja.observacao = [self stringOrNilWithImportedString:fields[10]];
        igreja.latitudeValue = [fields[11] doubleValue];
        igreja.longitudeValue = [fields[12] doubleValue];
        igreja.site = [self stringOrNilWithImportedString:fields[15]];
        igreja.email = [self stringOrNilWithImportedString:fields[16]];
        igreja.lastModified = [self dateWithImportedString:fields[20]];

        igreja.normalizedNome = [self stringByNormalizingImportedString:igreja.nome];
        igreja.normalizedBairro = [self stringByNormalizingImportedString:igreja.bairro];

        igrejas[fields[0]] = igreja;
    };

    [parser parse];

    NSLog(@"%d igrejas imported", igrejas.count);

    NSError *error;
    if (![moc save:&error]) {
        NSLog(@"Failed to save managed object context: %@", error);
        abort();
    }

    return igrejas;
}

- (void)importEventsWithIgrejas:(NSDictionary *)igrejas context:(NSManagedObjectContext *)moc
{
    NSLog(@"Importing events...");

    NSString *csvPath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"csv"];
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:csvPath];

    CHCSVParser *parser = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:NULL delimiter:';'];
    parser.sanitizesFields = YES;

    NFCSVParserDelegate *parserDelegate = [NFCSVParserDelegate new];
    parser.delegate = parserDelegate;

    __block int count = 0;

    parserDelegate.lineBlock = ^(NSArray *fields) {
        NSAssert(fields.count == 14, @"Expected 14 fields, got %d", fields.count);

        // Skip the header
        if ([fields[0] isEqualToString:@"id_evento"]) {
            return;
        }

        int day = [fields[2] intValue];
        int month = [fields[3] intValue];
        int week = [fields[4] intValue];
        int weekday = [fields[5] intValue];

        NFEvent *event;

        if (day == 0) {
            if (weekday == 0) {
                if (month != 0 && week != 0) {
                    NSLog(@"Warning: Invalid entry (id = %d), ignoring month and week fields", [fields[0] intValue]);
                }
                event = [NFDailyEvent insertInManagedObjectContext:moc];
            } else if (week == 0) {
                assert(weekday >= 1 && weekday <= 7);
                NFWeeklyEvent *weeklyEvent = [NFWeeklyEvent insertInManagedObjectContext:moc];
                weeklyEvent.weekdayValue = weekday;
                event = weeklyEvent;
            } else {
                assert(weekday >= 1 && weekday <= 7);
                NFMonthlyEvent *monthlyEvent = [NFMonthlyEvent insertInManagedObjectContext:moc];
                monthlyEvent.dayValue = weekday;
                monthlyEvent.weekValue = week;
                event = monthlyEvent;
            }
        } else {
            assert(day > 0);
            if (weekday != 0) {
                NSLog(@"Warning: Invalid entry (id = %d), ignoring weekday field", [fields[0] intValue]);
            }
            if (month == 0) {
                NFMonthlyEvent *monthlyEvent = [NFMonthlyEvent insertInManagedObjectContext:moc];
                monthlyEvent.dayValue = day;
                event = monthlyEvent;
            } else {
                assert(month >= 1 && month <= 12);
                NFYearlyEvent *yearlyEvent = [NFYearlyEvent insertInManagedObjectContext:moc];
                yearlyEvent.dayValue = day;
                yearlyEvent.monthValue = month;
                event = yearlyEvent;
            }
        }

        event.igreja = igrejas[fields[1]];

        int startHours = [fields[6] intValue];
        int startMinutes = [fields[7] intValue];
        assert(startHours >= 0 && startHours < 24);
        assert(startMinutes >= 0 && startMinutes < 60);
        event.startTimeValue = startHours * 100 + startMinutes;

        int endHours = [fields[8] intValue];
        int endMinutes = [fields[9] intValue];
        if (endHours == -1) {
            assert(endMinutes == -1);
        } else {
            assert(endHours >= 0 && endHours < 24);
            assert(endMinutes >= 0 && endMinutes < 60);
            event.endTimeValue = endHours * 100 + endMinutes;
        }

        int type = [fields[10] intValue];
        if (type == 1) {
            event.typeValue = NFEventTypeMissa;
        } else {
            NSAssert(type == 2, @"Expected event type 1 or 2, got %d", type);
            event.typeValue = NFEventTypeConfissao;
        }

        ++count;
    };

    [parser parse];

    NSLog(@"%d events imported", count);

    NSError *error;
    if (![moc save:&error]) {
        NSLog(@"Failed to save managed object context: %@", error);
        abort();
    }
}

- (void)performImport
{
    // Remove the store if it exists
    NSString *storePath = self.importOutputDatabasePath;
    [[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];

    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                         initWithManagedObjectModel:self.managedObjectModel];

    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:NULL];

    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;

    NSDictionary *igrejas = [self importIgrejasWithContext:moc];
    [self importEventsWithIgrejas:igrejas context:moc];
}

@end
