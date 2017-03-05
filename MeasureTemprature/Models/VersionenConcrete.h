//
//  VersionenConcrete.h
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionenConcrete : NSObject {
    NSString *versionenConcreteId;
    NSString *text;
}

@property (nonatomic, copy) NSString *versionenConcreteId;
@property (nonatomic, copy) NSString *text;

+ (VersionenConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
