//
//  BNRItemStore.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-20.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

-(id)init
{
    self=[super init];
    if(self){
        model=[NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        
        NSString *path=[self itemArchivePath];
        NSURL *storeUrl=[NSURL fileURLWithPath:path];
        
        NSError *error=nil;
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]){
            [NSException raise:@"Open failed" format:@"Reason:%@",[error localizedDescription]];
        }
        
        context=[[NSManagedObjectContext alloc]init];
        [context setPersistentStoreCoordinator:psc];
        
        [context setUndoManager:nil];
        
        [self loadAllItems];
        
    }
    return self;
}

+(BNRItemStore *)sharedStore
{
    static BNRItemStore *sharedStore=nil;
    if(!sharedStore)
        sharedStore=[[super allocWithZone:nil]init];
    return sharedStore;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

-(NSArray *)allItems
{
    return _allItems;
}

-(BNRItem *)createItem
{
    double order;
    if([_allItems count]==0){
        order=1.0;
    }else{
        order= [[_allItems lastObject] orderingValue]+1.0;
    }
    
    NSLog(@"Adding after %d items,order=%.2f",[_allItems count],order);
    
    BNRItem *p=[NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:context];
    [p setOrderingValue:order];
    
    [_allItems addObject:p];
    return p;
}

-(void)removeItem:(BNRItem *)p
{
    [[BNRImageStore sharedStore]deleteImageForKey:p.imageKey];
    [context deleteObject:p];
    [_allItems removeObjectIdenticalTo:p];
}

-(void)moveItemAtIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if(from==to){
        return;
    }
    
    BNRItem *p=[_allItems objectAtIndex:from];
    [_allItems removeObjectAtIndex:from];
    [_allItems insertObject:p atIndex:to];
    
    double lowerBound=0.0;
    if(to>0){
        lowerBound =[[_allItems objectAtIndex:to-1]orderingValue];
    }else{
        lowerBound=[[_allItems objectAtIndex:1]orderingValue]-2.0;
    }
    
    double upperBound=0.0;
    if(to<[_allItems count]-1){
        upperBound=[[_allItems objectAtIndex:to+1]orderingValue];
    }else{
        upperBound=[[_allItems objectAtIndex:to-1]orderingValue]+2.0;
    }
    
    double newOrderValue=(lowerBound+upperBound)/2.0;
    
    NSLog(@"moving to order %f",newOrderValue);
    [p setOrderingValue:newOrderValue];
}

-(NSString *)itemArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

-(BOOL)saveChanges
{
    NSError *error=nil;
    BOOL successful=[context save:&error];
    if(!successful){
        NSLog(@"Error saving:%@",[error localizedDescription]);
    }
    
    return successful;
}

-(void)loadAllItems
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    
    NSEntityDescription *e=[[model entitiesByName]objectForKey:@"BNRItem"];
    [request setEntity:e];
    
    NSSortDescriptor *sd=[NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
//    NSPredicate *p=[NSPredicate predicateWithFormat:@"valueInDollars>0"];
//    [request setPredicate:p];
    
    NSError *error=nil;
    NSArray *result=[context executeFetchRequest:request error:&error];
    
    if(!result){
        [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
    }
    
    _allItems=[[NSMutableArray alloc]initWithArray:result];
}

-(NSArray *)allAssetTypes
{
    if(!allAssetTypes){
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *e=[[model entitiesByName]objectForKey:@"BNRAssetType"];
        [request setEntity:e];
        
        NSError *error=nil;
        NSArray *result=[context executeFetchRequest:request error:&error];
        
        if(!result){
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
        }
        
        allAssetTypes=[result mutableCopy];
    }
    
    if([allAssetTypes count]==0){
        NSArray *labelArray=[NSArray arrayWithObjects:@"Furniture",@"Jewelry",@"Electronics", nil];
        NSManagedObject *type;
        
        for(NSString *element in labelArray){
            type=[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
            [type setValue:element forKey:@"label"];
            [allAssetTypes addObject:type];
        }
    }

    return allAssetTypes;
}

@end
