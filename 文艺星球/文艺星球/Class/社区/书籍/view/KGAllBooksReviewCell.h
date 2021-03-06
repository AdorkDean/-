//
//  KGAllBooksReviewCell.h
//  文艺星球
//
//  Created by 文艺星球 on 2018/11/14.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGAllBooksReviewCell : UITableViewCell

- (CGFloat)cellHeightWithDictionary:(NSDictionary *)dic;
- (void)cellDetailWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
