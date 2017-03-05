#import "HiLife.h"

#import "HilifeConcrete.h"

@implementation HiLife

@synthesize hilife;
@synthesize status;

+ (HiLife *)instanceFromDictionary:(NSDictionary *)aDictionary {

    HiLife *instance = [[HiLife alloc] init];
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

    if ([key isEqualToString:@"hilife"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                HilifeConcrete *populatedMember = [HilifeConcrete instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.hilife = myMembers;

        }

    } else {
        NSLog(@"Undefined key: %@", key);
        //[super setValue:value forKey:key];
    }

}

+ (void)getHiLife:(NSDictionary *)params
    WithURLString:(NSString *)urlPath
           onView:(UIView *)loaderOnView
         response:(void (^)(HiLife *response, NSError *error))block {
    
    [[ServiceModel sharedClient] POST:urlPath
                           parameters:params
                               onView:loaderOnView
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  block([HiLife instanceFromDictionary:responseObject], nil);
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  block(nil, error);
                              }];    
}

@end
