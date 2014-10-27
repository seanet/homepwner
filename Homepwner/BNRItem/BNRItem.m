//
//  BNRItem.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-25.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

-(void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize=[image size];
    CGRect newRect=CGRectMake(0, 0, 45, 45);
    
    float ratio=MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    UIGraphicsBeginImageContextWithOptions(newRect.size,NO, 0.0);
    
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.height=ratio*origImageSize.height;
    projectRect.size.width=ratio*origImageSize.width;
    projectRect.origin.x=(newRect.size.width-projectRect.size.width)/2.0;
    projectRect.origin.y=(newRect.size.height-projectRect.size.height)/2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage=UIGraphicsGetImageFromCurrentImageContext();
    [self setPrimitiveValue:smallImage forKey:@"thumbnail"];
    
    NSData *data=UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    UIGraphicsEndImageContext();
}

-(void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *image=[UIImage imageWithData:self.thumbnailData];
    [self setPrimitiveValue:image forKey:@"thumbnail"];
}

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    NSTimeInterval t=[[NSDate date]timeIntervalSinceReferenceDate];
    [self setDateCreated:t];
}

@end
