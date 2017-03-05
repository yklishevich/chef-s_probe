#import "Tempratures.h"

#import "TempratureConcrete.h"

@implementation Tempratures

@synthesize hilife;
@synthesize status;

+ (Tempratures *)instanceFromDictionary:(NSDictionary *)aDictionary {

    Tempratures *instance = [[Tempratures alloc] init];
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

    if ([key isEqualToString:@"temp"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                TempratureConcrete *populatedMember = [TempratureConcrete instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.hilife = myMembers;

        }

    } else {
        NSLog(@"Undefined key: %@", key);
        //[super setValue:value forKey:key];
    }

}

+ (void)getTemprature:(NSDictionary *)params
        WithURLString:(NSString *)urlPath
               onView:(UIView *)loaderOnView
             response:(void (^)(Tempratures *response, NSError *error))block {
    
    [[ServiceModel sharedClient] POST:urlPath
                           parameters:params
                               onView:loaderOnView
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  block([Tempratures instanceFromDictionary:responseObject], nil);
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  block(nil, error);
                              }];
    
}


@end
