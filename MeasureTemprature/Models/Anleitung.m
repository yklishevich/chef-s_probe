//
//  Anleitung.m
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import "Anleitung.h"

#import "AnleitungConcrete.h"

@implementation Anleitung

@synthesize hilife;
@synthesize status;

+ (Anleitung *)instanceFromDictionary:(NSDictionary *)aDictionary {

    Anleitung *instance = [[Anleitung alloc] init];
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

    if ([key isEqualToString:@"anleitung"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                AnleitungConcrete *populatedMember = [AnleitungConcrete instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.hilife = myMembers;

        }

    } else {
        NSLog(@"Undefined key: %@", key);
        //[super setValue:value forKey:key];
    }

}

+ (void)getAnleitung:(NSDictionary *)params
       WithURLString:(NSString *)urlPath
              onView:(UIView *)loaderOnView
            response:(void (^)(Anleitung *response, NSError *error))block {
    
    [[ServiceModel sharedClient] POST:urlPath
                           parameters:params
                               onView:loaderOnView
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  block([Anleitung instanceFromDictionary:responseObject], nil);
                                  
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  block(nil, error);
                              }];
}


@end
