//
//  ViewController.m
//  TYRotaryDemo
//
//  Created by Tiny on 2018/5/14.
//  Copyright © 2018年 hxq. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "TYRotaryView.h"
#import "HXQPrizePopView.h"
#import "HXQActivityPrizeModel.h"
#import "MJExtension.h"

@interface ViewController ()

@property (nonatomic, strong) TYRotaryView *rotaryView;

@property (nonatomic, strong) HXQActivityPrizeModel *currentPrizeModel;  //当前奖品

@property (nonatomic, strong) NSMutableArray *prizeList;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //解析数据
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"prize" ofType:@"json"]];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [self.prizeList addObjectsFromArray:[HXQActivityPrizeModel mj_objectArrayWithKeyValuesArray:dict[@"datas"][@"chargePrizeList"]]];
    
    NSString *lotteryImg = dict[@"datas"][@"lotteryImg"];

    [self setupUI:lotteryImg];
}

-(void)setupUI:(NSString *)lotteryImg{
    self.rotaryView = [TYRotaryView new];
    [self.rotaryView lotteryImage:lotteryImg];
    __weak typeof(self) weakself = self;
    self.rotaryView.rotaryStartTurnBlock = ^{
        NSLog(@"开始旋转");
        [weakself starToLottery];
    };
    self.rotaryView.rotaryEndTurnBlock = ^{
        NSLog(@"旋转结束");
        //抽奖结束 次数减一
        [weakself handleEndRollAction];
    };
    [self.view addSubview:self.rotaryView];
    [self.rotaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(self.rotaryView.mas_width);
        make.center.mas_equalTo(self.view);
    }];
    
}

-(void)handleEndRollAction{
    //抽奖次数减1
    
    //抽奖结束 弹出奖品
    HXQPrizePopView *popView = [HXQPrizePopView new];
    [popView showWithModel:self.currentPrizeModel];
//    __weak typeof(self) weakself = self;
    popView.popShareBlock = ^{
        NSLog(@"分享按钮点击了");
    };
}

-(void)starToLottery{
    //判断用户是否可以抽奖
    
    //禁用按钮
//    self.rotaryView.startButton.userInteractionEnabled = NO;
    
    //发起网络请求获取当前选中奖品 由于这里需要发起网络请求(真实环境)，这里就通过随机的方式获取一次index
    NSInteger index = arc4random_uniform(8);
    NSLog(@"选中第%zi块区",index);
    
    //清理请求结束之后使能按钮
    //    self.rotaryView.startButton.userInteractionEnabled = NO;

    //拿到当前奖品的 找到其对于的位置
    self.currentPrizeModel = [self.prizeList objectAtIndex:index];

    //让转盘转起来
    [self.rotaryView animationWithSelectonIndex:index];
}

#pragma mark -
-(NSMutableArray *)prizeList{
    if (!_prizeList) {
        _prizeList = [NSMutableArray array];
    }
    return _prizeList;
}


@end
