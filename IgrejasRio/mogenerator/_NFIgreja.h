// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFIgreja.h instead.

#import <CoreData/CoreData.h>


extern const struct NFIgrejaAttributes {
	__unsafe_unretained NSString *bairro;
	__unsafe_unretained NSString *cep;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *endereco;
	__unsafe_unretained NSString *lastModified;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *nome;
	__unsafe_unretained NSString *observacao;
	__unsafe_unretained NSString *paroco;
	__unsafe_unretained NSString *site;
	__unsafe_unretained NSString *telefones;
} NFIgrejaAttributes;

extern const struct NFIgrejaRelationships {
	__unsafe_unretained NSString *event;
} NFIgrejaRelationships;

extern const struct NFIgrejaFetchedProperties {
} NFIgrejaFetchedProperties;

@class NFEvent;














@interface NFIgrejaID : NSManagedObjectID {}
@end

@interface _NFIgreja : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFIgrejaID*)objectID;





@property (nonatomic, strong) NSString* bairro;



//- (BOOL)validateBairro:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cep;



//- (BOOL)validateCep:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* endereco;



//- (BOOL)validateEndereco:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModified;



//- (BOOL)validateLastModified:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nome;



//- (BOOL)validateNome:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* observacao;



//- (BOOL)validateObservacao:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* paroco;



//- (BOOL)validateParoco:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* site;



//- (BOOL)validateSite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* telefones;



//- (BOOL)validateTelefones:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *event;

- (NSMutableSet*)eventSet;





@end

@interface _NFIgreja (CoreDataGeneratedAccessors)

- (void)addEvent:(NSSet*)value_;
- (void)removeEvent:(NSSet*)value_;
- (void)addEventObject:(NFEvent*)value_;
- (void)removeEventObject:(NFEvent*)value_;

@end

@interface _NFIgreja (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBairro;
- (void)setPrimitiveBairro:(NSString*)value;




- (NSString*)primitiveCep;
- (void)setPrimitiveCep:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveEndereco;
- (void)setPrimitiveEndereco:(NSString*)value;




- (NSDate*)primitiveLastModified;
- (void)setPrimitiveLastModified:(NSDate*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSString*)primitiveNome;
- (void)setPrimitiveNome:(NSString*)value;




- (NSString*)primitiveObservacao;
- (void)setPrimitiveObservacao:(NSString*)value;




- (NSString*)primitiveParoco;
- (void)setPrimitiveParoco:(NSString*)value;




- (NSString*)primitiveSite;
- (void)setPrimitiveSite:(NSString*)value;




- (NSString*)primitiveTelefones;
- (void)setPrimitiveTelefones:(NSString*)value;





- (NSMutableSet*)primitiveEvent;
- (void)setPrimitiveEvent:(NSMutableSet*)value;


@end
