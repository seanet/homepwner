//
//  BNRImageStore.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-21.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(BNRImageStore *)sharedStore
{
    static BNRImageStore *_shareStore=nil;
    if(!_shareStore){
        _shareStore=[[super allocWithZone:NULL]init];
    }
    return _shareStore;
}

-(id)init
{
    self=[super init];
    if(self){
        dictionary=[[NSMutableDictionary alloc]init];
        
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCaches:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Instance Methods

-(void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    NSString *imagePath=[self imagePathForKey:s];
    NSData *d=UIImagePNGRepresentation(i);
    [d writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)s
{
    UIImage *i= [dictionary objectForKey:s];
    
    if(!i){
        i=[UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        if(i){
            [dictionary setObject:i forKey:s];
        }else{
            NSLog(@"Error! Unable to find %@",[self imagePathForKey:s]);
        }
    }
    
    return i;
}

-(void)deleteImageForKey:(NSString *)s
{
    if(!s){
        return;
    }
    
    [dictionary removeObjectForKey:s];
    
    NSString *imagePath=[self imagePathForKey:s];
    [[NSFileManager defaultManager]removeItemAtPath:imagePath error:nil];
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

#pragma mark - Memory warning Notification

-(void)clearCaches:(NSNotification *)note
{
    NSLog(@"flushing %d images of out caches",[dictionary count]);
    [dictionary removeAllObjects];
}

@end
