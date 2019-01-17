//
//  SPChatListViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/4.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPChatListViewController.h"
#import "SPConversationViewController.h"


@interface SPChatListViewController ()<RCIMUserInfoDataSource>
@property (nonatomic,strong)NSArray<RCConversationModel *> *modelArr;
@property (nonatomic, strong) NSMutableArray <SPPersonModel *> *personArr;
@end

@implementation SPChatListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION)]];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.personArr = [NSMutableArray arrayWithCapacity:0];
    
    // 替换back按钮
    UIBarButtonItem *backBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"back"
                                                                     imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)
                                                                              target:self
                                                                              action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    self.title = @"聊天窗口";
    
    self.conversationListTableView.tableFooterView = [UIView new];
    self.conversationListTableView.backgroundColor = PTBackColor;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    lab.center = self.conversationListTableView.center;
    lab.text = @"暂时没有会话";
    lab.font = Font16;
    lab.textColor = SecondWordColor;
    self.emptyConversationView = lab;
    self.emptyConversationView.hidden = YES;
    
    [RCIM sharedRCIM].userInfoDataSource = self;

    
}

- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    NSLog(@"会话列表:%@",dataSource);
    self.modelArr = dataSource.copy;
    
    [self.personArr removeAllObjects];
    for (RCConversationModel *model in self.modelArr) {
        WEAKSELF
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showLoadToView:self.view];
        });

        [JDWNetworkHelper POST:SPURL_API_info parameters:@{@"user_id":model.targetId} success:^(id responseObject) {
            NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
            if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
                SPPersonModel *model = [SPPersonModel modelWithJSON:responseDic[@"data"]];
                [self.personArr addObject:model];
                
            }else{
                [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
                
            }
            [MBProgressHUD hideHUDForView:strongSelf.view];
            
        } failure:^(NSError *error) {
            [MBProgressHUD showMessage:Networkerror];
            [MBProgressHUD showAutoMessage:Networkerror];
            [MBProgressHUD hideHUDForView:strongSelf.view];
            
        }];
    }
    
    return dataSource;
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    SPConversationViewController *conversationVC = [[SPConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = @"会话窗口";
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *))completion{
    
    for (SPPersonModel *model in self.personArr) {
        if ([userId isEqualToString:[NSString stringWithFormat:@"%d",model.userId]]) {
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:model.nickName portrait:model.avatar];
            return completion(userInfo);
        }
    }
    
}

@end
