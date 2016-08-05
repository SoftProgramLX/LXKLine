//
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXSingleton : NSObject

@property (nonatomic,assign) NSInteger lastPointIndex;
@property (nonatomic,assign) NSInteger kCount;
+ (LXSingleton *)sharedLXSingleton;

@end







