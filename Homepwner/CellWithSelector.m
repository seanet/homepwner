//
//  CellWithSelector.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-24.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "CellWithSelector.h"

@implementation CellWithSelector

- (void)action:(id)sender withSelectorString:(NSString *)selectorString withTableView:(UITableView *)tableView withController:(id)controller
{
    NSIndexPath *indexPath=[tableView indexPathForCell:self];
    if(indexPath){
        SEL selector=NSSelectorFromString(selectorString);
        if([controller respondsToSelector:selector]){
            [controller performSelector:selector withObject:sender withObject:indexPath];
        }
    }
}

@end
