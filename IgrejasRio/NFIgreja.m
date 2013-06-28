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
