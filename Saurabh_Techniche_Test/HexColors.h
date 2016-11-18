//
//  ViewController.h
//  Techniche
//
//  Created by Saurabh Suman on 2016-11-14.
//  Copyright © 2016 Saurabh. All rights reserved.
//


#import "TargetConditionals.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  #import <UIKit/UIKit.h>
  #define HXColor UIColor
#else
  #import <Cocoa/Cocoa.h>
  #define HXColor NSColor
#endif

@interface HXColor (HexColorAddition)

+ (HXColor *)colorWithHexString:(NSString *)hexString;
+ (HXColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (HXColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (HXColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
