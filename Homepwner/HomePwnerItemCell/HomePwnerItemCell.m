//
//  HomePwnerItemCell.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-24.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "HomePwnerItemCell.h"

@implementation HomePwnerItemCell
@synthesize thumbnailView=_thumbnailView,nameLabel=_nameLabel,serialNumberLabel=_serialNumberLabel,valueLabel=_valueLabel;
@synthesize controller=_controller,tableView=_tableView;

- (IBAction)showImage:(id)sender {
    [super action:sender withSelectorString:@"showImage:atIndexPath:" withTableView:self.tableView withController:self.controller];
}

@end
