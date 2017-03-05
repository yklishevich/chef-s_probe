#import <Foundation/Foundation.h>
#import "ServiceModel.h"

@interface HiLife : NSObject {

    NSArray *hilife;
    NSString *status;

}

@property (nonatomic, copy) NSArray *hilife;
@property (nonatomic, copy) NSString *status;

+ (HiLife *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+ (void)getHiLife:(NSDictionary *)params
    WithURLString:(NSString *)urlPath
        onView:(UIView *)loaderOnView
    response:(void (^)(HiLife *response, NSError *error))block;

@end
