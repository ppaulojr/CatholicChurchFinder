//
//  NFCoreDataStackManager.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 23/04/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "NFCoreDataStackManager.h"

@implementation NFCoreDataStackManager

+ (instancetype)sharedManager
{
    static NFCoreDataStackManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NFCoreDataStackManager new];
    });
    return instance;
}

- (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel *mom;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    });
    return mom;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *psc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *storeURL = [[NSBundle mainBundle] URLForResource:@"IgrejasRio" withExtension:@"sqlite"];
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSReadOnlyPersistentStoreOption : @YES} error:NULL];
    });
    return psc;
}

- (NSManagedObjectContext *)managedObjectContext
{
    static NSManagedObjectContext *moc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator;
    });
    return moc;
}

@end
