//
//  KGPreviewHorizontalTextView.m
//  文艺星球
//
//  Created by 文艺星球 on 2018/11/2.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import "KGPreviewHorizontalTextView.h"

@interface KGPreviewHorizontalTextView ()
/** 保存切割字符串 */
@property (nonatomic,strong) NSMutableArray *titleArr;
/** 显示文本 */
@property (nonatomic,strong) UIView *labView;
/** 加载图片 */
@property (nonatomic,strong) UIScrollView *scrollImage;

@end

@implementation KGPreviewHorizontalTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleArr = [NSMutableArray array];
        [self setLab];
    }
    return self;
}
/** 创建文本显示 */
- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    if ([contentStr rangeOfString:@"。"].location != NSNotFound) {
        NSArray *endArr = [contentStr componentsSeparatedByString:@"。"];
        __block NSMutableArray *markArr = [NSMutableArray array];
        [endArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj rangeOfString:@"！"].location != NSNotFound) {
                NSArray *tmp = [obj componentsSeparatedByString:@"！"];
                [markArr addObjectsFromArray:tmp];
            }else{
                [markArr addObject:obj];
            }
        }];
        [self setLabelWithArr:markArr];
    }else if ([contentStr rangeOfString:@"！"].location != NSNotFound) {
        NSArray *endArr = [contentStr componentsSeparatedByString:@"！"];
        __block NSMutableArray *markArr = [NSMutableArray array];
        [endArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj rangeOfString:@"。"].location != NSNotFound) {
                NSArray *tmp = [obj componentsSeparatedByString:@"。"];
                [markArr addObjectsFromArray:tmp];
            }else{
                [markArr addObject:obj];
            }
        }];
        [self setLabelWithArr:markArr];
    }else{
        if (contentStr.length > 20) {
            NSString *one = [contentStr substringToIndex:20];
            NSString *oneEnd = [[contentStr componentsSeparatedByString:one] lastObject];
            if (oneEnd.length > 20) {
                NSString *two = [oneEnd substringToIndex:20];
                NSString *twoEnd = [[oneEnd componentsSeparatedByString:two] lastObject];
                if (twoEnd.length > 20) {
                    NSString *three = [twoEnd substringToIndex:20];
                    NSString *threeEnd = [[twoEnd componentsSeparatedByString:three] lastObject];
                    if (threeEnd.length > 20) {
                        NSString *four = [threeEnd substringToIndex:20];
                        NSString *fourEnd = [[threeEnd componentsSeparatedByString:four] lastObject];
                        if (fourEnd.length > 20) {
                            NSString *five = [fourEnd substringToIndex:20];
                            [self setLabelWithArr:@[one,two,three,four,five]];
                        }else{
                            [self setLabelWithArr:@[one,two,three,four,fourEnd]];
                        }
                    }else{
                        [self setLabelWithArr:@[one,two,three,threeEnd]];
                    }
                }else{
                    [self setLabelWithArr:@[one,two,twoEnd]];
                }
            }else{
                [self setLabelWithArr:@[one,oneEnd]];
            }
        }else{
            [self setLabelWithArr:@[contentStr]];
        }
    }
}
/** 创建View */
- (void)setLab{
    self.labView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth, 105)];
    [self addSubview:self.labView];
    
    self.scrollImage = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 130, KGScreenWidth - 30, (KGScreenWidth - 30)/69*46)];
    self.scrollImage.pagingEnabled = YES;
    self.scrollImage.showsVerticalScrollIndicator = NO;
    self.scrollImage.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollImage];
}
/** 创建label */
- (void)setLabelWithArr:(NSArray *)arr{
    if (arr.count > 0) {
        for (int i = 0; i < arr.count; i++) {
            UILabel *tmp = [[UILabel alloc]initWithFrame:CGRectMake(15,23*i, KGScreenWidth - 30, 13)];
            tmp.text = arr[i];
            tmp.textColor = KGBlackColor;
            tmp.font = KGFontFZ(13);
            [self.labView addSubview:tmp];
        }
        self.labView.frame = CGRectMake(0, 0, KGScreenWidth, 23*arr.count);
    }
}
/** 创建Imageview */
- (void)setPhotosArr:(NSArray *)photosArr{
    _photosArr = photosArr;
    if (photosArr.count > 0) {
        self.scrollImage.frame = CGRectMake(15, self.labView.frame.origin.y + self.labView.frame.size.height + 25, KGScreenWidth - 30, (KGScreenWidth - 30)/69*46);
        self.scrollImage.contentSize = CGSizeMake((KGScreenWidth - 30)*photosArr.count, (KGScreenWidth - 30)/69*46);
        for (int i = 0; i < photosArr.count; i++) {
            KGImageView *image = [[KGImageView alloc]initWithFrame:CGRectMake((KGScreenWidth - 30)*i, 0, KGScreenWidth - 30, (KGScreenWidth - 30)/69*46)];
            image.image = photosArr[i];
            image.deleteBtu.hidden = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.layer.cornerRadius = 5;
            image.layer.masksToBounds = YES;
            [self.scrollImage addSubview:image];
        }
    }
}
/** 文本对其 */
- (void)setLabAligment:(NSTextAlignment)labAligment{
    _labAligment = labAligment;
    for (id obj in self.labView.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *tmp = obj;
            tmp.textAlignment = labAligment;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
