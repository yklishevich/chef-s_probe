//
//  Versionen.m
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import "Versionen.h"

#import "VersionenConcrete.h"

@implementation Versionen

@synthesize hilife;
@synthesize status;

+ (Versionen *)instanceFromDictionary:(NSDictionary *)aDictionary {

    Versionen *instance = [[Versionen alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"versionen"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                VersionenConcrete *populatedMember = [VersionenConcrete instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.hilife = myMembers;

        }

    } else if ([key isEqualToString:@"verkaufsstellen"]) {
        
        if ([value isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                VersionenConcrete *populatedMember = [VersionenConcrete instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            
            self.hilife = myMembers;
            
        }
        
    } else {
        NSLog(@"Undefined key: %@", key);
        //[super setValue:value forKey:key];
    }

}

+ (void)getVersionen:(NSDictionary *)params
       WithURLString:(NSString *)urlPath
              onView:(UIView *)loaderOnView
            response:(void (^)(Versionen *response, NSError *error))block {
    
    [[ServiceModel sharedClient] POST:urlPath
                           parameters:params
                               onView:loaderOnView
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  block([Versionen instanceFromDictionary:responseObject], nil);
                                  
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  block(nil, error);
                              }];
}


@end
