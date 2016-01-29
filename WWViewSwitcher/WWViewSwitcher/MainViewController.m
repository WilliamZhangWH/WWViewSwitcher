//
//  MainViewController.m
//  WWViewSwitcher
//
//  Created by 天奕 on 16/1/29.
//  Copyright © 2016年 WilliamZhangWH. All rights reserved.
//

#import "MainViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define DURATION 0.5

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIView *insideView;
@property (strong, nonatomic) IBOutlet UIView *outsideView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.insideView];
    [self.view addSubview:self.outsideView];
    self.insideView.translatesAutoresizingMaskIntoConstraints = NO;
    self.outsideView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.insideView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.insideView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.outsideView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.outsideView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /* 获得主页显示位置 */
    NSInteger positionOfOutsideView = [self.view.subviews indexOfObject:self.outsideView];
    /* 记录原始页面位置 */
    CATransform3D outsideOriginTransform = self.outsideView.layer.transform;
    CATransform3D insideOriginTransform = self.insideView.layer.transform;
    
    CALayer *outsideLayer = self.outsideView.layer;
    __block CATransform3D outsideRotationAndPerspectiveTransform = CATransform3DIdentity;
    
    /* 获得主页推后位置 */
    outsideRotationAndPerspectiveTransform.m43 = -500;
    CATransform3D changedOutsideRotationTransform = outsideRotationAndPerspectiveTransform;
    
    CALayer *insideLayer = self.insideView.layer;
    __block CATransform3D insideRotationAndPerspectiveTransform = CATransform3DIdentity;
    
    /* 获得附页推后位置 */
    insideRotationAndPerspectiveTransform.m43 = -500;
    CATransform3D changeInsideRotationTransform = insideRotationAndPerspectiveTransform;
    
    if (0 == positionOfOutsideView) {/* 主页在后 */
        outsideLayer.transform = changedOutsideRotationTransform;
    }else{ /* 主页在前 */
        insideLayer.transform = changeInsideRotationTransform;
    }
    
    /* 展开动画 */
    [UIView animateWithDuration:DURATION animations:^{
        /* 主页动画变换 */
        outsideRotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        outsideRotationAndPerspectiveTransform.m41 = WIDTH/3;
        outsideRotationAndPerspectiveTransform.m11 = 0.6;
        outsideRotationAndPerspectiveTransform.m22 = 0.6;
        outsideRotationAndPerspectiveTransform = CATransform3DRotate(outsideRotationAndPerspectiveTransform, M_PI / 3, 0.0f, -1.0f, 0.0f);
        outsideLayer.transform = outsideRotationAndPerspectiveTransform;
        
        /* 附页动画变换 */
        insideRotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        insideRotationAndPerspectiveTransform.m41 = -WIDTH/3;
        insideRotationAndPerspectiveTransform.m11 = 0.6;
        insideRotationAndPerspectiveTransform.m22 = 0.6;
        insideRotationAndPerspectiveTransform = CATransform3DRotate(insideRotationAndPerspectiveTransform, -M_PI / 3, 0.0f, -1.0f, 0.0f);
        insideLayer.transform = insideRotationAndPerspectiveTransform;
        
    } completion:^(BOOL finished) {
        if (finished) {
            /* 收缩动画 */
            [UIView animateWithDuration:DURATION animations:^{
                
                if (0 == positionOfOutsideView) { /* 主页在后 */
                    insideLayer.transform = changeInsideRotationTransform;
                    outsideLayer.transform = outsideOriginTransform;
                }else{ /* 主页在前 */
                    insideLayer.transform = insideOriginTransform;
                    outsideLayer.transform = changedOutsideRotationTransform;
                }

            } completion:^(BOOL finished) {
                /* 回复原始状态 */
                insideLayer.transform = insideOriginTransform;
                outsideLayer.transform = outsideOriginTransform;
                
                /* 交换view的前后位置 */
                if (0 == positionOfOutsideView) { /* 主页在后 */
                    [self.view sendSubviewToBack:self.insideView];
                }else{ /* 主页在前 */
                    [self.view sendSubviewToBack:self.outsideView];
                }
            }];
        }
    }];
}

@end
