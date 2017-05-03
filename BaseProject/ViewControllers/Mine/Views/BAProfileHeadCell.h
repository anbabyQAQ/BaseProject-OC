//
//  BAProfileHeadCell.h
//  BaseProject
//
//  Created by tyl on 2017/5/3.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BAUserModel;

@interface BAProfileHeadCell : UITableViewCell

@property (nonatomic, strong) BAUserModel *model;

- (instancetype)initWithreuseIdentifier:(NSString *)reuseIdentifier;

@end
