//
//  Versionen.h
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceModel.h"

@interface Versionen : NSObject {
    NSArray *hilife;
    NSString *status;
}

@property (nonatomic, copy) NSArray *hilife;
@property (nonatomic, copy) NSString *status;

+ (Versionen *)instanceFromDictionary:(NSDictionary *)aDictionary;

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+ (void)getVersionen:(NSDictionary *)params
       WithURLString:(NSString *)urlPath
              onView:(UIView *)loaderOnView
            response:(void (^)(Versionen *response, NSError *error))block;



@end
