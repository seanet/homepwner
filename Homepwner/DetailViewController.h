//
//  DetailViewController.h
//  Homepwner
//
//  Created by zhaoqihao on 14-8-21.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIView *contentView;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIButton *assetTypeButton;
    
    UIPopoverController *imagePickerPopover;
}

@property (nonatomic,strong)BNRItem *item;
@property(nonatomic,copy)void (^dismissBlock)(void);

-(id)initForNewItem:(BOOL)isNew;

- (IBAction)takePhoto:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)showAssetTypePicker:(id)sender;

@end
