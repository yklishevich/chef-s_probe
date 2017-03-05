//
//  AnleitungConcrete.m
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import "AnleitungConcrete.h"

@implementation AnleitungConcrete

@synthesize descriptionText;
@synthesize document;
@synthesize anleitungConcreteId;

+ (AnleitungConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary {

    AnleitungConcrete *instance = [[AnleitungConcrete alloc] init];
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
        [self setValue:value forKey:@"anleitungConcreteId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}


@end
