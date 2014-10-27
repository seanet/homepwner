//
//  ItemsTableViewController.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-20.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "DetailViewController.h"
#import "HomePwnerItemCell.h"
#import "ImageViewController.h"

@interface ItemsTableViewController ()

@end

@implementation ItemsTableViewController

-(id)init
{
    self=[super initWithStyle:UITableViewStylePlain];
    if(self){
        self.navigationItem.title=NSLocalizedString(@"Homepwner", @"Application Name");
        
        UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
        [self.navigationItem setLeftBarButtonItem:self.editButtonItem];
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib=[UINib nibWithNibName:@"HomePwnerItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HomePwnerItemCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NoMoreCell"];
}

#pragma mark - UITableView DataSource Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore]allItems]count]+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]!=[[[BNRItemStore sharedStore]allItems]count]){
        BNRItem *p=[[[BNRItemStore sharedStore]allItems]objectAtIndex:[indexPath row]];
        
        HomePwnerItemCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HomePwnerItemCell" forIndexPath:indexPath];
        
        [cell.nameLabel setText:p.itemName];
        [cell.serialNumberLabel setText:p.serialNumber];
        
        NSString *currentSymbol=[[NSLocale currentLocale]objectForKey:NSLocaleCurrencySymbol];
        [cell.valueLabel setText:[NSString stringWithFormat:@"%@%d",currentSymbol,p.valueInDollars]];

        [cell.thumbnailView setImage:p.thumbnail];
        
        [cell setController:self];
        [cell setTableView:tableView];
        
        return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoMoreCell" forIndexPath:indexPath];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        [cell.textLabel setText:NSLocalizedString(@"No More Item", nil)];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]!=[[[BNRItemStore sharedStore]allItems]count]){
        return 69;
    }else{
        return 50;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]!=[[[BNRItemStore sharedStore]allItems]count]){
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]!=[[[BNRItemStore sharedStore]allItems]count]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        BNRItem *p=[[[BNRItemStore sharedStore]allItems]objectAtIndex:[indexPath row]];
        [[BNRItemStore sharedStore]removeItem:p];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items=[[BNRItemStore sharedStore]allItems];
    
    if([indexPath row]!=[items count]){
        DetailViewController *detailViewController=[[DetailViewController alloc]initForNewItem:NO];
        BNRItem *selectedItem=[items objectAtIndex:[indexPath row]];
        [detailViewController setItem:selectedItem];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - Instance Methods

-(void)addNewItem:(id)sender
{
    BNRItem *newItem=[[BNRItemStore sharedStore]createItem];
    
    DetailViewController *detailViewController=[[DetailViewController alloc]initForNewItem:YES];
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{
        [self.tableView reloadData];
    }];
    
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath
{
//    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad){
    if(YES){
        BNRItem *i=[[[BNRItemStore sharedStore]allItems]objectAtIndex:[indexPath row]];
        NSString *imageKey=[i imageKey];
        UIImage *image=[[BNRImageStore sharedStore]imageForKey:imageKey];
        
        if(!image){
            return;
        }
        
        ImageViewController *imageViewController=[[ImageViewController alloc]init];
        [imageViewController setImage:image];
        
        //-------ios 8 -------
        
        
        //-------ios 7 -------
        
        CGRect rect=[self.view convertRect:[sender bounds] fromView:sender];
        imagePopoverController=[[UIPopoverController alloc]initWithContentViewController:imageViewController];
        imagePopoverController.delegate=self;
        [imagePopoverController setPopoverContentSize:image.size animated:YES];
        [imagePopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - UITableView Methods

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if([destinationIndexPath row]!=[[[BNRItemStore sharedStore]allItems]count]){
        [[BNRItemStore sharedStore]moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
    }else{
        [tableView reloadData];
    }
    
}

#pragma mark - UIPopoverController Delegate

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopoverController dismissPopoverAnimated:YES];
    imagePopoverController=nil;
}

#pragma mark -

-(BOOL)automaticallyAdjustsScrollViewInsets
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

@end
