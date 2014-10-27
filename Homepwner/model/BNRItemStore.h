//
//  BNRItemStore.h
//  Homepwner
//
//  Created by zhaoqihao on 14-8-20.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BNRItem.h"

@interface BNRItemStore : NSObject
{
    NSMutableArray *_allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+(BNRItemStore *)sharedStore;

-(NSArray *)allItems;
-(BNRItem *)createItem;
-(void)removeItem:(BNRItem *)p;
-(void)moveItemAtIndex:(NSUInteger)from toIndex:(NSUInteger)to;

-(NSString *)itemArchivePath;
-(BOOL)saveChanges;

-(NSArray *)allAssetTypes;

@end
