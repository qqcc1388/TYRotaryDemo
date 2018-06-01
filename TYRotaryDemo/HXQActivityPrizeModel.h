//
//  HXQActivityPrizeModel.h
//  hxquan
//
//  Created by Tiny on 2018/5/17.
//  Copyright © 2018年 Tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXQActivityPrizeModel : NSObject

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *createTimeStr;

//@property (nonatomic, copy) NSString *ID;  //抽奖Id

@property (nonatomic, copy) NSString *prizeId;  //奖品ID

@property (nonatomic, copy) NSString *prizeName; //奖品名称

@property (nonatomic, copy) NSString *prizeNum;  //奖品数量

@property (nonatomic, copy) NSString *winnerNum;

@property (nonatomic, copy) NSString *icon;

@end
