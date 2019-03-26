//
//  MSPopMenuView.h
//  TipsView
//
//  Created by ypl on 2018/10/30.
//  Copyright © 2018年 ypl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectCompletionBlock)(NSInteger index);
@interface MSPopMenuView : UIView
/**
 *  根据items创建PopMenu
 *  @param items items
 *  @return PopMenu的对象
 */
- (instancetype)initWithItems:(NSArray *)items;

/**
 *  设置选择了某个items的回调block
 *  @param block block
 */
- (void)setSelectCompletionBlock:(selectCompletionBlock)block;

/**
 *  设置退出图片资源文件名称
 *
 *  @param imageName 图片资源文件名称
 */
- (void)setCloseImage:(NSString *)imageName;

/**
 *  创建PopMenu
 *
 *  @param items          items参数
 *  @param closeImageName 关闭按钮图片名称
 *  @param topView        顶部View
 *  @param block          完成回调
 */
+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
                   topView:(UIView *)topView
           completionBlock:(selectCompletionBlock)block;

/**
 *  创建PopMenu
 *
 *  @param items          items参数
 *  @param closeImageName 关闭按钮图片名称
 *  @param block          完成回调
 */
+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
           completionBlock:(selectCompletionBlock)block;

/**
 *  创建PopMenu，特殊的PopMenu,只传入两个items参数
 *
 *  @param items          items参数
 *  @param closeImageName 关闭按钮图片名称
 *  @param urlStr         背景图片的Url
 *  @param tipStr         提示文字
 *  @param block          完成后的回调
 */
+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
        backgroundImageUrl:(NSString *)urlStr
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block;

/**
 创建PopMenu，特殊的PopMenu,只传入两个items参数
 
 @param items          items参数
 @param closeImageName 关闭按钮图片名称
 @param bgImageName    背景图片名称
 @param tipStr         提示文字
 @param block          完成后的回调
 */
+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
       backgroundImageName:(NSString *)bgImageName
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block;

/**
 Menu消失
 */
-(void)dismiss;
@end
