//
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import "LXTopButtonScrollView.h"

#define BUTTONGAP 5 //button之间不能点击的间隙

@interface LXTopButtonScrollView()
{
    CGFloat _buttonWidth;
    CGFloat _buttonHeight;
    
    NSInteger _selectedButtonID; //点击按钮选择title的ID
    UIImageView *_shadowImageView;
} 
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation LXTopButtonScrollView


- (id)initWithFrame:(CGRect)frame andTitleArray:(NSArray*)titleArray andDelegate:(id<LXTopViewSelectDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = NZColor(230, 230, 230);
        self.titleArray = titleArray;
        self.delegate = delegate;
        _buttonWidth = (frame.size.width-(titleArray.count-1)*BUTTONGAP)/titleArray.count;
        _buttonHeight = frame.size.height;
        _selectedButtonID = 1;
        
        [self initWithNameButtons];
    }
    return self;
}

- (void)initWithNameButtons
{
    _shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _buttonWidth, _buttonHeight)];
    [_shadowImageView setImage:[UIImage imageNamed:@"icon_bg_tab"]];
    [self addSubview:_shadowImageView];
    
    for (int i = 0; i < [self.titleArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake((BUTTONGAP+_buttonWidth)*i, 0, _buttonWidth, _buttonHeight)];
        [button setTag:i+1];
        if (i == 0) {
            button.selected = YES;
        }
        [button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
        [button setTitle:[NSString stringWithFormat:@"%@",[self.titleArray objectAtIndex:i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor: NZColor(255, 0, 0) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}

- (void)changeBtnStatus:(NSInteger)senderTag
{
    UIButton *lastButton = (UIButton *)[self viewWithTag:senderTag];
    [self selectNameButton:lastButton];
}

- (void)selectNameButton:(UIButton *)sender
{
    [self setButtonUnSelect:sender.tag];
    
    //按钮非选中状态
    if (!sender.selected) {
        
        if ([self.delegate respondsToSelector:@selector(buttonDidSelected:)]) {
            [self.delegate buttonDidSelected:sender.tag];
        }
        [self setButtonSelect:sender];
    }
    //重复点击选中按钮
    else {
        if ([self.delegate respondsToSelector:@selector(clickedSameButton)]) {
            [self.delegate clickedSameButton];
        }
    }
    
}

- (void)scrollToIndexButton:(NSInteger)index
{
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:index];
    if (!button.selected) {
        [self setButtonSelect:button];
    }
    
    [self setButtonUnSelect:index];
}

//滑动撤销选中按钮
- (void)setButtonUnSelect:(NSInteger)index{
    //滑动撤销选中按钮
    if (index != _selectedButtonID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:_selectedButtonID];
        lastButton.selected = NO;
        //赋值按钮ID
        _selectedButtonID = index;
    }
}

//滑动选择按钮
- (void)setButtonSelect:(UIButton *)button{
    [UIView animateWithDuration:0.25 animations:^{
        
        [_shadowImageView setFrame:CGRectMake(button.frame.origin.x, 0, _buttonWidth, _buttonHeight)];
        
        button.selected = YES;
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}
@end


