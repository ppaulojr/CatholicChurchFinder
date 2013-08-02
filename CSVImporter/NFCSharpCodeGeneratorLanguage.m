//
//  NFCSharpCodeGeneratorLanguage.m
//  IgrejasRio
//
//  Created by Pedro Paulo Oliveira Jr on 15/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgreja.h"
#import "NFCSharpCodeGeneratorLanguage.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"

@interface NFCSharpCodeGeneratorLanguage ()

@property (assign, nonatomic) NSUInteger totalIgrejas;

@end

@implementation NFCSharpCodeGeneratorLanguage

- (NSString *)languageName
{
    return @"C#";
}

- (NSString *)templateFilename
{
    return @"template.cs";
}

- (NSString *)outputFilename
{
    return @"IgrejaDatabase.cs";
}

- (NSStringEncoding)languageEncoding
{
    return NSUTF8StringEncoding;
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
    NSMutableString *string = [@"    public void LoadData() {\n" mutableCopy];
    
    for (NSUInteger i = 0; i < self.totalIgrejas; i++) {
        [string appendFormat:@"        createIgreja%d();\n", i];
    }

    [string appendString:@"        this.IsDataLoaded = true;"];
    [string appendString:@"    }\n"];
    
    return string;
}

- (NSString *)snippetForNewIgreja
{
    return @"\
                IgrejaModel igreja = new IgrejaModel(%%nome%%, %%paroco%%, %%endereco%%, %%telefones%%, %%normalizedBairro%%, %%email%%, %%site%%, %%latitude%%, %%longitude%%);\n\
                this.Items.Add(igreja);\n\
                Evento evt; \n\
    ";
}

- (NSString *)snippetForNewEventWithClass:(Class)class
{
    NSString *before;
    
    if (class == [NFWeeklyEvent class]) {
        before = @"\
                evt = new Evento(-1,-1,0,%%weekday%%,%%startTime%%,%%type%%);\n\
        ";
    } else if (class == [NFMonthlyEvent class]) {
        before = @"\
                evt = new Evento(%%day%%,-1,%%week%%,-1,%%startTime%%,%%type%%);\n\
        ";
    } else if (class == [NFYearlyEvent class]) {
        before = @"\
                evt = new Evento(%%day%%,%%month%%,-1,-1,%%startTime%%,%%type%%);\n\
        ";
    }
    
    NSString *common = @"\
        igreja.AddEvento(evt);\n\
    ";
    
    return [NSString stringWithFormat:@"        \n\%@%@", before, common];
}

- (NSString *)replacementInSnippetForObject:(id)obj withKey:(NSString *)key
{
    if (!obj) {
        return @"null";
    } else if ([key isEqualToString:@"type"]) {
        NFEventType type = [obj integerValue];
        switch (type) {
            case NFEventTypeConfissao:
                return @"Evento.tipoEvt.confissao";
            case NFEventTypeMissa:
                return @"Evento.tipoEvt.missa";
        }
    } else if ([obj isKindOfClass:[NFIgreja class]]) {
        return @"igreja";
    } else if ([obj isKindOfClass:[NSDate class]]) {
        NSDate *date = (NSDate *)obj;
        NSLog(@"%@",date);
        NSTimeInterval timeIntervalMS = [date timeIntervalSince1970] * 1000;
        return [NSString stringWithFormat:@"new DateTime(%.0fL)", timeIntervalMS];
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSString *escaped = [obj stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        escaped = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        return [NSString stringWithFormat:@"\"%@\"", escaped];
    } else {
        return [NSString stringWithFormat:@"%@", obj];
    }
}
@end
