//
//  KGSquareVC.m
//  文艺星球
//
//  Created by 文艺星球 on 2018/10/24.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import "KGSquareVC.h"
#import "KGReleaseVC.h"
#import "KGSquareRoundCell.h"
#import "KGSquareVerticalCell.h"
#import "KGQuareHorizontalCell.h"
#import "KGSquareMessageVC.h"
#import "KGFoundInterestAreaVC.h"
#import "KGSquareDetailVC.h"

@interface KGSquareVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/** 消息 */
@property (nonatomic,strong) UITableView *listView;
/** 用户消息 */
@property (nonatomic,strong) UIView *headerView;
/** 点击消息 */
@property (nonatomic,strong) UIButton *contextBtu;
/** 发现好去处 */
@property (nonatomic,strong) KGFoundInterestAreaVC *foundVC;
/** 导航左侧 */
@property (nonatomic,strong) UIButton *leftBtu;
/** 导航右侧 */
@property (nonatomic,strong) UIButton *rightBtu;

@end

@implementation KGSquareVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /** 导航栏标题颜色 */
    [self changeNavTitleColor:KGBlackColor font:KGFontSHBold(15) controller:self];
    [self changeNavBackColor:KGWhiteColor controller:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 导航栏标题 */
    self.title = @"广场";
    self.view.backgroundColor = KGAreaGrayColor;
    
    [self setNavCenterView];
    [self setUpListView];
    [self releaseBtu];
}
/** 导航栏设置 */
- (void)setNavCenterView{
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.navigationItem.titleView = centerView;
    
    self.leftBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtu.frame = CGRectMake(0, 0, 100, 30);
    [self.leftBtu setTitle:@"广场" forState:UIControlStateNormal];
    [self.leftBtu setTitleColor:KGBlueColor forState:UIControlStateNormal];
    self.leftBtu.titleLabel.font = KGFontSHBold(15);
    [self.leftBtu addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:self.leftBtu];
    
    self.rightBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtu.frame = CGRectMake(100, 0, 100, 30);
    [self.rightBtu setTitle:@"发现好去处" forState:UIControlStateNormal];
    [self.rightBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
    self.rightBtu.titleLabel.font = KGFontSHBold(15);
    [self.rightBtu addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:self.rightBtu];
    
}
/** 左侧按钮 */
- (void)leftAction:(UIButton *)leftBtu{
    [self.leftBtu setTitleColor:KGBlueColor forState:UIControlStateNormal];
    [self.rightBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
    [self.foundVC.view removeFromSuperview];
}
/** 右侧按钮 */
- (void)rightAction:(UIButton *)leftBtu{
    [self.leftBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
    [self.rightBtu setTitleColor:KGBlueColor forState:UIControlStateNormal];
    [self.view addSubview:self.foundVC.view];
}
/** 发现好去处 */
- (KGFoundInterestAreaVC *)foundVC{
    if (!_foundVC) {
        _foundVC = [[KGFoundInterestAreaVC alloc]init];
        [self.view addSubview:_foundVC.view];
    }
    return _foundVC;
}
/** 发布按钮 */
- (void)releaseBtu{
    UIButton *releaseBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseBtu.frame = CGRectMake(KGScreenWidth - 55, KGScreenHeight - KGRectTabbarHeight - 100, 40, 40);
    [releaseBtu setImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [releaseBtu addTarget:self action:@selector(releaseAction:) forControlEvents:UIControlEventTouchUpInside];
    releaseBtu.layer.cornerRadius = 20;
    releaseBtu.layer.masksToBounds = YES;
    [self.view insertSubview:releaseBtu atIndex:99];
}
/** 发布按钮点击事件 */
- (void)releaseAction:(UIButton *)sender{
    [self pushHideenTabbarViewController:[[KGReleaseVC alloc]init] animted:YES];
}
/** 创建消息列表 */
- (void)setUpListView{
    self.listView = [[UITableView alloc]initWithFrame:CGRectMake(0, KGRectNavAndStatusHight, KGScreenWidth, KGScreenHeight - KGRectNavAndStatusHight)];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.emptyDataSetSource = self;
    self.listView.emptyDataSetDelegate = self;
    self.listView.tableFooterView = [UIView new];
    self.listView.tableHeaderView = [self setUpHeaderView];
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listView];
    
    [self.listView registerClass:[KGSquareRoundCell class] forCellReuseIdentifier:@"KGSquareRoundCell"];
    [self.listView registerClass:[KGQuareHorizontalCell class] forCellReuseIdentifier:@"KGQuareHorizontalCell"];
    [self.listView registerClass:[KGSquareVerticalCell class] forCellReuseIdentifier:@"KGSquareVerticalCell"];
}
/** 用户消息 */
- (UIView *)setUpHeaderView{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth, 60)];
    self.headerView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    /** 消息条数 */
    self.contextBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.contextBtu.frame = CGRectMake(0, 0, 140, 40);
    self.contextBtu.center = self.headerView.center;
    [self.contextBtu setTitle:@"20条新消息" forState:UIControlStateNormal];
    [self.contextBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
    self.contextBtu.titleLabel.font = KGFontSHRegular(13);
    [self.contextBtu setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
    self.contextBtu.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.contextBtu.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    self.contextBtu.layer.cornerRadius = 5;
    self.contextBtu.layer.masksToBounds = YES;
    [self.contextBtu addTarget:self action:@selector(lockMeeagesAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.contextBtu];
    return self.headerView;
}
/** 点击查看消息 */
- (void)lockMeeagesAction:(UIButton *)sender{
    [self pushHideenTabbarViewController:[[KGSquareMessageVC alloc]init] animted:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        KGSquareRoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGSquareRoundCell"];
        return cell;
    }else if (indexPath.row == 1){
        KGQuareHorizontalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGQuareHorizontalCell"];
        return cell;
    }else{
        KGSquareVerticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGSquareVerticalCell"];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushHideenTabbarViewController:[[KGSquareDetailVC alloc]init] animted:YES];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"kongyemian"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
