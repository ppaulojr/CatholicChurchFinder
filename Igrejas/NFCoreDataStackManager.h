//
//  NFCoreDataStackManager.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 23/04/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface NFCoreDataStackManager : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (readonly, nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (readonly, nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

@end
