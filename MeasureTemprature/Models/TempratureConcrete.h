#import <Foundation/Foundation.h>

@interface TempratureConcrete : NSObject {

    NSString *degree;
    NSString *descriptionText;
    NSString *tempratureConcreteId;
    NSString *image;

}

@property (nonatomic, copy) NSString *degree;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *tempratureConcreteId;
@property (nonatomic, copy) NSString *image;

+ (TempratureConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
