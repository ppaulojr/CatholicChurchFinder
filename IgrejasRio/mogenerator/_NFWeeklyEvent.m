// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFWeeklyEvent.m instead.

#import "_NFWeeklyEvent.h"

const struct NFWeeklyEventAttributes NFWeeklyEventAttributes = {
	.weekday = @"weekday",
};

const struct NFWeeklyEventRelationships NFWeeklyEventRelationships = {
};

const struct NFWeeklyEventFetchedProperties NFWeeklyEventFetchedProperties = {
};

@implementation NFWeeklyEventID
@end

@implementation _NFWeeklyEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WeeklyEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WeeklyEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WeeklyEvent" inManagedObjectContext:moc_];
}

- (NFWeeklyEventID*)objectID {
	return (NFWeeklyEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"weekdayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weekday"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic weekday;



- (int16_t)weekdayValue {
	NSNumber *result = [self weekday];
	return [result shortValue];
}

- (void)setWeekdayValue:(int16_t)value_ {
	[self setWeekday:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveWeekdayValue {
	NSNumber *result = [self primitiveWeekday];
	return [result shortValue];
}

- (void)setPrimitiveWeekdayValue:(int16_t)value_ {
	[self setPrimitiveWeekday:[NSNumber numberWithShort:value_]];
}










@end
