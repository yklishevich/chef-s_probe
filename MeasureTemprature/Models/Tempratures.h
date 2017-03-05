#import <Foundation/Foundation.h>
#import "ServiceModel.h"

@interface Tempratures : NSObject {

    NSArray *hilife;
    NSString *status;

}

@property (nonatomic, copy) NSArray *hilife;
@property (nonatomic, copy) NSString *status;

+ (Tempratures *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+ (void)getTemprature:(NSDictionary *)params
        WithURLString:(NSString *)urlPath
               onView:(UIView *)loaderOnView
             response:(void (^)(Tempratures *response, NSError *error))block;


@end
