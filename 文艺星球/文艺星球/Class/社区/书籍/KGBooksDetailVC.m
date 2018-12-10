//
//  KGBooksDetailVC.m
//  文艺星球
//
//  Created by 文艺星球 on 2018/11/14.
//  Copyright © 2018年 KG丿轩帝. All rights reserved.
//

#import "KGBooksDetailVC.h"
#import "KGBooksDetailHeaderView.h"
#import "KGBooksCell.h"
#import "KGWriteReviewVC.h"
#import "KGAllBooksReviewVC.h"

@interface KGBooksDetailVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/** 图书列表 */
@property (nonatomic,strong) UITableView *listView;
/** 头视图 */
@property (nonatomic,strong) KGBooksDetailHeaderView *headerView;
/** 书籍详情 */
@property (nonatomic,copy) NSDictionary *booksDetailDic;
/** 推荐 */
@property (nonatomic,copy) NSArray *dataArr;

@end

@implementation KGBooksDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /** 导航栏标题颜色 */
    [self changeNavBackColor:[UIColor clearColor] controller:self];
    [self changeNavTitleColor:KGBlackColor font:KGFontSHBold(15) controller:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /** 定制左侧返回按钮 */
    [self setLeftNavItemWithFrame:CGRectMake(15, 0, 50, 30) title:nil image:[UIImage imageNamed:@"fanhuibai"] font:nil color:nil select:@selector(leftNavAction)];
    self.view.backgroundColor = KGWhiteColor;
    
    [self setUpListView];
    [self requestData];
}
/** 请求数据 */
- (void)requestData{
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [KGRequest postWithUrl:SelectBookByID parameters:@{@"id":self.sendID,@"pageIndex":@"1",@"pageSize":@"20"} succ:^(id  _Nonnull result) {
        [hud hideAnimated:YES];
        if ([result[@"status"] integerValue] == 200) {
            weakSelf.booksDetailDic = result[@"data"];
            [weakSelf.headerView viewDetailWithDictionary:weakSelf.booksDetailDic];
            weakSelf.dataArr = weakSelf.booksDetailDic[@"interestedList"];
        }
        [weakSelf.listView reloadData];
    } fail:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [weakSelf.listView reloadData];
    }];
}
/** 导航栏左侧点击事件 */
- (void)leftNavAction{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 头视图 */
- (UIView *)setUpHeaderView{
    self.headerView = [[KGBooksDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth, 835)];
    __weak typeof(self) weakSelf = self;
    self.headerView.writeMyReview = ^(NSString * _Nonnull stateStr) {
        KGWriteReviewVC *vc = [[KGWriteReviewVC alloc]initWithNibName:@"KGWriteReviewVC" bundle:[NSBundle mainBundle]];
        vc.sendID = weakSelf.sendID;
        [weakSelf pushHideenTabbarViewController:vc animted:YES];
    };
    self.headerView.lockAllCommend = ^{
        KGAllBooksReviewVC *vc = [[KGAllBooksReviewVC alloc]init];
        vc.sendID = weakSelf.sendID;
        [weakSelf pushHideenTabbarViewController:vc animted:YES];
    };
    return self.headerView;
}
// MARK: --创建机构列表--
- (void)setUpListView{
    self.listView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KGScreenWidth, KGScreenHeight)];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.emptyDataSetSource = self;
    self.listView.emptyDataSetDelegate = self;
    self.listView.tableFooterView = [UIView new];
    self.listView.tableHeaderView = [self setUpHeaderView];
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.listView];
    
    [self.listView registerNib:[UINib nibWithNibName:@"KGBooksCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KGBooksCell"];
}
/** 空页面 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"kongyemian"];
}
/** 代理方法以及数据源 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KGBooksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGBooksCell"];
    if (self.dataArr.count > 0) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        [cell cellDetailWithDactionary:dic];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KGBooksDetailVC *vc = [[KGBooksDetailVC alloc]init];
    NSDictionary *dic = self.dataArr[indexPath.row];
    vc.sendID = [NSString stringWithFormat:@"%@",dic[@"id"]];
    [self pushHideenTabbarViewController:vc animted:YES];
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
