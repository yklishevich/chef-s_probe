//
//  VersionenConcrete.m
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import "VersionenConcrete.h"

@implementation VersionenConcrete

@synthesize versionenConcreteId;
@synthesize text;

+ (VersionenConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary {

    VersionenConcrete *instance = [[VersionenConcrete alloc] init];
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
        [self setValue:value forKey:@"versionenConcreteId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}


@end
