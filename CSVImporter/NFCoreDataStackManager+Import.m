//
//  NFCoreDataStackManager+Import.m
//  Igrejas Rio
//
//  Created by Fernando Lemos on 20/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "CHCSVParser.h"
#import "NFCoreDataStackManager+Import.h"
#import "NFIgreja.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"


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
        igreja.latitude = @([(NSString *)fields[11] doubleValue]);
        igreja.longitude = @([(NSString *)fields[12] doubleValue]);
        igreja.site = [self stringOrNilWithImportedString:fields[15]];
        igreja.email = [self stringOrNilWithImportedString:fields[16]];
        igreja.lastModified = [self dateWithImportedString:fields[20]];

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

    [self importIgrejasWithContext:moc];

    // TODO: Import the events
}

@end
