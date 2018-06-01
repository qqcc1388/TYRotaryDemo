//
//  HXQPrizePopView.m
//  hxquan
//
//  Created by Tiny on 2018/5/21.
//  Copyright © 2018年 Tiny. All rights reserved.
//

#import "HXQPrizePopView.h"
#import "HXQActivityPrizeModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define APP_IMG(imgUrl)  [NSURL URLWithString:[imgUrl hasPrefix:@"http"] ? imgUrl : [NSString stringWithFormat:@"https:%@",imgUrl]]

@interface HXQPrizePopView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) HXQActivityPrizeModel *model;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation HXQPrizePopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.bounds = [UIScreen mainScreen].bounds;
    self.maskView = [UIView new];
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    //设置ImgeView
    UIView *centerView = [UIView new];
    centerView.layer.cornerRadius = 10;
    [centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTouchAction)]];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.maskView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.maskView);
        make.size.mas_equalTo(CGSizeMake(201, 201));
    }];
    
    UIImageView *leftImgView = [UIImageView new];
    leftImgView.image = [UIImage imageNamed:@"icon_zhongjiangla"];
    [self.maskView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(centerView.mas_top);
        make.left.mas_equalTo(centerView.mas_left);
        make.width.mas_equalTo(201*0.5);
    }];
    
    UIImageView *rightImgView = [UIImageView new];
    rightImgView.image = [UIImage imageNamed:@"icon_prize_emoji"];
    [self.maskView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(centerView.mas_top);
        make.right.mas_equalTo(centerView.mas_right);
        make.width.mas_equalTo(201*0.5);
    }];
    
    self.imgView = [UIImageView new];
    [centerView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView);
        make.top.mas_offset(36);
        make.size.mas_equalTo(CGSizeMake(100,100));
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView);
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_offset(5);
    }];
    
    UIButton *shareButton = [UIButton new];
    shareButton.backgroundColor = [UIColor colorWithRed:252/255.0 green:98/255.0 blue:97/255.0 alpha:1];
    shareButton.layer.cornerRadius = 21*0.5;
    shareButton.layer.masksToBounds = YES;
    shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareButton setTitle:@"炫耀一下" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    [centerView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(83, 21));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(13);
        make.centerX.mas_equalTo(centerView);
    }];
    
    self.closeButton = [UIButton new];
    [self.closeButton setImage:[UIImage imageNamed:@"prize_show_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.closeButton];

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerView.mas_bottom);
        make.centerX.mas_equalTo(centerView.mas_centerX);
    }];
}

-(void)shareAction{
    NSLog(@"分享");
    if (self.popShareBlock) {
        self.popShareBlock();
    }
    [self dismiss];
}

-(void)adTouchAction{
    
}

-(void)showWithModel:(HXQActivityPrizeModel *)model{
    self.model = model;
    
    [self.imgView sd_setImageWithURL:APP_IMG(model.icon)];
    self.titleLabel.text = [NSString stringWithFormat:@"%@x%@",model.prizeName,model.winnerNum];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    //让视图显示出来
    self.maskView.layer.position = self.center;
    self.maskView.transform = CGAffineTransformMakeScale(0.80, 0.80);
    [UIView animateWithDuration:0.25 delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.maskView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismiss{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        self.maskView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
