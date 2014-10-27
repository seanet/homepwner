//
//  HomePwnerItemCell.h
//  Homepwner
//
//  Created by zhaoqihao on 14-8-24.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellWithSelector.h"

@interface HomePwnerItemCell : CellWithSelector

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak,nonatomic)id controller;
@property (weak,nonatomic)UITableView *tableView;

- (IBAction)showImage:(id)sender;

@end
