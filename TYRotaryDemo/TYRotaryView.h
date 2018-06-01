//
//  TYRotaryView.h
//  TYRotaryDemo
//
//  Created by Tiny on 2018/5/14.
//  Copyright © 2018年 hxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYRotaryView : UIView

@property (nonatomic, strong) UIButton *startButton;

//动画旋转 至 index的位置
-(void)animationWithSelectonIndex:(NSInteger)index;

//结束旋转
@property (nonatomic, copy) void (^rotaryEndTurnBlock)(void);

//按下旋转按钮
@property (nonatomic, copy) void (^rotaryStartTurnBlock)(void);

//设置旋转背景图片
-(void)lotteryImage:(NSString *)url;

@end
