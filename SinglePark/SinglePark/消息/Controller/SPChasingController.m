//
//  SPChasingController.m
//  SinglePark
//
//  Created by DBB on 2018/10/25.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPChasingController.h"
#import "SPChasingTabCell.h"
#import "SPChasingTwoTabCell.h"
#import "SPThirdTabwCell.h"

@interface SPChasingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *messageTabView;
@property (nonatomic,copy)NSString *chasingOne;
@property (nonatomic,copy)NSString *chasingTwo;
@property (nonatomic,copy)NSString *chasingThred;
@property (nonatomic,strong)NSMutableArray *fixedarr;

@end

@implementation SPChasingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"追讯";
    
    [self setUI];
    [self getModel];
}

- (void)setUI{
    [self.messageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)getModel{
    
    NSDictionary *dic = @{@"head":@"chase",
                          @"nickName":@"追讯",
                          @"messsage":@"拒绝了你",
                          @"coverimg":@"4",
                          @"time":@"12:00"};
    NSDictionary *dic2 = @{@"head":@"good",
                           @"nickName":@"点赞",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"coverimg":@"4",
                           @"time":@"14:00"};
    NSDictionary *dic3 = @{@"head":@"message",
                           @"nickName":@"评论",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"coverimg":@"4",
                           @"time":@"12:00"};
    NSDictionary *dic4 = @{@"head":@"notice",
                           @"nickName":@"单身公园",
                           @"messsage":@"接受了你",
                           @"coverimg":@"4",
                           @"time":@"12:00"};
    SPMessageModel *model = [[SPMessageModel alloc] initWithDataDic:dic];
    SPMessageModel *model2 = [[SPMessageModel alloc] initWithDataDic:dic2];
    SPMessageModel *model3 = [[SPMessageModel alloc] initWithDataDic:dic3];
    SPMessageModel *model4 = [[SPMessageModel alloc] initWithDataDic:dic4];

    self.fixedarr  = [NSMutableArray arrayWithObjects:model4,model3,model,model2, nil];
    [self.messageTabView reloadData];
    
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fixedarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPMessageModel *model = self.fixedarr[indexPath.row];
    if ([model.head floatValue] == 1) {
        SPChasingTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.chasingOne forIndexPath:indexPath];
        cell.newsmodel = model;
        return cell;
    }else if ([model.head floatValue] == 2){
        SPChasingTwoTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.chasingTwo forIndexPath:indexPath];
        cell.newsmodel = model;
        return cell;

    }else{
        SPThirdTabwCell *cell = [tableView dequeueReusableCellWithIdentifier:self.chasingThred forIndexPath:indexPath];
        cell.newsmodel = model;
        return cell;

    }
}



- (UITableView *)messageTabView{
    if (_messageTabView == nil) {
        _messageTabView = [[UITableView alloc] init];
        _messageTabView.dataSource = self;
        _messageTabView.delegate = self;
        _messageTabView.backgroundColor = PTBackColor;
        _messageTabView.tableFooterView = [[UIView alloc] init];
        _messageTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.chasingOne = @"chasingOne";
        self.chasingTwo = @"chasingTwo";
        self.chasingThred = @"chasingThred";
        [_messageTabView registerClass:[SPChasingTabCell  class] forCellReuseIdentifier:self.chasingOne];
        [_messageTabView registerClass:[SPChasingTwoTabCell  class] forCellReuseIdentifier:self.chasingTwo];
        [_messageTabView registerClass:[SPThirdTabwCell  class] forCellReuseIdentifier:self.chasingThred];
        [self.view addSubview:_messageTabView];
    }
    return _messageTabView;
}




@end
