//
//  SPPursuitHeadTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/21.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitHeadTabCell.h"

@interface SPPursuitHeadTabCell()
@property (nonatomic,strong)UIImageView *headimg;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UIImageView *sexImg;
//@property (nonatomic,strong)UILabel *occupation;

@end

@implementation SPPursuitHeadTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.headimg];
    [self.contentView addSubview:self.nickeLab];
    [self.contentView addSubview:self.sexImg];
//    [self.contentView addSubview:self.occupation];
    
    
    
    [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(18);
        make.width.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.nickeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headimg).offset(5);
        make.left.equalTo(self.headimg.mas_right).offset(10);
    }];
    
    [self.sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headimg);
        make.left.equalTo(self.nickeLab);
    }];
    
//    [self.occupation mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nickeLab);
//        make.top.equalTo(self.nickeLab.mas_bottom).offset(10);
//    }];
}

- (UIImageView *)headimg{
    if (_headimg == nil) {
        _headimg = [[UIImageView alloc] init];
        
    }
    return _headimg;
}

- (UILabel *)nickeLab{
    if (_nickeLab == nil) {
        _nickeLab = [[UILabel alloc] init];
        _nickeLab.text = @"昵称";
        _nickeLab.font = Font16;
        _nickeLab.textColor = FirstWordColor;
    }
    return _nickeLab;
}

- (UIImageView *)sexImg{
    if (_sexImg == nil) {
        _sexImg = [[UIImageView alloc] init];
    }
    return _sexImg;
}

//- (UILabel *)occupation{
//    if (_occupation == nil) {
//        _occupation = [[UILabel alloc] init];
//        _occupation.font = FONT(14);
//        _occupation.textColor = SecondWordColor;
//    }
//    return _occupation;
//}


- (void)setModel:(SPPersonModel *)model{
    if (_model != model) {
        _model = model;
        self.headimg.image = [UIImage imageNamed:_model.avatar];
        self.nickeLab.text = _model.nickName;
        self.sexImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",_model.sex]];
//        self.occupation.text = _model.occupation;
        [self.headimg.layer setCornerRadius:25];
        self.headimg.clipsToBounds = YES;

    }
}



@end
