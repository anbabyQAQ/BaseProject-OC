//
//  BAProfileHeadCell.m
//  BaseProject
//
//  Created by tyl on 2017/5/3.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BAProfileHeadCell.h"

@interface BAProfileHeadCell ()


@property (strong, nonatomic)  UILabel      *userNameLabel;
@property (strong, nonatomic)  UILabel      *accountLabel;
@property (strong, nonatomic)  UILabel      *certLabel;

@end

@implementation BAProfileHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithreuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.userNameLabel = [[UILabel alloc] init];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        self.userNameLabel.textColor = [UIColor darkTextColor];
        self.userNameLabel.font = [UIFont systemFontOfSize:15];
        self.userNameLabel.text = @"完成度";

        
        self.accountLabel = [[UILabel alloc] init];
        self.accountLabel.textAlignment = NSTextAlignmentLeft;
        self.accountLabel.textColor = [UIColor colorWithRed:251/255.0 green:108/255.0 blue:69/255.0 alpha:1];
        self.accountLabel.text = @"完成度";
        self.accountLabel.font = [UIFont systemFontOfSize:15];
        
        self.certLabel = [[UILabel alloc] init];
        self.certLabel.textAlignment = NSTextAlignmentRight;
        self.certLabel.textColor = [UIColor colorWithRed:251/255.0 green:108/255.0 blue:69/255.0 alpha:1];
        self.certLabel.text = @"完成度";
        self.certLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:self.certLabel];
        [self.contentView addSubview:self.accountLabel];
        [self.contentView addSubview:self.userNameLabel];
        
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        
        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        
        [self.certLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(BA_SCREEN_WIDTH/2);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
       
    }
    return self;
    
}

- (void)setModel:(BAUserModel *)model{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
