//
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import "LXSingleton.h"
#import "SynthesizeSingleton.h"

@interface LXSingleton ()
{
    
}

@end

@implementation LXSingleton

// 使用宏采用的是GCD方法定义了单例
SYNTHESIZE_SINGLETON_FOR_CLASS(LXSingleton);

// 当第一次使用这个单例时，会调用这个init方法。
- (id)init
{
    self = [super init];
    if (self) {
        self.lastPointIndex = 0;
        self.kCount = 0;
    }
    return self;
}

@end



