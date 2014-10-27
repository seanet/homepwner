//
//  CellWithSelector.h
//  Homepwner
//
//  Created by zhaoqihao on 14-8-24.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellWithSelector : UITableViewCell

- (void)action:(id)sender withSelectorString:(NSString *)selectorString withTableView:(UITableView *)tableView withController:(id)controller;

@end
