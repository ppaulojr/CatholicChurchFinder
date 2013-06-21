// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFWeeklyEvent.h instead.

#import <CoreData/CoreData.h>
#import "NFEvent.h"

extern const struct NFWeeklyEventAttributes {
	__unsafe_unretained NSString *weekday;
} NFWeeklyEventAttributes;

extern const struct NFWeeklyEventRelationships {
} NFWeeklyEventRelationships;

extern const struct NFWeeklyEventFetchedProperties {
} NFWeeklyEventFetchedProperties;




@interface NFWeeklyEventID : NSManagedObjectID {}
@end

@interface _NFWeeklyEvent : NFEvent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFWeeklyEventID*)objectID;





@property (nonatomic, strong) NSNumber* weekday;



@property int16_t weekdayValue;
- (int16_t)weekdayValue;
- (void)setWeekdayValue:(int16_t)value_;

//- (BOOL)validateWeekday:(id*)value_ error:(NSError**)error_;






@end

@interface _NFWeeklyEvent (CoreDataGeneratedAccessors)

@end

@interface _NFWeeklyEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveWeekday;
- (void)setPrimitiveWeekday:(NSNumber*)value;

- (int16_t)primitiveWeekdayValue;
- (void)setPrimitiveWeekdayValue:(int16_t)value_;




@end
