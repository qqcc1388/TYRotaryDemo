//
//  HXQPrizePopView.h
//  hxquan
//
//  Created by Tiny on 2018/5/21.
//  Copyright © 2018年 Tiny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXQActivityPrizeModel;
@interface HXQPrizePopView : UIView

-(void)showWithModel:(HXQActivityPrizeModel *)model;

@property (nonatomic, copy) void (^popShareBlock)(void);

@end
