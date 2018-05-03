//
//  ViewController.m
//  CABasicAnimation
//
//  Created by zhph on 2018/2/28.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)CALayer * layer;
@property (weak, nonatomic) IBOutlet UIImageView *transitionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer * layer =[CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.bounds=CGRectMake(100, 100, 100, 100);
    layer.anchorPoint=CGPointZero;
    layer.position=CGPointMake(100, 100);
    [self.view.layer addSublayer:layer];
    self.layer= layer;
    
    self.transitionView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.transitionView addGestureRecognizer:tap];
}

#pragma mark 转场动画
-(void)tapAction:(UITapGestureRecognizer*)tap{
    
    UIImageView * imageView = (UIImageView*)tap.view;
    if ([imageView.image isEqual:[UIImage imageNamed:@"2.png"]]) {
        self.transitionView.image=[UIImage imageNamed:@"meinv.jpg"];
    }else{
        self.transitionView.image=[UIImage imageNamed:@"2.png"];
    }
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    /*私有API
     cube                   立方体效果
     pageCurl               向上翻一页
     pageUnCurl             向下翻一页
     rippleEffect           水滴波动效果
     suckEffect             变成小布块飞走的感觉
     oglFlip                上下翻转
     cameraIrisHollowClose  相机镜头关闭效果
     cameraIrisHollowOpen   相机镜头打开效果
     */
    transition.type = @"cube";//转场的效果
    //transition.type = kCATransitionMoveIn;
    //下面四个是系统公有的API
    //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    transition.subtype = kCATransitionFromRight;//转场的方向
    //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom

    [self.transitionView.layer addAnimation:transition forKey:@"transition"];
    
}

#pragma mark animationGroup
-(void)testAnimationGroup{
    
    CABasicAnimation * ani =[CABasicAnimation animation];
    ani.keyPath = @"transform.rotation";//动画形式 transform  bounds  KVC的键路径  transform.translation 旋转的键值  transform.scale 缩放 transform.rotation 移动 transform.scale.x -》x方向旋转
    //结束点
    ani.toValue = @(M_PI_4);
    //动画结束不移除动画
    ani.removedOnCompletion =NO;
    //保持动画的请进状态
    ani.fillMode = kCAFillModeForwards;
    //动画过程
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    
    CABasicAnimation * ani1 =[CABasicAnimation animation];
    ani1.keyPath = @"position";
    //结束点
    ani1.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    //动画结束不移除动画
    ani1.removedOnCompletion =NO;
    //保持动画的请进状态
    ani1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation * ani2 =[CABasicAnimation animation];
    ani2.keyPath = @"transform.scale";
    //结束点
    ani2.toValue = @(2.0);
    //动画结束不移除动画
    ani2.removedOnCompletion =NO;
    //保持动画的请进状态
    ani2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup * aniGroup =[CAAnimationGroup animation];
    aniGroup.animations=@[ani,ani1,ani2];
    [self.layer addAnimation:aniGroup forKey:@"group"];
    
}

#pragma mark CABasicAnimation只能实现两个点之间的动画
-(void)testTransformAnimation{
    
    CABasicAnimation * ani =[CABasicAnimation animation];
    ani.keyPath = @"transform.rotation";//动画形式 transform  bounds  KVC的键路径  transform.translation 旋转的键值  transform.scale 缩放 transform.rotation 移动 transform.scale.x -》x方向旋转
    //结束点
    ani.toValue = @(M_PI_4);
    //动画结束不移除动画
    ani.removedOnCompletion =NO;
    //保持动画的请进状态
    ani.fillMode = kCAFillModeForwards;
    //动画执行时间
    ani.duration = 2.0f;
    //动画过程
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer addAnimation:ani forKey:@"position"];
}

-(void)testTransitionAnimation{
    
    CABasicAnimation * ani =[CABasicAnimation animationWithKeyPath:@"position"];
    ani.keyPath = @"position";//动画形式 transform  bounds  KVC的键路径
    //起始点
    ani.fromValue=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
    //结束点
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    //叠加值 本来 100，100 -》 300，300
    ani.byValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    //动画结束不移除动画  防止动画结束后回到初始状态
    ani.removedOnCompletion =NO;
    //保持动画的请进状态
    ani.fillMode = kCAFillModeBackwards;//该属性定义了你的动画在开始和结束时的动作  kCAFillModeRemoved 设置为该值，动画将在设置的 beginTime 开始执行（如没有设置beginTime属性，则动画立即执行），动画执行完成后将会layer的改变恢复原状。  kCAFillModeForwards 设置为该值，动画即使之后layer的状态将保持在动画的最后一帧，而removedOnCompletion的默认属性值是 YES，所以为了使动画结束之后layer保持结束状态，应将removedOnCompletion设置为NO。kCAFillModeBackwards 设置为该值，将会立即执行动画的第一帧，不论是否设置了 beginTime属性。观察发现，设置该值，刚开始视图不见，还不知道应用在哪里。kCAFillModeBoth 该值是 kCAFillModeForwards 和 kCAFillModeBackwards的组合状态
    
    //单次动画执行时间
    ani.duration = 2.0f;
    //动画执行的次数
    ani.repeatCount= MAXFLOAT;
    //动画执行速度
    ani.speed=3;
    //是否自动反转回来
    ani.autoreverses=YES;
    //设置动画执行的总时间。在该时间内动画一直执行，不计次数。
    ani.repeatDuration=4;
    //指定动画开始的时间。从开始延迟几秒的话，设置为【CACurrentMediaTime() + 秒数】 的方式
    ani.beginTime= CACurrentMediaTime() +2;
    //动画过程
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    /*
     * kCAMediaTimingFunctionLinear 传这个值，在整个动画时间内动画都是以一个相同的速度来改变。也就是匀速运动
     * kCAMediaTimingFunctionEaseIn 使用该值，动画开始时会较慢，之后动画会加速。
     * kCAMediaTimingFunctionEaseOut 使用该值，动画在开始时会较快，之后动画速度减慢。
     * kCAMediaTimingFunctionEaseInEaseOut 使用该值，动画在开始和结束时速度较慢，中间时间段内速度较快
     */
    [self.layer addAnimation:ani forKey:@"position"];
}


/*keyFrame动画*/
-(void)testKeyFrameAnimation{
    
    CAKeyframeAnimation * frameAni =[CAKeyframeAnimation animation];
    frameAni.keyPath=@"position";
    frameAni.values = @[[NSValue valueWithCGPoint:CGPointMake(100, 100)],[NSValue valueWithCGPoint:CGPointMake(300, 100)],[NSValue valueWithCGPoint:CGPointMake(300, 300)],[NSValue valueWithCGPoint:CGPointMake(100, 300)],[NSValue valueWithCGPoint:CGPointMake(300, 100)]];
    frameAni.duration=2.0f;
    //动画结束不移除动画
    frameAni.removedOnCompletion =NO;
    //保持动画的请进状态
    frameAni.fillMode = kCAFillModeForwards;
    frameAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:frameAni forKey:@"frame"];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    [self testTransitionAnimation];
//    [self testTransformAnimation];
//    [self testKeyFrameAnimation];
    [self testTransitionAnimation];
    
}

@end
