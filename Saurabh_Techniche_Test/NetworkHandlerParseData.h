//
//  NetworkHandlerParseData.h
//  Saurabh_Techniche_Test
//
//  Created by Saurabh Suman on 2016-11-17.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHandlerParseData : NSObject

+ (NetworkHandlerParseData *)shareManger;


-(void)foodListDataFromAPI :(void (^) (BOOL success ,NSMutableArray *totalfoodArr))serviceSuccess;


@end
