//
//  KGAgencyHomePageVC.m
//  文艺星球
//
//  Created by 文艺星球 on 2018/11/9.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import "KGAgencyHomePageVC.h"
#import "KGAgencyHomePageCell.h"
#import "KGAgencyHomePageScreeningCell.h"
#import "KGAgencyDetailVC.h"

@interface KGAgencyHomePageVC ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
/** 顶部滚动页 */
@property (nonatomic,strong) UIScrollView *topScrollView;
/** 页码 */
@property (nonatomic,strong) UIPageControl *pageControl;
/** 左侧区域筛选 */
@property (nonatomic,strong) UIButton *areaBtu;
/** 右侧排序筛选 */
@property (nonatomic,strong) UIButton *sortBtu;
/** 机构列表 */
@property (nonatomic,strong) UITableView *listView;
/** 左侧列表 */
@property (nonatomic,strong) UITableView *leftListView;
/** 右侧列表 */
@property (nonatomic,strong) UITableView *rightListView;
/** 单列列表 */
@property (nonatomic,strong) UITableView *onlyListView;
/** 筛选页面 */
@property (nonatomic,strong) UIView *screenView;
/** 第一个列表选中 */
@property (nonatomic,assign) NSInteger oneListCellRow;
/** 第二个列表选中 */
@property (nonatomic,assign) NSInteger twoListCellRow;
/** 第三个列表选中 */
@property (nonatomic,assign) NSInteger threeListCellRow;
/** 左侧列表标题 */
@property (nonatomic,copy) NSArray *oneArr;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger page;

@end

@implementation KGAgencyHomePageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /** 导航栏标题颜色 */
    [self changeNavBackColor:KGWhiteColor controller:self];
    [self changeNavTitleColor:KGWhiteColor font:KGFontSHBold(15) controller:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /** 定制左侧返回按钮 */
    [self setLeftNavItemWithFrame:CGRectMake(15, 0, 50, 30) title:nil image:[UIImage imageNamed:@"fanhui"] font:nil color:nil select:@selector(leftNavAction)];
    self.view.backgroundColor = KGWhiteColor;
    
    /** 初始赋值 */
    self.oneListCellRow = 0;
    self.twoListCellRow = 0;
    self.threeListCellRow = 0;
    self.oneArr = @[@"全部",@"北京",@"上海",@"广州",@"深圳",@"天津",@"成都",@"西安"];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self requestData];
    [self setNavCenterView];
    [self setUpListView];
    [self setUpScreeningView];
}
/** 请求数据 */
- (void)requestData{
    NSString *cityId = nil;
    if ([[KGRequest shareInstance].userLocationCity isEqualToString:@"北京市"]) {
        cityId = @"1";
    }else if ([[KGRequest shareInstance].userLocationCity isEqualToString:@"天津市"]){
        cityId = @"43";
    }else if ([[KGRequest shareInstance].userLocationCity isEqualToString:@"西安市"]){
        cityId = @"54";
    }else if ([[KGRequest shareInstance].userLocationCity isEqualToString:@"广州市"]){
        cityId = @"28";
    }else if ([[KGRequest shareInstance].userLocationCity isEqualToString:@"成都市"]){
        cityId = @"65";
    }else if ([[KGRequest shareInstance].userLocationCity isEqualToString:@"上海市"]){
        cityId = @"13";
    }else if ([[KGRequest shareInstance].userLocationCity isEqualToString:@"深圳市"]){
        cityId = @"36";
    }else{
        cityId = @"1";
    }
    NSString *typeID = nil;
    if (self.scenarioStyle == KGScenarioStyleArts) {
        typeID = @"1";
    }else if (self.scenarioStyle == KGScenarioStyleDesign){
        typeID = @"4";
    }else if (self.scenarioStyle == KGScenarioStylePhotography){
        typeID = @"6";
    }else if (self.scenarioStyle == KGScenarioStyleTheatre){
        typeID = @"13";
    }
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [KGRequest postWithUrl:SelectCommunityPlaceList parameters:@{@"pageIndex":@(self.page),@"pageSize":@"20",@"userLongitude":@([[KGRequest shareInstance] requestYourLocation].longitude),@"userLatitude":@([KGRequest shareInstance].requestYourLocation.latitude),@"typeID":typeID,@"cityID":cityId,@"cityproperid":@"",@"mohu":@"",@"navigation":@""} succ:^(id  _Nonnull result) {
        [hud hideAnimated:YES];
        if ([result[@"status"] integerValue] == 200) {
            NSDictionary *dic = result[@"data"];
            NSArray *tmp = dic[@"list"];
            if (tmp.count > 0) {
                [weakSelf.dataArr addObjectsFromArray:tmp];
            }
        }
        [weakSelf.listView reloadData];
        [weakSelf.listView.mj_footer endRefreshing];
        [weakSelf.listView.mj_header endRefreshing];
    } fail:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [weakSelf.listView reloadData];
        [weakSelf.listView.mj_footer endRefreshing];
        [weakSelf.listView.mj_header endRefreshing];
    }];
}
/** 导航栏左侧点击事件 */
- (void)leftNavAction{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 导航栏搜索 */
- (void)setNavCenterView{
    UIButton *searchBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtu.frame = CGRectMake(0, 0, KGScreenWidth - 130, 30);
    [searchBtu setTitle:@"搜索..." forState:UIControlStateNormal];
    [searchBtu setImage:[UIImage imageNamed:@"sousuohuise"] forState:UIControlStateNormal];
    [searchBtu setTitleColor:KGGrayColor forState:UIControlStateNormal];
    searchBtu.titleLabel.font = KGFontSHRegular(12);
    searchBtu.layer.cornerRadius = 15;
    searchBtu.layer.masksToBounds = YES;
    searchBtu.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [searchBtu addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchBtu;
}
/** 搜索框点击事件 */
- (void)searchAction{
    
}
/** 顶部滚动页 */
- (UIView *)setUpTopScrollView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth, (KGScreenWidth - 30)/69*16 + 70)];
    topView.backgroundColor = KGWhiteColor;
    /** 轮播图 */
    self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 0, KGScreenWidth - 30, (KGScreenWidth - 30)/69*16)];
    self.topScrollView.delegate = self;
    self.topScrollView.contentSize = CGSizeMake((KGScreenWidth - 30)*5, (KGScreenWidth - 30)/69*16);
    self.topScrollView.bounces = NO;
    self.topScrollView.pagingEnabled = YES;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [topView addSubview:self.topScrollView];
    /** 页码 */
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(15, (KGScreenWidth - 30)/69*16 - 17, KGScreenWidth, 7)];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = KGBlueColor;
    self.pageControl.pageIndicatorTintColor = KGWhiteColor;
    [topView addSubview:self.pageControl];
    /** 底线 */
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (KGScreenWidth - 30)/69*16 + 20, KGScreenWidth, 10)];
    line.backgroundColor = KGLineColor;
    [topView addSubview:line];
    /** 品类筛选 */
    self.areaBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.areaBtu.frame = CGRectMake(0, (KGScreenWidth - 30)/69*16 + 30, KGScreenWidth/2, 40);
    [self.areaBtu setTitle:@"全城" forState:UIControlStateNormal];
    [self.areaBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
    [self.areaBtu setImage:[UIImage imageNamed:@"liwozuijin"] forState:UIControlStateNormal];
    self.areaBtu.titleLabel.font = KGFontSHRegular(14);
    self.areaBtu.titleEdgeInsets = UIEdgeInsetsMake(0,-self.areaBtu.imageView.bounds.size.width, 0, 0);
    self.areaBtu.imageEdgeInsets = UIEdgeInsetsMake(0, self.areaBtu.titleLabel.bounds.size.width + 40, 0, 0);
    [self.areaBtu addTarget:self action:@selector(areaAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.areaBtu];
    /** 排序筛选 */
    self.sortBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sortBtu.frame = CGRectMake(KGScreenWidth/2, (KGScreenWidth - 30)/69*16 + 30, KGScreenWidth/2, 40);
    [self.sortBtu setTitle:@"离我最近" forState:UIControlStateNormal];
    [self.sortBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
    [self.sortBtu setImage:[UIImage imageNamed:@"liwozuijin"] forState:UIControlStateNormal];
    self.sortBtu.titleLabel.font = KGFontSHRegular(14);
    self.sortBtu.titleEdgeInsets = UIEdgeInsetsMake(0,-self.sortBtu.imageView.bounds.size.width, 0, 0);
    self.sortBtu.imageEdgeInsets = UIEdgeInsetsMake(0, self.sortBtu.titleLabel.bounds.size.width + 65, 0, 0);
    [self.sortBtu addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.sortBtu];
    /** 低部线 */
    UIView *lowLine = [[UIView alloc]initWithFrame:CGRectMake(0, (KGScreenWidth - 30)/69*16 + 69, KGScreenWidth, 1)];
    lowLine.backgroundColor = KGLineColor;
    [topView addSubview:lowLine];
    
    [self setScrollViewImage];
    
    return topView;
}
/** 添加图片 */
- (void)setScrollViewImage{
    for (int i = 0; i < 5; i++) {
        UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
        tmp.frame = CGRectMake((KGScreenWidth - 30)*i, 0, KGScreenWidth - 30, (KGScreenWidth - 30)/69*16);
        tmp.imageView.contentMode = UIViewContentModeScaleAspectFill;
        tmp.backgroundColor = KGLineColor;
        [tmp addTarget:self action:@selector(advertisingAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:tmp];
    }
}
/** 点击事件 */
- (void)advertisingAction:(UIButton *)sender{
    // MARK: --在这里要写广告的点击事件--
    // !!!: --在这里要写广告的点击事件--
    // ???: --在这里要写广告的点击事件--
}
/** 控制页码 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = self.topScrollView.contentOffset.x/(KGScreenWidth - 30);
}
/** 品类筛选点击事件 */
- (void)areaAction:(UIButton *)sender{
    if ([sender.currentTitleColor isEqual:KGBlueColor]) {
        [sender setTitleColor:KGBlackColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"liwozuijin"] forState:UIControlStateNormal];
        self.screenView.hidden = YES;
    }else{
        [sender setTitleColor:KGBlueColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"quancheng"] forState:UIControlStateNormal];
        [self.sortBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
        [self.sortBtu setImage:[UIImage imageNamed:@"liwozuijin"] forState:UIControlStateNormal];
        self.screenView.hidden = NO;
        /** 先获取到点击按钮在controllerview中的坐标位置，然后加上导航栏高度，然后减去列表视图滚动的距离，得到筛选页面的起始点坐标，同理得到筛选view的高度 */
        CGPoint point = [self.view convertPoint:CGPointMake(sender.frame.origin.x, sender.frame.origin.y+sender.frame.size.height) toView:self.view];
        self.screenView.frame = CGRectMake(0,KGRectNavAndStatusHight + point.y - self.listView.contentOffset.y, KGScreenWidth, KGScreenHeight - point.y - KGRectNavAndStatusHight + self.listView.contentOffset.y);
        self.leftListView.hidden = NO;
        self.rightListView.hidden = NO;
        self.onlyListView.hidden = YES;
    }
}
/** 排序筛选点击事件 */
- (void)sortAction:(UIButton *)sender{
    if ([sender.currentTitleColor isEqual:KGBlueColor]) {
        [sender setTitleColor:KGBlackColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"liwozuijin"] forState:UIControlStateNormal];
        self.screenView.hidden = YES;
    }else{
        [sender setTitleColor:KGBlueColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"quancheng"] forState:UIControlStateNormal];
        [self.areaBtu setTitleColor:KGBlackColor forState:UIControlStateNormal];
        [self.areaBtu setImage:[UIImage imageNamed:@"liwozuijin"] forState:UIControlStateNormal];
        self.screenView.hidden = NO;
        /** 先获取到点击按钮在controllerview中的坐标位置，然后加上导航栏高度，然后减去列表视图滚动的距离，得到筛选页面的起始点坐标，同理得到筛选view的高度 */
        CGPoint point = [self.view convertPoint:CGPointMake(sender.frame.origin.x, sender.frame.origin.y+sender.frame.size.height) toView:self.view];
        self.screenView.frame = CGRectMake(0,KGRectNavAndStatusHight + point.y - self.listView.contentOffset.y, KGScreenWidth, KGScreenHeight - point.y - KGRectNavAndStatusHight + self.listView.contentOffset.y);
        self.leftListView.hidden = YES;
        self.rightListView.hidden = YES;
        self.onlyListView.hidden = NO;
    }
}
// MARK: --创建机构列表--
- (void)setUpListView{
    self.listView = [[UITableView alloc]initWithFrame:CGRectMake(0, KGRectNavAndStatusHight, KGScreenWidth, KGScreenHeight - KGRectNavAndStatusHight)];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.emptyDataSetSource = self;
    self.listView.emptyDataSetDelegate = self;
    self.listView.tableFooterView = [UIView new];
    self.listView.tableHeaderView = [self setUpTopScrollView];
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.showsHorizontalScrollIndicator = NO;
    __weak typeof(self) weakSelf = self;
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        weakSelf.dataArr = [NSMutableArray array];
        [weakSelf requestData];
        [weakSelf.listView.mj_header beginRefreshing];
    }];
    self.listView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf requestData];
        [weakSelf.listView.mj_footer beginRefreshing];
    }];
    [self.view addSubview:self.listView];
    
    [self.listView registerNib:[UINib nibWithNibName:@"KGAgencyHomePageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KGAgencyHomePageCell"];
}
// MARK: --UITableViewDelegate--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.listView) {
        return 137;
    }else{
        return 50;
    }
}
// MARK :--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.listView) {
        return self.dataArr.count;
    }else if (tableView == self.leftListView){
        return 8;
    }else if (tableView == self.onlyListView){
        return 2;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.listView) {
        KGAgencyHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGAgencyHomePageCell" forIndexPath:indexPath];
        if (self.dataArr.count > 0) {
            NSDictionary *dic = self.dataArr[indexPath.row];
            [cell cellDetailWithDictionary:dic];
        }
        return cell;
    }else if (tableView == self.leftListView){
        KGAgencyHomePageScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGAgencyHomePageScreeningCell"];
        if (indexPath.row == self.oneListCellRow) {
            cell.backgroundColor = KGWhiteColor;
            cell.titleLab.textColor = KGBlackColor;
        }else{
            cell.backgroundColor = KGLineColor;
            cell.titleLab.textColor = KGGrayColor;
        }
        cell.titleLab.text = self.oneArr[indexPath.row];
        return cell;
    }else if (tableView == self.onlyListView){
        KGAgencyHomePageScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGAgencyHomePageScreeningCell"];
        if (indexPath.row == 0) {
            cell.titleLab.text = @"离我最近";
        }else{
            cell.titleLab.text = @"好评优先";
        }
        if (indexPath.row == self.threeListCellRow) {
            cell.backgroundColor = KGWhiteColor;
            cell.titleLab.textColor = KGBlueColor;
        }else{
            cell.backgroundColor = KGWhiteColor;
            cell.titleLab.textColor = KGBlackColor;
        }
        return cell;
    }else{
        KGAgencyHomePageScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGAgencyHomePageScreeningCell"];
        if (indexPath.row == self.oneListCellRow) {
            cell.backgroundColor = KGWhiteColor;
            cell.titleLab.textColor = KGBlackColor;
        }else{
            cell.backgroundColor = KGWhiteColor;
            cell.titleLab.textColor = KGGrayColor;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.listView) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        KGAgencyDetailVC *vc = [[KGAgencyDetailVC alloc]init];
        vc.sendID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        [self pushHideenTabbarViewController:vc animted:YES];
    }else if (tableView == self.leftListView){
        self.oneListCellRow = indexPath.row;
        [self.leftListView reloadData];
    }else if (tableView == self.onlyListView){
        self.threeListCellRow = indexPath.row;
        [self.onlyListView reloadData];
    }else{
        self.twoListCellRow = indexPath.row;
        [self.rightListView reloadData];
    }
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (scrollView == self.listView) {
        return [UIImage imageNamed:@"kongyemian"];
    }
    return [UIImage new];
}
/** 创建刷选页面 */
- (void)setUpScreeningView{
    self.screenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth, KGScreenHeight)];
    self.screenView.backgroundColor = [KGBlackColor colorWithAlphaComponent:0.2];
    self.screenView.hidden = YES;
    [self.view insertSubview:self.screenView atIndex:99];
}
/** 左侧筛选左边栏 */
- (UITableView *)leftListView{
    if (!_leftListView) {
        _leftListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth/2+2, self.screenView.bounds.size.height)];
        _leftListView.delegate = self;
        _leftListView.dataSource = self;
        _leftListView.backgroundColor = [UIColor clearColor];
        _leftListView.emptyDataSetSource = self;
        _leftListView.emptyDataSetDelegate = self;
        _leftListView.showsVerticalScrollIndicator = NO;
        _leftListView.showsHorizontalScrollIndicator = NO;
        _leftListView.tableFooterView = [UIView new];
        _leftListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.screenView addSubview:_leftListView];
        [_leftListView registerNib:[UINib nibWithNibName:@"KGAgencyHomePageScreeningCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KGAgencyHomePageScreeningCell"];
    }
    return _leftListView;
}
/** 左侧筛选右边栏 */
- (UITableView *)rightListView{
    if (!_rightListView) {
        _rightListView = [[UITableView alloc]initWithFrame:CGRectMake(KGScreenWidth/2, 0, KGScreenWidth/2, self.screenView.bounds.size.height)];
        _rightListView.delegate = self;
        _rightListView.dataSource = self;
        _rightListView.backgroundColor = [UIColor clearColor];
        _rightListView.emptyDataSetSource = self;
        _rightListView.emptyDataSetDelegate = self;
        _rightListView.showsVerticalScrollIndicator = NO;
        _rightListView.showsHorizontalScrollIndicator = NO;
        _rightListView.tableFooterView = [UIView new];
        _rightListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.screenView addSubview:_rightListView];
        [_rightListView registerNib:[UINib nibWithNibName:@"KGAgencyHomePageScreeningCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KGAgencyHomePageScreeningCell"];
    }
    return _leftListView;
}
/** 左侧筛选右边栏 */
- (UITableView *)onlyListView{
    if (!_onlyListView) {
        _onlyListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth, self.screenView.bounds.size.height)];
        _onlyListView.delegate = self;
        _onlyListView.dataSource = self;
        _onlyListView.backgroundColor = [UIColor clearColor];
        _onlyListView.emptyDataSetSource = self;
        _onlyListView.emptyDataSetDelegate = self;
        _onlyListView.showsVerticalScrollIndicator = NO;
        _onlyListView.showsHorizontalScrollIndicator = NO;
        _onlyListView.tableFooterView = [UIView new];
        _onlyListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.screenView addSubview:_onlyListView];
        [_onlyListView registerNib:[UINib nibWithNibName:@"KGAgencyHomePageScreeningCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KGAgencyHomePageScreeningCell"];
    }
    return _onlyListView;
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
