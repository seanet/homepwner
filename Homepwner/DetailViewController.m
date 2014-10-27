//
//  DetailViewController.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-21.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "AssetTypePickerController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize item=_item,dismissBlock=_dismissBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}

-(id)initForNewItem:(BOOL)isNew
{
    self=[super initWithNibName:nil bundle:nil];
    if(self){
        if(isNew){
            UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [self.navigationItem setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [self.navigationItem setLeftBarButtonItem:cancelItem];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        self.view.backgroundColor=[UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    }else if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone){
        self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    
    scrollView.contentSize=scrollView.bounds.size;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [nameField setText:[self.item itemName]];
    serialNumberField.text=[self.item serialNumber];
    valueField.text=[NSString stringWithFormat:@"%d",[self.item valueInDollars]];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceReferenceDate:self.item.dateCreated];
    dateLabel.text=[dateFormatter stringFromDate:date];
    
    NSString *imageKey=[self.item imageKey];
    if(imageKey){
        UIImage *imageToDisplay=[[BNRImageStore sharedStore]imageForKey:imageKey];
        [imageView setImage:imageToDisplay];
    }else{
        [imageView setImage:nil];
    }
    
    NSString *typeString=[[self.item assetType]valueForKey:@"label"];
    if(!typeString){
        typeString=NSLocalizedString(@"None", nil);
    }
    
    [assetTypeButton setTitle:[[NSLocalizedString(@"Type", nil) stringByAppendingString:@": "] stringByAppendingString:typeString] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    [self.item setItemName:nameField.text];
    [self.item setSerialNumber:serialNumberField.text];
    [self.item setValueInDollars:[valueField.text intValue]];
}

-(BOOL)automaticallyAdjustsScrollViewInsets
{
    return YES;
}

-(void)setItem:(BNRItem *)i
{
    _item=i;
    self.navigationItem.title=[self.item itemName];
}

- (IBAction)takePhoto:(id)sender {
    if([imagePickerPopover isPopoverVisible]){
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover=nil;
        return;
    }
    
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePickerController setDelegate:self];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        imagePickerPopover=[[UIPopoverController alloc]initWithContentViewController:imagePickerController];
        imagePickerPopover.delegate=self;
        
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)showAssetTypePicker:(id)sender {
    AssetTypePickerController *assetTypePickerController=[[AssetTypePickerController alloc]init];
    [assetTypePickerController setItem:self.item];
    
    [self.navigationController pushViewController:assetTypePickerController animated:YES];
}

-(void)save:(id)sender
{
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:self.dismissBlock];
}
    
-(void)cancel:(id)sender
{
    [[BNRItemStore sharedStore]removeItem:self.item];
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey=[self.item imageKey];
    if(oldKey){
        [[BNRImageStore sharedStore]deleteImageForKey:oldKey];
    }
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailDataFromImage:image];
    
    CFUUIDRef newUniqueID=CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString=CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString *key=(__bridge NSString *)newUniqueIDString;
    [self.item setImageKey:key];
    
    [[BNRImageStore sharedStore]setImage:image forKey:key];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover=nil;
        [imageView setImage:image];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPopoverController Delegate

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover=nil;
}

@end
