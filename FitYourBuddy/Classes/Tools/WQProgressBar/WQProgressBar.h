//
//  WQProgressBar.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

extern CGFloat const LevelIconWidth, LevelViewHeight;
@interface WQProgressBar : UIView
/** 更新等级和经验 */
- (void)loadLevelAndExp;
/** 朴素版本 */
- (void)simpleVersion;

@end
