//
//  MSPopMenuView.m
//  TipsView
//
//  Created by ypl on 2018/10/30.
//  Copyright © 2018年 ypl. All rights reserved.
//

#import "MSPopMenuView.h"
#import "MSPopMenuItem.h"
#import "MSMenuConstant.h"

@interface MSPopMenuView()
@property (nonatomic, assign, readonly) CGFloat maxTopViewY;//距顶部距离
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, strong) UIWindow * window;
@property (nonatomic, strong) UIImage * bulrImage;
@property (nonatomic, strong) UIView * blurView;//模糊背景
@property (nonatomic, strong) UIImageView * closeImageView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) NSArray * items;//初始化popMenuItem
@property (nonatomic, strong) selectCompletionBlock block;

@end

@implementation MSPopMenuView

+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
                   topView:(UIView *)topView
           completionBlock:(selectCompletionBlock)block {
    
    MSPopMenuView *menu = [[MSPopMenuView alloc]initWithItems:items];
    [menu setTopView:topView];
    [menu setSelectCompletionBlock:block];
    [menu setCloseImage:closeImageName];
}

+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
           completionBlock:(selectCompletionBlock)block {
    
    MSPopMenuView *menu = [[MSPopMenuView alloc]initWithItems:items];
    [menu setSelectCompletionBlock:block];
    [menu setCloseImage:closeImageName];
}

+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
        backgroundImageUrl:(NSString *)urlStr
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block {
    
    MSPopMenuView *menu = [[MSPopMenuView alloc]initWithItems:items];
    [menu setSelectCompletionBlock:block];
    [menu setCloseImage:closeImageName];
}

+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
       backgroundImageName:(NSString *)bgImageName
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block {
    
    MSPopMenuView *menu = [[MSPopMenuView alloc]initWithItems:items];
    [menu setSelectCompletionBlock:block];
    [menu setCloseImage:closeImageName];
}

- (instancetype)initWithItems:(NSArray *)items {
    if (self==[super init]) {
        _items = items;
        [self setFrame:CGRectMake(0, 0, Width, Height)];
        [self initUI];
        [self show];
        [self addSubview:self.closeImageView];
        //关闭按钮旋转--> 'X'
        typeof(self) weakSelf = self;
        [UIView animateWithDuration:kDuration animations:^{
            weakSelf.closeImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
    return self;
}

#pragma mark - private

- (void)initUI {
    self.alpha = 0.0;
    //添加模糊背景
    [self addSubview:self.blurView];
    //下边的按钮背景
    [self addSubview:self.bottomView];
    //添加所有的按钮
    [self calculatingItems];
}

/**
 *  计算按钮的位置
 */
- (void)calculatingItems {
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDuration animations:^{
        [weakSelf setAlpha:1];
    }];
    NSInteger index = 0;
    NSInteger count = _items.count;
    for (NSMutableDictionary *dict in _items) {
        CGFloat buttonX,buttonY;
        
        buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth;
        buttonY = ((index / kMaxPopMenuItemColumn) * (kPopMenuItemHeight + 10)) + (Height/2.85);
        NSLog(@"x:%.2f  y:%.2f",buttonX,buttonY);
        if (count == 2) {
            buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth + (kPopMenuItemWidth / 3) * (index + 1);
            buttonY = CGRectGetMinY(_bottomView.frame) - (kPopMenuItemHeight + 10) * 2;
        }
        CGRect fromValue = CGRectMake(buttonX, CGRectGetMinY(_bottomView.frame), kPopMenuItemWidth, kPopMenuItemHeight);
        CGRect toValue = CGRectMake(buttonX, buttonY, kPopMenuItemWidth, kPopMenuItemHeight);
        if (index == 0) {
            _maxTopViewY = CGRectGetMinY(toValue);
        }
        MSPopMenuItem *button = [self createButtonIndex:index frame:fromValue];
        button.attrDic = dict;
        double delayInSeconds = index * kInterval;
        [self startAnimationFromValue:fromValue toValue:toValue delay:delayInSeconds object:button alpha:1 completionBlock:^(BOOL complete) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self     action:@selector(dismiss)];
            [weakSelf.blurView addGestureRecognizer:tap];
        } hideDisplay:false];
        index ++;
    }
}

-(void)dismiss {
    [_bottomView setUserInteractionEnabled:false];
    [self setUserInteractionEnabled:false];
    __weak __typeof(self)weakSelf = self;
    [self dismissCompletionBlock:^(BOOL complete) {
        [weakSelf removeFromSuperview];
    }];
}

-(void)dismissCompletionBlock:(void(^) (BOOL complete)) completionBlock{
    //动画旋转
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.38 animations:^{
        weakSelf.closeImageView.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    }];
    
    NSInteger index = 0;
    
    NSInteger count = _items.count;
    
    for (NSMutableDictionary *dic in _items) {
        MSPopMenuItem *button = (MSPopMenuItem *)[self viewWithTag:(index + 1) + kBasePopMenuTag];
        button.attrDic = dic;
        
        CGFloat buttonX,buttonY;
        buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth;
        buttonY = ((index / kMaxPopMenuItemColumn) * (kPopMenuItemHeight +10)) + (Height/2.9);
        
        if (count == 2) {
            buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth + (kPopMenuItemWidth / 3) * (index + 1);
            buttonY = CGRectGetMinY(_bottomView.frame) - (kPopMenuItemHeight + 10) * 2;
        }
        
        CGRect toValue = CGRectMake(buttonX, Height, kPopMenuItemWidth, kPopMenuItemHeight);
        CGRect fromValue = CGRectMake(buttonX, buttonY, kPopMenuItemWidth, kPopMenuItemHeight);
        double delayInSeconds = (_items.count - index) * kInterval;
        
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.bottomView setBackgroundColor:[UIColor clearColor]];
        }];
        [self startAnimationFromValue:fromValue toValue:toValue delay:delayInSeconds object:button alpha:0 completionBlock:^(BOOL complete) {
        } hideDisplay:true];
        index ++;
    }
    [self hideDelay:0.38f completionBlock:^(BOOL completion) {
    }];
}

-(void)startAnimationFromValue:(CGRect)fromValue
                          toValue:(CGRect)toValue
                            delay:(float)delay
                           object:(MSPopMenuItem *)btn
                            alpha:(float)alpha
                  completionBlock:(void(^) (BOOL complete))completionBlock
                      hideDisplay:(BOOL)hideDisplay{
    
    //设置初始位置
    [UIView animateWithDuration:.16 delay:delay options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        btn.frame = CGRectMake(toValue.origin.x, toValue.origin.y - 8, toValue.size.width, toValue.size.height);
        btn.alpha = alpha;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            btn.frame = CGRectMake(toValue.origin.x, toValue.origin.y + 4, toValue.size.width, toValue.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                btn.frame = CGRectMake(toValue.origin.x, toValue.origin.y, toValue.size.width, toValue.size.height);
                completionBlock(YES);
            }];
        }];
    }];
}

-(MSPopMenuItem *)createButtonIndex:(NSInteger)index frame:(CGRect)frame {
    MSPopMenuItem *button = [[MSPopMenuItem alloc] initWithFrame:frame];
    [button setTag:(index + 1) + kBasePopMenuTag];
    [button setAlpha:0.0f];
    [button setTitleColor:[UIColor colorWithWhite:0.38 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menuItemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return button;
}

/**
 *  选中了MenuItem后的响应事件
 */
-(void)menuItemSelected:(MSPopMenuItem *)menuItem {
    NSInteger tag = menuItem.tag - (kBasePopMenuTag + 1);
    __block MSPopMenuView *popMenu = self;
    for (NSMutableDictionary *dict in _items) {
        NSInteger index = [_items indexOfObject:dict];
        MSPopMenuItem *buttons = (MSPopMenuItem *)[self viewWithTag:(index + 1) + kBasePopMenuTag];
        if (index == tag) {
            [menuItem playSelectAnimation];
        }else{
            [buttons playCancelAnimation];
        }
    }
    [self hideDelay:0.3f completionBlock:^(BOOL completion) {
        if (!popMenu.block) {
            return ;
        }
        popMenu.block(tag);
    }];
}

/**
 *  隐藏
 */
-(void)hideDelay:(NSTimeInterval)delay completionBlock:(void(^)(BOOL completion))blcok {
    [self setUserInteractionEnabled:false];
    typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [weakSelf.bottomView setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateKeyframesWithDuration:kDuration delay:delay options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [weakSelf setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (!blcok) {
            return ;
        }
        blcok(finished);
    }];
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
}

-(void)show{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelNormal;
        _window.backgroundColor = [UIColor clearColor];
        _window.alpha = 1;
        _window.hidden = false;
        [_window addSubview:self];
    }
}

#pragma mark - Setter

-(UIView *)blurView {
    if (!_blurView) {
    //8.0以上，现应用支持9.0以上，故不需要做处理
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
    ((UIVisualEffectView *)_blurView).frame = self.bounds;
    _blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    }
    return _blurView;
}

-(UIView *)bottomView {
    if (!_bottomView){
        _bottomView = [[UIView alloc]init];
        CGFloat bottomY = Height - kBottomViewHeight;
        _bottomView.userInteractionEnabled = NO;
        [_bottomView setFrame:CGRectMake(0, bottomY, Width, 0)];
        [_bottomView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.90f]];
    }
    return _bottomView;
}

- (UIImageView *)closeImageView {
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        CGPoint center = CGPointMake(Width/2, Height - kBottomViewHeight / 2 -70);
        _closeImageView.center = center;
        _closeImageView.userInteractionEnabled = NO;
        _closeImageView.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    }
    return _closeImageView;
}

-(void)setTopView:(UIView *)topView {
    if (![topView isKindOfClass:[NSNull class]] &&
        [topView isKindOfClass:[UIView class]]) {
        _topView = topView;
        [_blurView addSubview:topView];
    }
}

- (void)setCloseImage:(NSString *)imageName {
    if (_closeImageView) {
        _closeImageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setSelectCompletionBlock:(selectCompletionBlock)block {
    if (_block!=block) {
        _block = block;
    }
}

-(void)dealloc {
    NSArray *subViews = [_window subviews];
    for (id obj in subViews) {
        [obj removeFromSuperview];
    }
    [_window resignKeyWindow];
    [_window removeFromSuperview];
    _window = nil;
}

@end
