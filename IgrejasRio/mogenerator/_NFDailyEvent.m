// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDailyEvent.m instead.

#import "_NFDailyEvent.h"

const struct NFDailyEventAttributes NFDailyEventAttributes = {
};

const struct NFDailyEventRelationships NFDailyEventRelationships = {
};

const struct NFDailyEventFetchedProperties NFDailyEventFetchedProperties = {
};

@implementation NFDailyEventID
@end

@implementation _NFDailyEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DailyEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DailyEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DailyEvent" inManagedObjectContext:moc_];
}

- (NFDailyEventID*)objectID {
	return (NFDailyEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
