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

- (NSString *)preamble
{
    return @"\
Igreja igreja;\n\
Igreja.Event event;\n\
Igreja.WeeklyEvent wEvent;\n\
Igreja.MonthlyEvent mEvent;\n\
Igreja.YearlyEvent yEvent;\n";
}

- (NSString *)snippetForNewIgreja
{
    return @"\
igreja = new Igreja();\n\
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
wEvent = new Igreja.WeeklyEvent();\n\
event = wEvent;\n\
wEvent.weekday = %%weekday%%;\n\
";
    } else if (class == [NFMonthlyEvent class]) {
        before = @"\
mEvent = new Igreja.MonthlyEvent();\n\
event = mEvent;\n\
mEvent.day = %%day%%;\n\
mEvent.week = %%week%%;\n\
";
    } else if (class == [NFYearlyEvent class]) {
        before = @"\
yEvent = new Igreja.YearlyEvent();\n\
event = yEvent;\n\
yEvent.day = %%day%%;\n\
yEvent.month = %%month%%;\n\
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
";

    return [NSString stringWithFormat:@"%@%@", before, common];
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
