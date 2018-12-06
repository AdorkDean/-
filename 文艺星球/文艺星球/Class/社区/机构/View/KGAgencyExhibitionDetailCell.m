//
//  KGAgencyExhibitionDetailCell.m
//  文艺星球
//
//  Created by 文艺星球 on 2018/11/12.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import "KGAgencyExhibitionDetailCell.h"

@implementation KGAgencyExhibitionDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)cellDetailWithDictionary:(NSDictionary *)dic{
    [self.customImage sd_setImageWithURL:[NSURL URLWithString:[[dic[@"worksPhoto"] componentsSeparatedByString:@"#"] firstObject]]];
    self.customImage.contentMode = UIViewContentModeScaleAspectFill;
    self.customImage.layer.masksToBounds = YES;
    self.titleLab.text = [NSString stringWithFormat:@"作者：%@",dic[@"worksAuthor"]];
}

@end
