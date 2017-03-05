#import "TempratureConcrete.h"

@implementation TempratureConcrete

@synthesize degree;
@synthesize descriptionText;
@synthesize tempratureConcreteId;
@synthesize image;

+ (TempratureConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary {

    TempratureConcrete *instance = [[TempratureConcrete alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionText"];
    } else if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"tempratureConcreteId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
