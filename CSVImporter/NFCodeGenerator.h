//
//  NFCodeGenerator.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 05/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFCodeGenerator : NSObject

- (id)initWithLanguages:(NSArray *)languages;

- (void)generateForIgrejas:(NSArray *)igrejas;

@end


@protocol NFCodeGeneratorLanguage <NSObject>

- (NSString *)languageName;
- (NSString *)templateFilename;
- (NSString *)outputFilename;

- (NSString *)snippetForNewIgreja;
- (NSString *)snippetForNewEventWithClass:(Class)class;
- (NSString *)replacementInSnippetForObject:(id)obj withKey:(NSString *)key;

@optional

- (NSString *)enteredIgrejaWithIndex:(NSUInteger)index;
- (NSString *)leftIgrejaWithIndex:(NSUInteger)index;

- (NSString *)preamble;
- (NSString *)postamble;

@end
