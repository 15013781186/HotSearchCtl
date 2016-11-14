//
//  DQHotSearchViewController.m
//  DQHotSearch
//
//  Created by DQ on 16/4/16.
//  Copyright © 2016年 GuanzhouDQ. All rights reserved.
//

#import "DQHotSearchViewController.h"
#import "DQTextFild.h"
#import "HotSearchTableViewCell.h"
#import "SearchHistoryRecordfooter.h"
#import "SearchViewController.h"
#import "SearchRecordTableViewCell.h"

#define KsearchRecordCellId @"SearcgRecodeCell"
#define KHotSearchCellId @"KHotSearchCell"
#define KHotSearchFooterClass @"SearchHistoryRecordfooter"
#define KHotsearchFooterId @"HotSearchFooter"
#define KHotsearchFooterId2 @"HotSearchFooter2"
#define KSearchRecordArr @"KsearchRecordArr"//搜索的记录

#define HEX_COLOR(x_RGB) [UIColor colorWithRed:((float)((x_RGB & 0xFF0000) >> 16))/255.0 green:((float)((x_RGB & 0xFF00) >> 8))/255.0 blue:((float)(x_RGB & 0xFF))/255.0 alpha:1.0f]

@interface DQHotSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DQTextFild *BYsearchTextFd;
@property (nonatomic, strong) UITableView *SearchTableView;//搜索的记录
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *HotDataArr;
@property (nonatomic, assign) BOOL isChange;
@end

@implementation DQHotSearchViewController
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (NSMutableArray *)HotDataArr{
    if (!_HotDataArr) {
        _HotDataArr = [NSMutableArray new];
    }
    return _HotDataArr;
}
-(UITableView *)SearchTableView{
    if (!_SearchTableView) {
        _SearchTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _SearchTableView.delegate = self;
        _SearchTableView.dataSource = self;
        [self.view addSubview:_SearchTableView];
        [_SearchTableView registerClass:[SearchRecordTableViewCell class] forCellReuseIdentifier:KsearchRecordCellId];
         [_SearchTableView registerClass:[HotSearchTableViewCell class] forCellReuseIdentifier:KHotSearchCellId];
        [_SearchTableView registerNib:[UINib nibWithNibName:KHotSearchFooterClass bundle:nil] forHeaderFooterViewReuseIdentifier:KHotsearchFooterId];
        [_SearchTableView registerNib:[UINib nibWithNibName:KHotSearchFooterClass bundle:nil] forHeaderFooterViewReuseIdentifier:KHotsearchFooterId2];
        _SearchTableView.backgroundColor = HEX_COLOR(0xF2F2F2);
    }
    return _SearchTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChange = NO;
    self.BYsearchTextFd = [[DQTextFild alloc]initWithFrame:CGRectMake(50, 33,self.view.frame.size.width-100,31)];
    self.BYsearchTextFd.placeholder = @"请输入关键词";
    self.BYsearchTextFd.background = [UIImage imageNamed:@"搜索-背景"];
    self.BYsearchTextFd.delegate = self;
    self.BYsearchTextFd.keyboardType = UIKeyboardTypeWebSearch;
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
    img.frame = CGRectMake(10, 0,20,20);
    self.BYsearchTextFd.leftView = img;
    self.BYsearchTextFd.leftViewMode = UITextFieldViewModeAlways;
    self.BYsearchTextFd.font = [UIFont fontWithName:@"Arial" size:14];
    self.navigationItem.titleView = self.BYsearchTextFd;
    self.view.backgroundColor = HEX_COLOR(0xF2F2F2);
    [self loadingData];
    self.SearchTableView.backgroundColor = [UIColor clearColor];
    
}
- (void)loadingData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:KSearchRecordArr];
    if ((!(arr.count==0))&&(![arr isKindOfClass:[NSNull class]])) {
       
        //self.HistoryFooter.deleteBtn.enabled = YES;
        self.dataArr = [arr mutableCopy];
    }
    
    NSArray *array = @[@"鞋子",@"全球时尚",@"天天搞机",@"苏宁易购",@"好",@"热门推荐内容",@"猜你喜欢"];
    NSArray *array1 = @[@"童装",@"可爱的你会喜欢",@"帮你整理好的",@"超实惠",@"聚名牌",@"有好货"];
    [self.HotDataArr addObject:array];
    [self.HotDataArr addObject:array1];
    [self.SearchTableView reloadData];
}
- (void)keyBoardHide:(UITapGestureRecognizer *)Tap{
    
    [self.BYsearchTextFd resignFirstResponder];
    
}
- (void)deleteBtnAction:(UIButton *)sender{
    [self createdAlertview:@"确定要删除历史记录"];
}
- (void)changeBtnAction:(UIButton *)sender{
    
    if (self.isChange == NO) {
        self.isChange = YES;
        [self.SearchTableView reloadData];
        return;
    }else{
        self.isChange = NO;
        [self.SearchTableView reloadData];
        return;
    
    }

}
//重写手势的方法 手势会影响 cell的点击
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
    }else{
        return YES;
    }
    
}
#pragma mark 提示框
- (void)createdAlertview:(NSString *)str{
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str  preferredStyle:UIAlertControllerStyleAlert];
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.dataArr removeAllObjects];
        //self.HistoryFooter.deleteBtn.enabled = NO;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.dataArr forKey:KSearchRecordArr];
        [defaults synchronize];
        [self.SearchTableView reloadData];
        
    }]];
    [self presentViewController:alertCtl animated:YES completion:nil];
    
}
#pragma mark - tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 ) {
        SearchRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KsearchRecordCellId];
        if (self.dataArr.count!=0) {
            cell.labeText.text = self.dataArr[self.dataArr.count-1-indexPath.row];
        }
        return cell;
    }else{
        HotSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotSearchCellId];
        if (self.HotDataArr.count !=0) {
            if (self.isChange == NO) {
                [cell infortdataArr:[self.HotDataArr firstObject]];
            }else{
                [cell infortdataArr:[self.HotDataArr lastObject]];
            }
            
            cell.block = ^(NSInteger index){
                SearchViewController *search = [SearchViewController new];
                if (self.isChange == NO) {
                    search.title = [self.HotDataArr firstObject][index];
                }else{
                
                    search.title = [self.HotDataArr lastObject][index];

                }
                
                [self.navigationController pushViewController:search animated:YES];
            };
        }
        cell.DBlock =^{
            [self.BYsearchTextFd resignFirstResponder];
        };
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else{
        return 300;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if (section == 0) {
      SearchHistoryRecordfooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KHotsearchFooterId];
        footer.img.image = [UIImage imageNamed:@"历史搜索"];
        footer.labelHis.text = @"历史搜索";
        UIButton *Deletbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        Deletbtn.frame = CGRectMake(self.view.frame.size.width-50,0,40, 45);
        [Deletbtn setImage:[UIImage imageNamed:@"历史删除"] forState:UIControlStateNormal];
        [footer addSubview:Deletbtn];
        [Deletbtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBoardHide:)];
        [footer addGestureRecognizer:tap];
        return footer;
    }else{
         SearchHistoryRecordfooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KHotsearchFooterId2];
        footer.img.image = [UIImage imageNamed:@"热门搜索"];
        footer.labelHis.text = @"热门搜索";
        UIButton *ChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ChangeBtn.frame = CGRectMake(self.view.frame.size.width-80,0, 60,45);
        [ChangeBtn setTitle:@"换一批" forState:UIControlStateNormal];
        [ChangeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [footer addSubview:ChangeBtn];
        [ChangeBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBoardHide:)];
        [footer addGestureRecognizer:tap];
        return footer;
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,1)];
    if (section == 0) {
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-15, 1)];
        view1.backgroundColor = HEX_COLOR(0xDDDDDD);
        [footerView addSubview:view1];
    }
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 45;
        
    }else{
        return 45;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SearchViewController *search = [SearchViewController new];
        if (self.dataArr.count!=0) {
            
            search.title = self.dataArr[self.dataArr.count-1-indexPath.row];
        }
        [self.navigationController pushViewController:search animated:YES];
        
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}
#pragma mark textFild的代理方法

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        return;
    }
    [self.dataArr addObject:textField.text];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.dataArr forKey:KSearchRecordArr];
    [defaults synchronize];
    [self.SearchTableView reloadData];
    SearchViewController *search = [SearchViewController new];
    search.title = textField.text;
    [self.navigationController pushViewController:search animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.BYsearchTextFd resignFirstResponder];
    return YES;
}
@end
