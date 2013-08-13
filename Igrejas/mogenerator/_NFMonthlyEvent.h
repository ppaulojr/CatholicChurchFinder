// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFMonthlyEvent.h instead.

#import <CoreData/CoreData.h>
#import "NFEvent.h"

extern const struct NFMonthlyEventAttributes {
	__unsafe_unretained NSString *day;
	__unsafe_unretained NSString *week;
} NFMonthlyEventAttributes;

extern const struct NFMonthlyEventRelationships {
} NFMonthlyEventRelationships;

extern const struct NFMonthlyEventFetchedProperties {
} NFMonthlyEventFetchedProperties;





@interface NFMonthlyEventID : NSManagedObjectID {}
@end

@interface _NFMonthlyEvent : NFEvent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFMonthlyEventID*)objectID;





@property (nonatomic, strong) NSNumber* day;



@property int16_t dayValue;
- (int16_t)dayValue;
- (void)setDayValue:(int16_t)value_;

//- (BOOL)validateDay:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* week;



@property int16_t weekValue;
- (int16_t)weekValue;
- (void)setWeekValue:(int16_t)value_;

//- (BOOL)validateWeek:(id*)value_ error:(NSError**)error_;






@end

@interface _NFMonthlyEvent (CoreDataGeneratedAccessors)

@end

@interface _NFMonthlyEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDay;
- (void)setPrimitiveDay:(NSNumber*)value;

- (int16_t)primitiveDayValue;
- (void)setPrimitiveDayValue:(int16_t)value_;




- (NSNumber*)primitiveWeek;
- (void)setPrimitiveWeek:(NSNumber*)value;

- (int16_t)primitiveWeekValue;
- (void)setPrimitiveWeekValue:(int16_t)value_;




@end
