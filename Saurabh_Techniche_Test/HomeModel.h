//
//  HomeModel.h
//  Saurabh_Techniche_Test
//
//  Created by Amit Kumar on 2016-11-17.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property(nonatomic,strong)NSMutableArray *segmentArr;
@property(nonatomic,strong)NSMutableArray *foodArr;
@property(nonatomic,strong)NSMutableArray *itemArr;

@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *foodCategoryName;




@end
