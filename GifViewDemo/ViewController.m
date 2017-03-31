//
//  ViewController.m
//  GifViewDemo
//
//  Created by 杨朋 on 2017/3/31.
//  Copyright © 2017年 Friend. All rights reserved.
//

#import "ViewController.h"
#import "POP.h"
#import "GifView.h"

#define kAppearanceColor  [UIColor colorWithRed:250/255.0 green:60/255.0 blue:67/255.0 alpha:1.0]
#define KMainScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainFont   [UIFont fontWithName:@"BigYoungMediumGB2.0" size:16]
#define kNavBarFont [UIFont fontWithName:@"BigYoungMediumGB2.0" size:18]

@interface ViewController ()

@end

@implementation ViewController
{
    
    GifView  *_gifView ;
    UIButton *_rightBtn;
    UIImageView *_springView ;
    BOOL _isOpened ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  configureNav];
    [self  createGifView];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 设置导航栏
- (void)configureNav {
    
    self.title = @"支持拖动改变大小";
    
    [self.navigationController.navigationBar setBarTintColor:kAppearanceColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,kNavBarFont,NSFontAttributeName,nil]];
    _rightBtn = [UIButton buttonWithType:0];
    _rightBtn.frame = CGRectMake(0, 0, 100, 30);
    [_rightBtn setTitle:@"添加GIF" forState:0];
    _rightBtn.titleLabel.font = kMainFont ;
    [_rightBtn addTarget:self action:@selector(rightBarbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = item ;
}


#pragma mark - 创建动画视图
- (void)createGifView {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AK47" ofType:@"gif"];
    _gifView = [[GifView alloc] initWithFrame:CGRectMake(KMainScreenWidth, 64, 0, 0) filePath:path];
    _gifView.backgroundColor = [UIColor whiteColor];
    _gifView.userInteractionEnabled = YES ;
    [self.view addSubview:_gifView];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(changeSize:)];
    [_gifView addGestureRecognizer:gesture];
}

#pragma mark - 右边点击
- (void)rightBarbuttonClick {
    
    if (_isOpened) {
        [self hidePop];
        [_rightBtn setTitle:@"添加GIF" forState:0];
        return;
    }
    [_rightBtn setTitle:@"隐藏GIF" forState:0];
    _isOpened = YES;
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    positionAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(KMainScreenWidth, 64, 0, 0)];
    positionAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(KMainScreenWidth- KMainScreenWidth , 64, KMainScreenWidth , KMainScreenWidth / 1.77)];
    positionAnimation.springBounciness = 20.0f;
    positionAnimation.springSpeed = 20.0f;
    [_gifView pop_addAnimation:positionAnimation forKey:@"frameAnimation"];

}

- (void)hidePop{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    positionAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(KMainScreenWidth- KMainScreenWidth, 64, KMainScreenWidth , KMainScreenWidth / 1.77)];
    positionAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(KMainScreenWidth, 64, 0, 0)];
    //key一样就会用后面的动画覆盖之前的
    [_gifView pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
    
    _isOpened = NO;
    
}


- (void)changeSize:(UIPanGestureRecognizer*)tap{
    CGPoint point = [tap locationInView:self.view];
    if (point.y < KMainScreenWidth / 1.77) {
        
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        NSLog(@"y=(%f),x=(%f)",point.y,point.x);
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(KMainScreenWidth-(point.y)*1.77, 64, point.y*1.77, point.y)];
        //弹性值
        springAnimation.springBounciness = 20.0;
        //弹性速度
        springAnimation.springSpeed = 20.0;
        
        [_gifView pop_addAnimation:springAnimation forKey:@"changeframe"];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
