//
//  BNRImageStore.h
//  Homepwner
//
//  Created by zhaoqihao on 14-8-21.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+(BNRImageStore *)sharedStore;

-(void)setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;

-(NSString *)imagePathForKey:(NSString *)key;

@end
