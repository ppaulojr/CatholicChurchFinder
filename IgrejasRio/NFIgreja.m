//
//  NFIgreja.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "NFIgreja.h"

@implementation NFIgreja

+ (NSArray *)allIgrejasInContext:(NSManagedObjectContext *)moc
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    return [moc executeFetchRequest:request error:NULL];
}

+ (NSArray *)igrejasInMapRegion:(MKCoordinateRegion)region context:(NSManagedObjectContext *)moc
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.predicate = [self _predicateWithRegion:region];
    return [moc executeFetchRequest:request error:NULL];
}

+ (NSPredicate *)_predicateWithRegion:(MKCoordinateRegion)region
{
    CLLocationCoordinate2D center = region.center;

    CLLocationDegrees latDelta = region.span.latitudeDelta / 2;
    CLLocationDegrees lat1 = center.latitude - latDelta;
    CLLocationDegrees lat2 = center.latitude + latDelta;

    CLLocationDegrees longDelta = region.span.longitudeDelta / 2;
    CLLocationDegrees long1 = center.longitude - longDelta;
    CLLocationDegrees long2 = center.longitude + longDelta;

    return [NSPredicate predicateWithFormat:@"latitude BETWEEN { %@, %@ } AND longitude BETWEEN { %@, %@ }",
            @(lat1), @(lat2), @(long1), @(long2)];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitudeValue;
    coordinate.longitude = self.longitudeValue;
    return coordinate;
}

- (NSString *)title
{
    return self.nome;
}

@end
