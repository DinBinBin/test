//
//  SPCardVideoTabCell.h
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPCardVideoTabCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIImageView *coverImg;
@property (nonatomic,strong)SPCoverModel *coverModel;

@end

NS_ASSUME_NONNULL_END
