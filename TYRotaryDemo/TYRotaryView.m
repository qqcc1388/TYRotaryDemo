//
//  TYRotaryView.m
//  TYRotaryDemo
//
//  Created by Tiny on 2018/5/14.
//  Copyright © 2018年 hxq. All rights reserved.
//
#import "TYRotaryView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define perSection    M_PI*2/8

@interface TYRotaryView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *gameBgView;
@property (nonatomic, assign) CGFloat lastAngle;
@property (nonatomic, strong) UIImageView *needleImgView;
@property (nonatomic, strong) UIImageView *textImgView;

@end

@implementation TYRotaryView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.gameBgView = [UIImageView new];
    self.gameBgView.layer.masksToBounds = YES;
    self.gameBgView.layer.cornerRadius =  (([UIScreen mainScreen].bounds.size.width) - 40)*0.5f;
    [self addSubview:self.gameBgView];
    [self.gameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    self.needleImgView = [UIImageView new];
    self.needleImgView.image = [UIImage imageNamed:@"lottery_start_needle_enable"];
    [self addSubview:self.needleImgView];
    
    self.startButton = [UIButton new];
    [self.startButton setImage:[UIImage imageNamed:@"lottery_startbg_enable"] forState:UIControlStateNormal];
    [self.startButton setImage:[UIImage imageNamed:@"lottery_startbg_noenable"] forState:UIControlStateDisabled];
    
    [self.startButton addTarget:self action:@selector(itemClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.startButton];
    
    self.textImgView = [UIImageView new];
    self.textImgView.image = [UIImage imageNamed:@"lottery_state_start"];
    [self addSubview:self.textImgView];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [self.needleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(15);
    }];
    
    [self.textImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

-(void)itemClick{
    if (self.rotaryStartTurnBlock) {
        self.rotaryStartTurnBlock();
    }
}

-(void)lotteryImage:(NSString *)url{
    [self.gameBgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

-(void)animationWithSelectonIndex:(NSInteger)index{
    
    [self backToStartPosition];
    self.startButton.enabled = NO;
    self.needleImgView.image = [UIImage imageNamed:@"lottery_start_needle_noenable"];
    self.textImgView.image = [UIImage imageNamed:@"lottery_state_zhong"];
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    //先转4圈 再选区 顺时针(所有这里需要用360-对应的角度) 逆时针不需要
    layer.toValue = @((M_PI*2 - (perSection*index +perSection*0.5)) + M_PI*2*4);
    layer.duration = 4;
    layer.removedOnCompletion = NO;
    layer.fillMode = kCAFillModeForwards;
    layer.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    layer.delegate = self;
    
    [self.gameBgView.layer addAnimation:layer forKey:nil];
}

-(void)backToStartPosition{
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    layer.toValue = @(0);
    layer.duration = 0.001;
    layer.removedOnCompletion = NO;
    layer.fillMode = kCAFillModeForwards;
    [self.gameBgView.layer addAnimation:layer forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    //设置指针返回初始位置
    self.startButton.enabled = YES;
    self.needleImgView.image = [UIImage imageNamed:@"lottery_start_needle_enable"];
    self.textImgView.image = [UIImage imageNamed:@"lottery_state_start"];
    if (self.rotaryEndTurnBlock) {
        self.rotaryEndTurnBlock();
    }
}
@end
