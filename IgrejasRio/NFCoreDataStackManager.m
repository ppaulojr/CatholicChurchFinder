//
//  NFCoreDataStackManager.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 23/04/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "NFCoreDataStackManager.h"

@implementation NFCoreDataStackManager

+ (instancetype)sharedInstance
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
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Igrejas_Rio" withExtension:@"momd"];
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
        NSURL *storeURL = [[NSBundle mainBundle] URLForResource:@"Igrejas_Rio" withExtension:@"sqlite"];
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil URL:storeURL
                                                            options:nil error:NULL];
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
