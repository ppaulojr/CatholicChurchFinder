// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFEvent.h instead.

#import <CoreData/CoreData.h>


extern const struct NFEventAttributes {
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *observation;
	__unsafe_unretained NSString *startTime;
} NFEventAttributes;

extern const struct NFEventRelationships {
	__unsafe_unretained NSString *igreja;
} NFEventRelationships;

extern const struct NFEventFetchedProperties {
} NFEventFetchedProperties;

@class NFIgreja;





@interface NFEventID : NSManagedObjectID {}
@end

@interface _NFEvent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFEventID*)objectID;





@property (nonatomic, strong) NSNumber* endTime;



@property int16_t endTimeValue;
- (int16_t)endTimeValue;
- (void)setEndTimeValue:(int16_t)value_;

//- (BOOL)validateEndTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* observation;



//- (BOOL)validateObservation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* startTime;



@property int16_t startTimeValue;
- (int16_t)startTimeValue;
- (void)setStartTimeValue:(int16_t)value_;

//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NFIgreja *igreja;

//- (BOOL)validateIgreja:(id*)value_ error:(NSError**)error_;





@end

@interface _NFEvent (CoreDataGeneratedAccessors)

@end

@interface _NFEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSNumber*)value;

- (int16_t)primitiveEndTimeValue;
- (void)setPrimitiveEndTimeValue:(int16_t)value_;




- (NSString*)primitiveObservation;
- (void)setPrimitiveObservation:(NSString*)value;




- (NSNumber*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSNumber*)value;

- (int16_t)primitiveStartTimeValue;
- (void)setPrimitiveStartTimeValue:(int16_t)value_;





- (NFIgreja*)primitiveIgreja;
- (void)setPrimitiveIgreja:(NFIgreja*)value;


@end
