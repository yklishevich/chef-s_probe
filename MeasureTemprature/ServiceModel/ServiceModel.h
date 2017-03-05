//
//  ServiceModel.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 24/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFHTTPSessionManager.h"


@interface ServiceModel : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters onView:(UIView *)loaderOnView
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters onView:(UIView *)loaderOnView
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
