//
//  NAModelController.h
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NAFetchHelper.h"

@interface NAModelController : NSObject

@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

//初期化
- (void)setup:(NSString *)name;

//マイグレーション
//- (void)migrate:(NSString *)newpath newversion:(NSInteger)newversion;

@end
