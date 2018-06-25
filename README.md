转盘抽奖游戏在一般的app中都会有，应该算是一种吸引用户的一种手段。在项目中集成转盘抽奖游戏，大都采用h5的方式来实现，但是由于项目需求，需要在app中使用原生来实现转盘抽奖。实现原理也很简单，中间的一个图片姑且把它叫做转盘好了，当用户点击抽奖的时候，跟服务器做一次请求，拿到当前用户即将获得的奖品，根据奖品的位置，让转盘旋转对应的时间，和对应的圈数，最后定位到抽奖的位置，转盘结束转动，弹窗让用户知晓自己的中奖情况。
    好了，废话说到这里，直接上效果图：

<img src="https://github.com/qqcc1388/TYRotaryDemo/blob/master/ezgif.com-video-to-gif.gif" width="40%" height="40%">

核心代码：
```
#define perSection    M_PI*2/8

-(void)animationWithSelectonIndex:(NSInteger)index{
    
    [self backToStartPosition];
    self.startButton.enabled = NO;
    self.needleImgView.image = [UIImage imageNamed:@"lottery_start_needle_noenable"];
    self.textImgView.image = [UIImage imageNamed:@"lottery_state_zhong"];
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    //先转4圈 再选区 顺时针(所以这里需要用360-对应的角度) 逆时针不需要
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
```

更多源码请参考demo: https://github.com/qqcc1388/TYRotaryDemo

转载请标注来源：https://www.cnblogs.com/qqcc1388/p/9121877.html
