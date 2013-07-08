//
//  NFCodeGenerator.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 05/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFCodeGenerator.h"
#import "NFIgreja.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"

@interface NFCodeGenerator ()

@property (strong, nonatomic) NSArray *languages;

@end

@implementation NFCodeGenerator

- (id)initWithLanguages:(NSArray *)languages
{
    self = [super init];
    if (self) {
        self.languages = languages;
    }
    return self;
}

- (void)generateForIgrejas:(NSArray *)igrejas
{
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = dirs[0];

    for (id <NFCodeGeneratorLanguage> language in self.languages) {
        NSLog(@"Generating code for language %@...", [language languageName]);

        NSMutableString *templateData = [NSMutableString new];

        if ([language respondsToSelector:@selector(preamble)]) {
            [templateData appendString:[language preamble]];
        }

        NSString *newIgrejaSnippet = [language snippetForNewIgreja];
        NSArray *newIgrejaKeys = [self _keysFromSnippet:newIgrejaSnippet];

        NSMutableDictionary *snippetsByClass = [NSMutableDictionary dictionaryWithCapacity:3];
        NSMutableDictionary *keysByClass = [NSMutableDictionary dictionaryWithCapacity:3];

        for (Class class in @[[NFWeeklyEvent class], [NFMonthlyEvent class], [NFYearlyEvent class]]) {
            NSString *key = NSStringFromClass(class);
            NSString *snippet = [language snippetForNewEventWithClass:class];
            snippetsByClass[key] = snippet;
            keysByClass[key] = [self _keysFromSnippet:snippet];
        }

        [igrejas enumerateObjectsUsingBlock:^(NFIgreja *igreja, NSUInteger idx, BOOL *stop) {
            NSString *replaced = [self _stringByPerformingSubstitutionsWithLanguage:language snippet:newIgrejaSnippet object:igreja keys:newIgrejaKeys];
            [templateData appendString:replaced];

            for (id event in igreja.eventSet) {
                NSString *key = NSStringFromClass([event class]);
                replaced = [self _stringByPerformingSubstitutionsWithLanguage:language snippet:snippetsByClass[key] object:event keys:keysByClass[key]];
                [templateData appendString:replaced];
            }
        }];

        if ([language respondsToSelector:@selector(postamble)]) {
            [templateData appendString:[language postamble]];
        }

        NSString *templateFilename = [language templateFilename];
        NSString *templateExtension = [templateFilename pathExtension];
        templateFilename = [templateFilename stringByDeletingPathExtension];

        NSString *templatePath = [[NSBundle mainBundle] pathForResource:templateFilename ofType:templateExtension];
        NSString *template = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:NULL];

        NSString *path = [baseDir stringByAppendingPathComponent:[language outputFilename]];
        NSString *code = [template stringByReplacingOccurrencesOfString:@"%%DATA%%" withString:templateData];
        [code writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:NULL];

        NSLog(@"Generated code for language %@ at %@", [language languageName], path);
    }
}

- (NSArray *)_keysFromSnippet:(NSString *)snippet
{
    NSRegularExpression *parseRegex = [NSRegularExpression regularExpressionWithPattern:@"%%[^%]+%%" options:0 error:NULL];
    NSMutableArray *keys = [NSMutableArray new];

    [parseRegex enumerateMatchesInString:snippet options:0 range:NSMakeRange(0, snippet.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *token = [snippet substringWithRange:result.range];
        NSString *keyPath = [token substringWithRange:NSMakeRange(2, token.length - 4)];
        [keys addObject:keyPath];
    }];

    return keys;
}

- (NSString *)_stringByPerformingSubstitutionsWithLanguage:(id <NFCodeGeneratorLanguage>)language
                                                   snippet:(NSString *)snippet
                                                    object:(id)obj
                                                      keys:(NSArray *)keys
{
    NSMutableString *modifiedSnippet = [snippet mutableCopy];

    for (NSString *key in keys) {
        @autoreleasepool {
            NSString *replacementKey = [NSString stringWithFormat:@"%%%%%@%%%%", key];
            NSString *replacementValue = [language replacementInSnippetForObject:[obj valueForKey:key] withKey:key];
            [modifiedSnippet replaceOccurrencesOfString:replacementKey withString:replacementValue options:0 range:NSMakeRange(0, modifiedSnippet.length)];
        }
    }

    return modifiedSnippet;
}

@end
