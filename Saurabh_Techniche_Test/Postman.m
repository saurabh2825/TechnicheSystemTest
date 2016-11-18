//
//  ViewController.h
//  Techniche
//
//  Created by Saurabh Suman on 2016-11-14.
//  Copyright © 2016 Saurabh. All rights reserved.
//





#import "Postman.h"


@implementation Postman
-(id)init
{
   if(self=[super init])
   {
       [self initiate];
   }
    return self;
}
-(void)initiate

{
    self.manager=[AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer=[AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
   
    
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kTOKEN_KEY];
//    if (token)
//    {
//        [requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    }
    self.manager.requestSerializer=requestSerializer;
}
- (void)post:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
     NSDictionary *parameterDict = [NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    [self.manager POST:URLString parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        success(operation, responseObject);
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(operation,error);
        NSLog(@"Error");
        
        if (error.code == -1009)
        {
//            [self mbProgress:@"The Internet connection appears to be offline."];
        }
       
        
    }];
}
- (void)put:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameterDict=[NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [self.manager PUT:URLString parameters:parameterDict success:^(AFHTTPRequestOperation *operation,id responseObject) {
         success(operation, responseObject);
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        failure(operation,error);
        if (error.code == -1009)
        {
//            [self mbProgress:@"The Internet connection appears to be offline."];
        }
        
        
    }];
}

- (void)get:(NSString *)URLString withParameters:(NSString *)parameter success:(void(^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [self initiate];
 
   [self.manager GET:URLString parameters:parameter success:^(AFHTTPRequestOperation *operation,id responseObject)
    {
        success(operation,responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
       
        failure(operation,error);
        NSLog(@"%@",error);
        if (error.code == -1009)
        {
//            [self mbProgress:@"The Internet connection appears to be offline."];
        }
       
    }];
}


- (void)patch:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameterDict=[NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    [self.manager PATCH:URLString parameters:parameterDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(operation,error);
        NSLog(@"%@",error);
        if (error.code == -1009)
        {
//            [self mbProgress:@"The Internet connection appears to be offline."];
        }
       
        
    }];
    
}

//- (void)postDic:(NSString *)URLString withParameters:(NSDictionary *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    NSDictionary *parameterDict = [NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//    [self.manager POST:URLString parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject){
//        success(operation, responseObject);
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        failure(operation,error);
//        NSLog(@"Error");
//        
//        if (error.code == -1009)
//        {
//            [self mbProgress:@"The Internet connection appears to be offline."];
//        }
//        
//        
//    }];
//}



//- (void)mbProgress:(NSString*)message
//{
//    MBProgressHUD *hubHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hubHUD.mode=MBProgressHUDModeText;
//    hubHUD.detailsLabelText=message;
//    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
//    hubHUD.margin=20.f;
//    hubHUD.yOffset=150.f;
//    hubHUD.removeFromSuperViewOnHide = YES;
//    [hubHUD hide:YES afterDelay:1];
//    
//}

@end
