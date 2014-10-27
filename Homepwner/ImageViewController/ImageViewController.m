//
//  ImageViewController.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-24.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController
@synthesize image=_image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size=[self.image size];
    [imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    scrollView.contentSize=size;
    
    [imageView setImage:self.image];
}

@end
