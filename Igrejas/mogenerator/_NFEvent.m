// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFEvent.m instead.

#import "_NFEvent.h"

const struct NFEventAttributes NFEventAttributes = {
	.endTime = @"endTime",
	.observation = @"observation",
	.startTime = @"startTime",
	.type = @"type",
};

const struct NFEventRelationships NFEventRelationships = {
	.igreja = @"igreja",
};

const struct NFEventFetchedProperties NFEventFetchedProperties = {
};

@implementation NFEventID
@end

@implementation _NFEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Event";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Event" inManagedObjectContext:moc_];
}

- (NFEventID*)objectID {
	return (NFEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"endTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"startTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"startTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic endTime;



- (int16_t)endTimeValue {
	NSNumber *result = [self endTime];
	return [result shortValue];
}

- (void)setEndTimeValue:(int16_t)value_ {
	[self setEndTime:@(value_)];
}

- (int16_t)primitiveEndTimeValue {
	NSNumber *result = [self primitiveEndTime];
	return [result shortValue];
}

- (void)setPrimitiveEndTimeValue:(int16_t)value_ {
	[self setPrimitiveEndTime:@(value_)];
}





@dynamic observation;






@dynamic startTime;



- (int16_t)startTimeValue {
	NSNumber *result = [self startTime];
	return [result shortValue];
}

- (void)setStartTimeValue:(int16_t)value_ {
	[self setStartTime:@(value_)];
}

- (int16_t)primitiveStartTimeValue {
	NSNumber *result = [self primitiveStartTime];
	return [result shortValue];
}

- (void)setPrimitiveStartTimeValue:(int16_t)value_ {
	[self setPrimitiveStartTime:@(value_)];
}





@dynamic type;



- (int16_t)typeValue {
	NSNumber *result = [self type];
	return [result shortValue];
}

- (void)setTypeValue:(int16_t)value_ {
	[self setType:@(value_)];
}

- (int16_t)primitiveTypeValue {
	NSNumber *result = [self primitiveTypeNumber];
	return [result shortValue];
}

- (void)setPrimitiveTypeValue:(int16_t)value_ {
	[self setPrimitiveTypeNumber:@(value_)];
}





@dynamic igreja;

	






@end
