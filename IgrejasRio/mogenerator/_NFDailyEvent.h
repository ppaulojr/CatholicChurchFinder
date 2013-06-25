// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDailyEvent.h instead.

#import <CoreData/CoreData.h>
#import "NFEvent.h"

extern const struct NFDailyEventAttributes {
} NFDailyEventAttributes;

extern const struct NFDailyEventRelationships {
} NFDailyEventRelationships;

extern const struct NFDailyEventFetchedProperties {
} NFDailyEventFetchedProperties;



@interface NFDailyEventID : NSManagedObjectID {}
@end

@interface _NFDailyEvent : NFEvent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDailyEventID*)objectID;






@end

@interface _NFDailyEvent (CoreDataGeneratedAccessors)

@end

@interface _NFDailyEvent (CoreDataGeneratedPrimitiveAccessors)


@end
