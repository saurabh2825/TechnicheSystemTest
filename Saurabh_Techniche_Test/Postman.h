//
//  ViewController.h
//  Techniche
//
//  Created by Saurabh Suman on 2016-11-14.
//  Copyright © 2016 Saurabh. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>



@interface Postman : NSObject
@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;
- (void)post:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)put:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)get:(NSString *)URLString withParameters:(NSString *)parameter success:(void(^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)patch:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
