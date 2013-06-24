//
//  NFIgreja.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 23/04/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "_NFIgreja.h"

@interface NFIgreja : _NFIgreja <MKAnnotation>

+ (NSArray *)allIgrejasInContext:(NSManagedObjectContext *)moc;

- (CLLocationCoordinate2D)coordinate;

@end
