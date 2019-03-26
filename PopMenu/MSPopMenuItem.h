//
//  MSPopMenuItem.h
//  TipsView
//
//  Created by ypl on 2018/10/30.
//  Copyright © 2018年 ypl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSPopMenuItem : UIButton

@property (nonatomic, copy) NSMutableDictionary *attrDic;

/**
 *  播放选择动画
 */
- (void)playSelectAnimation;

/**
 *  播放取消选择动画
 */
- (void)playCancelAnimation;
@end
