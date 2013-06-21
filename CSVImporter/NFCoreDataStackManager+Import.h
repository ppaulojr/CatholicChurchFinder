//
//  NFCoreDataStackManager+Import.h
//  Igrejas Rio
//
//  Created by Fernando Lemos on 20/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFCoreDataStackManager.h"

@interface NFCoreDataStackManager (Import)

@property (nonatomic, readonly) NSString *importOutputDatabasePath;

- (void)performImport;

@end
