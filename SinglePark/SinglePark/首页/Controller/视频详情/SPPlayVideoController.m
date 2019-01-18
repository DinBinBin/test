
//
//  SPPlayVideoController.m
//  SinglePark
//
//  Created by DBB on 2018/10/4.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPlayVideoController.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "SPCoverModel.h"
#import "PlayerScrollView.h"
#import "KJPushAnimator.h"

@interface SPPlayVideoController ()<UINavigationControllerDelegate>
//播放器，数据源
@property (nonatomic,strong)PlayerScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *videArr;


@end

@implementation SPPlayVideoController

- (PlayerScrollView *)scrollView{
    if (!_scrollView) {
        self.scrollView =[[PlayerScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+0)];
        __weak typeof(self) weakSelf =self;
        _scrollView.passCurrentPlayerIndex = ^(NSInteger index) {
            //此时需要讲之前的播放视频的view 隐藏掉，只显示占位图
            if (index == self.datasource.count - 1 ) {
                NSLog(@"此处调用加载方法，加载最新的视频信息");
                [weakSelf loadMoreData];
            }
            if(index == 0){
                [weakSelf loadData];
            }else{
                
            }
        };
        [self.view addSubview:self.scrollView];
    }
    return _scrollView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView registNotification];
//    [self.scrollView.player play];
//    self.originalDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scrollView.player pause];
    [self.scrollView removeNOtification];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载视频数据源
    [self loadData];
    //加载视频，准备播放
    self.videArr = [NSMutableArray array];
    if (self.datasource.count) {
        for (SPPersonModel *model in self.datasource) {
            if (model.first_video.count > 0) {
                model.videoModel = model.first_video[0];
                [self.videArr addObject:model];
            }
        }
        
        [self.scrollView setMovePlayerWithInfoModelArray:self.videArr withPlayIndex:self.selectIndex];

    }
    

    UIButton *backBtn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(0, 25, 50, 50);
    [backBtn1 setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(handle_backBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn1];
    

    //添加刷新控件
//    [self.view ar_addAndroidRefreshWithDelegate:self];
//    self.view.ar_headerView.refreshOffset = 64.0f;
    
//    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoredata)];

}

- (void)handle_backBtn{
    [self.scrollView.player stop];
    self.scrollView.player = nil;
    [self.navigationController popViewControllerAnimated:YES];

}
//加载数据信息
- (void)loadData{
    NSString *choose;
    switch (self.choosetype) {
        case 1:
            choose = @"1";
            break;
        case 2:
            choose = @"2";
            
            break;
        case 3:
            choose = @"3";
            
            break;
        default:
            break;
    }
    

    self.videArr = [NSMutableArray array];
    //    获取视频列表
    self.num = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.num],@"page",@"10",@"limit", nil];
    if (self.islocal) {  //是本地
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.longitude] forKey:@"longitude"];
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.latitude] forKey:@"latitude"];
        
    }
    
    
    [JDWNetworkHelper POST:PTURL_API_Index parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *arr = [[SPPersonModel modelArrayWithJSON:responseDic[@"data"][@"items"]] mutableCopy];
            if (arr.count) {
                for (SPPersonModel *model in arr) {
                    if (model.first_video.count > 0) {
                        model.videoModel = model.first_video[0];
                        [self.videArr addObject:model];
                    }
                }
                [self.scrollView setMovePlayerWithInfoModelArray:self.videArr withPlayIndex:0];
            }
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [self.scrollView.mj_header endRefreshing ];
    }];

    
    
    
//    NSArray* videoAry = [NSArray arrayWithObjects:
//                         @"http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.mp4",
//                         @"http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.mp4",
//                         @"http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.mp4",
//
//                         @"http://ksy.fffffive.com/mda-hifsrhtqjn8jxeha/mda-hifsrhtqjn8jxeha.mp4",
//
//                         @"http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.mp4",
//                         @"http://ksy.fffffive.com/mda-hihvysind8etz7ga/mda-hihvysind8etz7ga.mp4",
//                         @"http://ksy.fffffive.com/mda-hiw60i3kczgum0av/mda-hiw60i3kczgum0av.mp4",
//                         @"http://ksy.fffffive.com/mda-hidnzn5r61qwhxp4/mda-hidnzn5r61qwhxp4.mp4",
//                         @"http://ksy.fffffive.com/mda-he1zy3rky0rwrf60/mda-he1zy3rky0rwrf60.mp4",
//                         @"http://ksy.fffffive.com/mda-hh6cxd0dqjqcszcj/mda-hh6cxd0dqjqcszcj.mp4",
//
//                         @"http://ksy.fffffive.com/mda-hics799vjrg0w5az/mda-hics799vjrg0w5az.mp4",
//                         @"http://ksy.fffffive.com/mda-hfshah045smezhtf/mda-hfshah045smezhtf.mp4",
//                         @"http://ksy.fffffive.com/mda-hh4mbturm902j7wi/mda-hh4mbturm902j7wi.mp4",
//                         @"http://ksy.fffffive.com/mda-hiwxzficjivwmsch/mda-hiwxzficjivwmsch.mp4",
//                         @"http://ksy.fffffive.com/mda-hhug2p7hfbhnv40r/mda-hhug2p7hfbhnv40r.mp4",
//                         @"http://ksy.fffffive.com/mda-hieuuaei6cufye2c/mda-hieuuaei6cufye2c.mp4",
//                         @"http://ksy.fffffive.com/mda-hibhufepe5m1tfw1/mda-hibhufepe5m1tfw1.mp4",
//                         @"http://ksy.fffffive.com/mda-hhzeh4c05ivmtiv7/mda-hhzeh4c05ivmtiv7.mp4",
//                         @"http://ksy.fffffive.com/mda-hfrigfn2y9jvzm72/mda-hfrigfn2y9jvzm72.mp4",
//                         @"http://ksy.fffffive.com/mda-himek207gvvqg3wq/mda-himek207gvvqg3wq.mp4",
//                         nil];
//
//
//    NSArray* imageAry = [NSArray arrayWithObjects:
//                         @"http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.jpg",
//                         @"http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.jpg",
//                         @"http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.jpg",
//
//                         @"http://ksy.fffffive.com/mda-hifsrhtqjn8jxeha/mda-hifsrhtqjn8jxeha.jpg",
//
//                         @"http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.jpg",
//                         @"http://ksy.fffffive.com/mda-hihvysind8etz7ga/mda-hihvysind8etz7ga.jpg",
//                         @"http://ksy.fffffive.com/mda-hiw60i3kczgum0av/mda-hiw60i3kczgum0av.jpg",
//                         @"http://ksy.fffffive.com/mda-hidnzn5r61qwhxp4/mda-hidnzn5r61qwhxp4.jpg",
//                         @"http://ksy.fffffive.com/mda-he1zy3rky0rwrf60/mda-he1zy3rky0rwrf60.jpg",
//                         @"http://ksy.fffffive.com/mda-hh6cxd0dqjqcszcj/mda-hh6cxd0dqjqcszcj.jpg",
//
//                         @"http://ksy.fffffive.com/mda-hics799vjrg0w5az/mda-hics799vjrg0w5az.jpg",
//                         @"http://ksy.fffffive.com/mda-hfshah045smezhtf/mda-hfshah045smezhtf.jpg",
//                         @"http://ksy.fffffive.com/mda-hh4mbturm902j7wi/mda-hh4mbturm902j7wi.jpg",
//                         @"http://ksy.fffffive.com/mda-hiwxzficjivwmsch/mda-hiwxzficjivwmsch.jpg",
//                         @"http://ksy.fffffive.com/mda-hhug2p7hfbhnv40r/mda-hhug2p7hfbhnv40r.jpg",
//                         @"http://ksy.fffffive.com/mda-hieuuaei6cufye2c/mda-hieuuaei6cufye2c.jpg",
//                         @"http://ksy.fffffive.com/mda-hibhufepe5m1tfw1/mda-hibhufepe5m1tfw1.jpg",
//                         @"http://ksy.fffffive.com/mda-hhzeh4c05ivmtiv7/mda-hhzeh4c05ivmtiv7.jpg",
//                         @"http://ksy.fffffive.com/mda-hfrigfn2y9jvzm72/mda-hfrigfn2y9jvzm72.jpg",
//                         @"http://ksy.fffffive.com/mda-himek207gvvqg3wq/mda-himek207gvvqg3wq.jpg",
//                         nil];
//    self.datasource =[NSMutableArray array];
//    for (int i = 0; i < 20 ; i ++) {
////        VideoInfoModel * model = [[VideoInfoModel alloc] init];
////        model.videoUrl = videoAry[i];
////        model.coverImageUrl = imageAry[i];
////        [self.datasource addObject:model];
//    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController  setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loadMoreData{

    NSString *choose;
    switch (self.choosetype) {
        case 1:
            choose = @"1";
            break;
        case 2:
            choose = @"2";
            
            break;
        case 3:
            choose = @"3";
            
            break;
        default:
            break;
    }
    
    //    获取视频列表
    self.num++;
    self.videArr = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.num],@"page",@"10",@"limit", nil];
    if (self.islocal) {  //是本地
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.longitude] forKey:@"longitude"];
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.latitude] forKey:@"latitude"];
        
    }
    
    
    
    [JDWNetworkHelper POST:PTURL_API_Index parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *arr = [[SPPersonModel modelArrayWithJSON:responseDic[@"data"][@"items"]] mutableCopy];
            if (arr.count) {
                for (SPPersonModel *model in arr) {
                    if (model.first_video.count > 0) {
                        model.videoModel = model.first_video[0];
                        [self.videArr addObject:model];
                    }
                }
                [self.scrollView addNewData:self.videArr];
            }

        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
        

        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        
    }];
    

    
}


@end
