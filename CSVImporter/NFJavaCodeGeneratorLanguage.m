//
//  NFJavaCodeGeneratorLanguage.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 05/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgreja.h"
#import "NFJavaCodeGeneratorLanguage.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"

@interface NFJavaCodeGeneratorLanguage ()

@property (assign, nonatomic) NSUInteger totalIgrejas;

@end

@implementation NFJavaCodeGeneratorLanguage

- (NSString *)languageName
{
    return @"Java";
}

- (NSString *)templateFilename
{
    return @"template.java";
}

- (NSString *)outputFilename
{
    return @"GeneratedDatabase.java";
}

- (NSString *)enteredIgrejaWithIndex:(NSUInteger)index
{
    self.totalIgrejas++;

    return [NSString stringWithFormat:@"    private void createIgreja%d() {\n", index];
}

- (NSString *)leftIgrejaWithIndex:(NSUInteger)index
{
    return @"    }\n\n";
}

- (NSString *)postamble
{
    NSMutableString *string = [@"    public GeneratedDatabase() {\n" mutableCopy];

    for (NSUInteger i = 0; i < self.totalIgrejas; i++) {
        [string appendFormat:@"        createIgreja%d();\n", i];
    }

    [string appendString:@"    }\n"];

    return string;
}

- (NSString *)snippetForNewIgreja
{
    return @"\
        Igreja igreja = new Igreja();\n\
        igreja.bairro = %%bairro%%;\n\
        igreja.cep = %%cep%%;\n\
        igreja.email = %%email%%;\n\
        igreja.endereco = %%endereco%%;\n\
        igreja.lastModified = %%lastModified%%;\n\
        igreja.latitude = %%latitude%%;\n\
        igreja.longitude = %%longitude%%;\n\
        igreja.nome = %%nome%%;\n\
        igreja.normalizedBairro = %%normalizedBairro%%;\n\
        igreja.normalizedNome = %%normalizedNome%%;\n\
        igreja.observacao = %%observacao%%;\n\
        igreja.paroco = %%paroco%%;\n\
        igreja.site = %%site%%;\n\
        igreja.telefones = %%telefones%%;\n\
        mAllIgrejas.add(igreja);\n\
";
}

- (NSString *)snippetForNewEventWithClass:(Class)class
{
    NSString *before;

    if (class == [NFWeeklyEvent class]) {
        before = @"\
            Igreja.WeeklyEvent event = new Igreja.WeeklyEvent();\n\
            event.weekday = %%weekday%%;\n\
";
    } else if (class == [NFMonthlyEvent class]) {
        before = @"\
            Igreja.MonthlyEvent event = new Igreja.MonthlyEvent();\n\
            event.day = %%day%%;\n\
            event.week = %%week%%;\n\
";
    } else if (class == [NFYearlyEvent class]) {
        before = @"\
            Igreja.YearlyEvent event = new Igreja.YearlyEvent();\n\
            event.day = %%day%%;\n\
            event.month = %%month%%;\n\
";
    }

    NSString *common = @"\
            event.endTime = %%endTime%%;\n\
            event.observation = %%observation%%;\n\
            event.startTime = %%startTime%%;\n\
            event.type = %%type%%;\n\
            event.igreja = %%igreja%%;\n\
            mAllEvents.add(event);\n\
            igreja.events.add(event);\n\
        }\n\
";

    return [NSString stringWithFormat:@"        {\n\%@%@", before, common];
}

- (NSString *)replacementInSnippetForObject:(id)obj withKey:(NSString *)key
{
    if (!obj) {
        return @"null";
    } else if ([key isEqualToString:@"type"]) {
        NFEventType type = [obj integerValue];
        switch (type) {
            case NFEventTypeConfissao:
                return @"Igreja.Event.Type.Confissao";
            case NFEventTypeMissa:
                return @"Igreja.Event.Type.Missa";
        }
    } else if ([obj isKindOfClass:[NFIgreja class]]) {
        return @"igreja";
    } else if ([obj isKindOfClass:[NSDate class]]) {
        NSDate *date = (NSDate *)obj;
        NSTimeInterval timeIntervalMS = [date timeIntervalSince1970] * 1000;
        return [NSString stringWithFormat:@"new Date(%.0fL)", timeIntervalMS];
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSString *escaped = [obj stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        escaped = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        return [NSString stringWithFormat:@"\"%@\"", escaped];
    } else {
        return [NSString stringWithFormat:@"%@", obj];
    }
}

@end
