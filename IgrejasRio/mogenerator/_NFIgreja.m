// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFIgreja.m instead.

#import "_NFIgreja.h"

const struct NFIgrejaAttributes NFIgrejaAttributes = {
	.bairro = @"bairro",
	.cep = @"cep",
	.email = @"email",
	.endereco = @"endereco",
	.lastModified = @"lastModified",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.nome = @"nome",
	.normalizedBairro = @"normalizedBairro",
	.normalizedNome = @"normalizedNome",
	.observacao = @"observacao",
	.paroco = @"paroco",
	.site = @"site",
	.telefones = @"telefones",
};

const struct NFIgrejaRelationships NFIgrejaRelationships = {
	.event = @"event",
};

const struct NFIgrejaFetchedProperties NFIgrejaFetchedProperties = {
};

@implementation NFIgrejaID
@end

@implementation _NFIgreja

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Igreja" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Igreja";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Igreja" inManagedObjectContext:moc_];
}

- (NFIgrejaID*)objectID {
	return (NFIgrejaID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bairro;






@dynamic cep;






@dynamic email;






@dynamic endereco;






@dynamic lastModified;






@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic nome;






@dynamic normalizedBairro;






@dynamic normalizedNome;






@dynamic observacao;






@dynamic paroco;






@dynamic site;






@dynamic telefones;






@dynamic event;

	
- (NSMutableSet*)eventSet {
	[self willAccessValueForKey:@"event"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"event"];
  
	[self didAccessValueForKey:@"event"];
	return result;
}
	






@end
