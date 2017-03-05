//
//  ServiceModel.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 24/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "ServiceModel.h"
#import "UtilitiesHelper.h"

@implementation ServiceModel

//NSString *const kWebBaseUrl = @"http://www.logicalstep.de/_kunde/lh/temp/web_api.php";

NSString *const kWebBaseUrl = @"http://app.ludwigheer.de/web_api.php";

+ (instancetype)sharedClient {
    static ServiceModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ServiceModel alloc] initWithBaseURL:[NSURL URLWithString:kWebBaseUrl]];
    });
    
    return _sharedClient;
}


- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters onView:(UIView *)loaderOnView
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    if ([UtilitiesHelper isInternetConnected]) {
        [UtilitiesHelper showLoader:@"Loading" forView:loaderOnView setMode:MBProgressHUDModeIndeterminate delegate:nil];
        
        [self GET:URLString parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"Respone: %@", responseObject);
              
              [UtilitiesHelper hideLoader:loaderOnView];
              
              if ([[responseObject valueForKey:@"status"] isEqualToString:@"success"]) {
                  success(task, responseObject);
                  
              }
              else {
                  NSError *error = [[NSError alloc] initWithDomain:@"Failure"
                                                              code:0
                                                          userInfo:[NSDictionary dictionaryWithObject:@"Service failed" forKey:NSLocalizedDescriptionKey]];
                  failure(task, error);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error: %@", error);
              
              [UtilitiesHelper hideLoader:loaderOnView];
              failure(task, error);
          }];
    } else {
        NSString *errorMessage = @"Ihr Smartphone hat derzeit keine Online Verbindung. Stellen Sie sicher das Ihr Smartphone mit dem Internet verbunden ist, damit Daten geladen werden können.";
        
        NSError *error = [[NSError alloc] initWithDomain:@"Failure"
                                                    code:0
                                                userInfo:[NSDictionary dictionaryWithObject:errorMessage
                                                                                     forKey:NSLocalizedDescriptionKey]];
        failure(nil, error);
    }
    
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters onView:(UIView *)loaderOnView
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    if ([UtilitiesHelper isInternetConnected]) {
        [UtilitiesHelper showLoader:@"Loading" forView:loaderOnView setMode:MBProgressHUDModeIndeterminate delegate:nil];
        
        [self POST:URLString parameters:parameters progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"Respone: %@", responseObject);
               
               [UtilitiesHelper hideLoader:loaderOnView];
               
               if ([[responseObject valueForKey:@"status"] isEqualToString:@"success"]) {
                   success(task, responseObject);
               }
               else {
                   NSError *error = [[NSError alloc] initWithDomain:@"Failure"
                                                               code:0
                                                           userInfo:[NSDictionary dictionaryWithObject:@"Service failed" forKey:NSLocalizedDescriptionKey]];
                   failure(task, error);
               }
           }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"Error: %@", error);
               
               [UtilitiesHelper hideLoader:loaderOnView];
               failure(task, error);
           }];
        
    } else {
        NSString *errorMessage = @"Ihr Smartphone hat derzeit keine Online Verbindung. Stellen Sie sicher das Ihr Smartphone mit dem Internet verbunden ist, damit Daten geladen werden können.";
        
        NSError *error = [[NSError alloc] initWithDomain:@"Failure"
                                                    code:0
                                                userInfo:[NSDictionary dictionaryWithObject:errorMessage
                                                                                     forKey:NSLocalizedDescriptionKey]];
        failure(nil, error);
    }
}

@end
