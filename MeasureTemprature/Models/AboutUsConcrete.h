//
//  AboutUsConcrete.h
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutUsConcrete : NSObject {
    NSString *aboutUsConcreteId;
    NSString *text;
}

@property (nonatomic, copy) NSString *aboutUsConcreteId;
@property (nonatomic, copy) NSString *text;

+ (AboutUsConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
