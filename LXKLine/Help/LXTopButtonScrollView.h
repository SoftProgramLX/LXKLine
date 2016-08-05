//
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXTopViewSelectDelegate <NSObject>

//点击了按钮的回调方法
- (void)buttonDidSelected:(NSInteger)selectedIndex;

@optional
- (void)clickedSameButton;

@end


@interface LXTopButtonScrollView : UIView

@property (nonatomic, weak)id<LXTopViewSelectDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andTitleArray:(NSArray*)titleArray andDelegate:(id<LXTopViewSelectDelegate>)delegate;

//滚动视图滚动时需要调用的方法
- (void)changeBtnStatus:(NSInteger)senderTag;

//改变按钮状态
- (void)scrollToIndexButton:(NSInteger)index;

@end


