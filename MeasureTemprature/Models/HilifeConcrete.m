#import "HilifeConcrete.h"

@implementation HilifeConcrete

@synthesize hilifeConcreteId;
@synthesize text;
@synthesize video;

+ (HilifeConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary {

    HilifeConcrete *instance = [[HilifeConcrete alloc] init];
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

    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"hilifeConcreteId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
