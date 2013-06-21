// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFYearlyEvent.h instead.

#import <CoreData/CoreData.h>
#import "NFEvent.h"

extern const struct NFYearlyEventAttributes {
	__unsafe_unretained NSString *day;
	__unsafe_unretained NSString *month;
} NFYearlyEventAttributes;

extern const struct NFYearlyEventRelationships {
} NFYearlyEventRelationships;

extern const struct NFYearlyEventFetchedProperties {
} NFYearlyEventFetchedProperties;





@interface NFYearlyEventID : NSManagedObjectID {}
@end

@interface _NFYearlyEvent : NFEvent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFYearlyEventID*)objectID;





@property (nonatomic, strong) NSNumber* day;



@property int16_t dayValue;
- (int16_t)dayValue;
- (void)setDayValue:(int16_t)value_;

//- (BOOL)validateDay:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* month;



@property int16_t monthValue;
- (int16_t)monthValue;
- (void)setMonthValue:(int16_t)value_;

//- (BOOL)validateMonth:(id*)value_ error:(NSError**)error_;






@end

@interface _NFYearlyEvent (CoreDataGeneratedAccessors)

@end

@interface _NFYearlyEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDay;
- (void)setPrimitiveDay:(NSNumber*)value;

- (int16_t)primitiveDayValue;
- (void)setPrimitiveDayValue:(int16_t)value_;




- (NSNumber*)primitiveMonth;
- (void)setPrimitiveMonth:(NSNumber*)value;

- (int16_t)primitiveMonthValue;
- (void)setPrimitiveMonthValue:(int16_t)value_;




@end
