//
//  KGQuareHorizontalCell.h
//  文艺星球
//
//  Created by 文艺星球 on 2018/11/2.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGQuareHorizontalCell : UITableViewCell
/** 根据数据计算cell高度 */
- (CGFloat)rowHeightWithDictionary:(NSDictionary *)dic;
/** 根据数据填充cell */
- (void)cellDataWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
