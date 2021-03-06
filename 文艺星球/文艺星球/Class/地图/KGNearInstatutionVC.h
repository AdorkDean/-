//
//  KGNearInstatutionVC.h
//  文艺星球
//
//  Created by 文艺星球 on 2018/12/11.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import "KGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGNearInstatutionVC : KGBaseViewController
/** 添加到主窗体上 */
- (void)addScreenViewToSupView:(UIView *)fatherView topViewHeight:(CGFloat)topHeight;
- (void)requestCityDataWithCityType:(NSString *)city;

@end

NS_ASSUME_NONNULL_END
