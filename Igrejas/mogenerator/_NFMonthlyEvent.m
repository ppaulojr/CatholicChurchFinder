// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFMonthlyEvent.m instead.

#import "_NFMonthlyEvent.h"

const struct NFMonthlyEventAttributes NFMonthlyEventAttributes = {
	.day = @"day",
	.week = @"week",
};

const struct NFMonthlyEventRelationships NFMonthlyEventRelationships = {
};

const struct NFMonthlyEventFetchedProperties NFMonthlyEventFetchedProperties = {
};

@implementation NFMonthlyEventID
@end

@implementation _NFMonthlyEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MonthlyEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MonthlyEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MonthlyEvent" inManagedObjectContext:moc_];
}

- (NFMonthlyEventID*)objectID {
	return (NFMonthlyEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"dayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"day"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weekValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"week"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic day;



- (int16_t)dayValue {
	NSNumber *result = [self day];
	return [result shortValue];
}

- (void)setDayValue:(int16_t)value_ {
	[self setDay:@(value_)];
}

- (int16_t)primitiveDayValue {
	NSNumber *result = [self primitiveDay];
	return [result shortValue];
}

- (void)setPrimitiveDayValue:(int16_t)value_ {
	[self setPrimitiveDay:@(value_)];
}





@dynamic week;



- (int16_t)weekValue {
	NSNumber *result = [self week];
	return [result shortValue];
}

- (void)setWeekValue:(int16_t)value_ {
	[self setWeek:@(value_)];
}

- (int16_t)primitiveWeekValue {
	NSNumber *result = [self primitiveWeek];
	return [result shortValue];
}

- (void)setPrimitiveWeekValue:(int16_t)value_ {
	[self setPrimitiveWeek:@(value_)];
}










@end
