//
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXColorModel;
@interface UIColor (helper)

+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;
+ (LXColorModel *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

@end
