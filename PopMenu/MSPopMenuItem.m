//
//  MSPopMenuItem.m
//  TipsView
//
//  Created by ypl on 2018/10/30.
//  Copyright © 2018年 ypl. All rights reserved.
//

#import "MSPopMenuItem.h"
#import "MSMenuConstant.h"

NSString *const kPopMenuItemAttributeTitle2    = @"PopMenuItemAttributeTitle";
NSString *const kPopMenuItemAttributeIconImageName2    = @"PopMenuItemAttributeIconImageName";
@interface MSPopMenuItem ()<CAAnimationDelegate>
@end

@implementation MSPopMenuItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addTarget:self action:@selector(scaleAnimation)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)scaleAnimation {
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)playSelectAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @1.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

- (void)playCancelAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageWidth = contentRect.size.width/1.7;
    CGFloat imageX = CGRectGetWidth(contentRect)/2 - imageWidth/2;
    CGFloat imageHeight = imageWidth;
    CGFloat imageY = CGRectGetHeight(self.bounds) - (imageHeight + 30);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleHeight = 20;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX,titleY, titleWidth, titleHeight);
}

- (void)setAttrDic:(NSMutableDictionary *)attrDic {
    _attrDic = [attrDic copy];
    
    NSString *imageName = [attrDic objectForKey:kPopMenuItemAttributeIconImageName2];
    UIImage *image = [UIImage imageNamed:imageName];
    [self setImage:image forState:UIControlStateNormal];
    
    NSString *title = [attrDic objectForKey:kPopMenuItemAttributeTitle2];
    [self setTitle:title forState:UIControlStateNormal];
}

@end
