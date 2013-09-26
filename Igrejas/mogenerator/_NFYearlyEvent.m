// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFYearlyEvent.m instead.

#import "_NFYearlyEvent.h"

const struct NFYearlyEventAttributes NFYearlyEventAttributes = {
	.day = @"day",
	.month = @"month",
};

const struct NFYearlyEventRelationships NFYearlyEventRelationships = {
};

const struct NFYearlyEventFetchedProperties NFYearlyEventFetchedProperties = {
};

@implementation NFYearlyEventID
@end

@implementation _NFYearlyEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"YearlyEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"YearlyEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"YearlyEvent" inManagedObjectContext:moc_];
}

- (NFYearlyEventID*)objectID {
	return (NFYearlyEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"dayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"day"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"monthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"month"];
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
	[self setDay:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDayValue {
	NSNumber *result = [self primitiveDay];
	return [result shortValue];
}

- (void)setPrimitiveDayValue:(int16_t)value_ {
	[self setPrimitiveDay:[NSNumber numberWithShort:value_]];
}





@dynamic month;



- (int16_t)monthValue {
	NSNumber *result = [self month];
	return [result shortValue];
}

- (void)setMonthValue:(int16_t)value_ {
	[self setMonth:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMonthValue {
	NSNumber *result = [self primitiveMonth];
	return [result shortValue];
}

- (void)setPrimitiveMonthValue:(int16_t)value_ {
	[self setPrimitiveMonth:[NSNumber numberWithShort:value_]];
}










@end
