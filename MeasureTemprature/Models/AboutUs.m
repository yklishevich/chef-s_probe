//
//  AboutUs.m
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import "AboutUs.h"

#import "AboutUsConcrete.h"

@implementation AboutUs

@synthesize aboutus;
@synthesize status;

+ (AboutUs *)instanceFromDictionary:(NSDictionary *)aDictionary {

    AboutUs *instance = [[AboutUs alloc] init];
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

    if ([key isEqualToString:@"aboutus"]) {

        if ([value isKindOfClass:[NSDictionary class]]) {
            self.aboutus = [AboutUsConcrete instanceFromDictionary:value];
        }

    } else {
        NSLog(@"Undefined key: %@", key);
        //[super setValue:value forKey:key];
    }

}

+ (void)getAboutUs:(NSDictionary *)params
     WithURLString:(NSString *)urlPath
            onView:(UIView *)loaderOnView
          response:(void (^)(AboutUs *response, NSError *error))block {
    
    [[ServiceModel sharedClient] POST:urlPath
                           parameters:params
                               onView:loaderOnView
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  block([AboutUs instanceFromDictionary:responseObject], nil);
                                  
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  block(nil, error);
                                  
                              }];
}



@end
