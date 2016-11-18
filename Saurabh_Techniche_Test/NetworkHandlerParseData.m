//
//  NetworkHandlerParseData.m
//  Saurabh_Techniche_Test
//
//  Created by Saurabh Suman on 2016-11-17.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import "NetworkHandlerParseData.h"
#import "Postman.h"
#import "HomeModel.h"
#define  NULL_CHECKER(X) [X isKindOfClass:[NSNull class]]?nil:X

@implementation NetworkHandlerParseData
{
    Postman *postMan;
    
}


+ (NetworkHandlerParseData *)shareManger {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[NetworkHandlerParseData alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    [self initizialize];
    
    return self;
}

- (void)initizialize
{
    postMan = [[Postman alloc] init];
    
}




-(void)foodListDataFromAPI :(void (^) (BOOL success ,NSMutableArray *totalfoodArr))serviceSuccess
{
    NSString *urlString = @"http://52.11.109.130:3000/testing/productList";
    
    
    
    
    
    [postMan get:urlString withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *searchData=[self parseProductData:responseObject];
        if (searchData) {
            serviceSuccess(true,searchData);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSArray *searchData=[self parseProductData:operation.responseObject];
        if (searchData) {
            serviceSuccess(false,searchData);
        }
        
    }];


}
- (NSMutableArray *)parseProductData:(NSDictionary *)response
{
    NSMutableArray *foodListArray =[[NSMutableArray alloc]init];
    NSDictionary *dict = response;
    for (NSDictionary *aJob in dict)
    {
        
        HomeModel *hModel=[[HomeModel alloc]init];
        hModel.foodCategoryName=NULL_CHECKER(aJob[@"name"]);
        hModel.id=NULL_CHECKER(aJob[@"_id"]);
        hModel.foodArr=NULL_CHECKER(aJob[@"childrens"]);
        [foodListArray addObject:hModel];
    }
    return foodListArray;
}


@end
