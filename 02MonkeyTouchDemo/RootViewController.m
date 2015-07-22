//
//  RootViewController.m
//  02MonkeyTouchDemo
//
//  Created by sunhao on 15-7-21.
//  Copyright (c) 2015年 SH. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RootViewController ()
{
    UIImageView * _imageMonkey;
    AVAudioPlayer *_player;
    
    /**
     记录点击次数
     */
    NSInteger _recordTapCount;
    /**
     开始的时间
     */
    NSDate * _recordTapBeginDate;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageMonkey = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"monkey"]];
    _imageMonkey.frame = CGRectMake(20, 20, 70, 84);
    [self.view addSubview:_imageMonkey];
    
    
    //Enabled
    // default is NO
    //多点触摸 or 
    self.view.multipleTouchEnabled = YES;
    
    
    
    NSString *soundPath = [[ NSBundle mainBundle]pathForResource:@"tickleSound" ofType:@"wav"];
    NSURL * soundUrl = [NSURL fileURLWithPath:soundPath];
    
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    
}


//记录参数重置

- (void)resetDoubleTapParameters{

    _recordTapBeginDate = nil;
    _recordTapCount = 0;
}


//touches 多个手指UITouch 1根手指就是一根UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    
    NSLog(@"touchesBegan%tu",touches.count);
    
    //touches.count == 1真正的工程写成 #define
    //|| touches.count == 2
    if (touches.count == 1) {
        
        //以某个为参数的对象
        UITouch * touch = touches.anyObject;
        _imageMonkey.center = [touch locationInView:self.view];
        
        
        //核心算法
        if (_recordTapCount) {
            _recordTapCount++;
            _recordTapBeginDate = [NSDate date];
        }else if (_recordTapCount < 2){
        
            _recordTapCount++;
        }
        
    }
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    
    //当点击两次的时候，发出声音
    if (touches.count == 1) {
        
        NSLog(@"began %ld",touches.count);
        if (_recordTapCount == 2) {
            //为2
            
            NSDate * endDate = [NSDate date];
            NSTimeInterval interval = [endDate timeIntervalSinceDate:_recordTapBeginDate];
            
            if (interval < 0.75) {
                
                [_player play];
                
            }
            [self resetDoubleTapParameters];
        }
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"touchesMoved%tu",touches.count);
    
    
    [self resetDoubleTapParameters];
    if (touches.count == 1) {
        UITouch * touch = touches.anyObject;
        _imageMonkey.center = [touch locationInView:self.view];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
