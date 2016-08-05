//
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCommond : NSObject
+(NSDate*)dateFromString:(NSString*)str;
+(NSDateComponents*)dateComponentsWithDate:(NSDate*)date;
+(bool)isEqualWithFloat:(float)f1 float2:(float)f2 absDelta:(int)absDelta;
+(NSObject *) getUserDefaults:(NSString *) name;
+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key;
+ (NSString *)md5HexDigest:(NSString*)password;
+(NSString*)changePrice:(CGFloat)price;
@end
