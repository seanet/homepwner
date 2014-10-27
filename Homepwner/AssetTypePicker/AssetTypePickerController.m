//
//  AssetTypePickerController.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-25.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "AssetTypePickerController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@interface AssetTypePickerController ()

@end

@implementation AssetTypePickerController
@synthesize item=_item;

-(id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore]allAssetTypes]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *allAssets=[[BNRItemStore sharedStore]allAssetTypes];
    NSManagedObject *assetType=[allAssets objectAtIndex:[indexPath row]];
    
    NSString *assetLabel=[assetType valueForKey:@"label"];
    [cell.textLabel setText:assetLabel];
    
    if(assetType == self.item.assetType){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allAssets=[[BNRItemStore sharedStore]allAssetTypes];
    NSManagedObject *assetType=[allAssets objectAtIndex:[indexPath row]];
    [self.item setAssetType:assetType];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
