#import <Foundation/Foundation.h>

@interface HilifeConcrete : NSObject {

    NSString *hilifeConcreteId;
    NSString *text;
    NSString *video;

}

@property (nonatomic, copy) NSString *hilifeConcreteId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *video;

+ (HilifeConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
