//
//  ItemsTableViewController.h
//  Homepwner
//
//  Created by zhaoqihao on 14-8-20.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsTableViewController : UITableViewController<UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopoverController;
}

-(void)addNewItem:(id)sender;
-(void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath;

@end
