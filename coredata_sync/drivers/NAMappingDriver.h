//
//  NAMappingDriver.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARestDriverProtocol.h"

typedef enum NAMappingDriverMergeOption: NSUInteger{
//    サーバ側のデータで上書きしてしまう
    NAMappingDriverMergeOptionServerPriority,
//    ローカルのデータを優先する．（何もしない）
    NAMappingDriverMergeOptionLocalPriority,
//    自動マージを試みる（サーバ側を適用した上に、ローカルの変更を乗っける）
    NAMappingDriverMergeOptionAutoMerge,
//    どちらを優先するかをユーザに選択させる
    NAMappingDriverMergeOptionAlert,
} NAMappingDriverMergeOption;


@interface NAMappingDriver : NSObject

@property (strong, nonatomic) Class syncModel;
@property (strong, nonatomic) NSString *endpoint;
@property (strong, nonatomic) NSString *modelName;
@property (readonly, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *callbackName;
//@property (strong, nonatomic) NSString *primaryKey;
@property (strong, nonatomic) NSMutableDictionary *jsonKeys;
@property (strong, nonatomic) NSMutableDictionary *queryKeys;
@property (strong, nonatomic) NSMutableDictionary *uniqueKeys;
@property (strong, nonatomic) id<NARestDriverProtocol> restDriver;

@property (readonly, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (readonly, nonatomic) NSManagedObjectContext *mainContext;

- (NSDictionary *)mo2query:(NSManagedObject *)mo;
- (NSDictionary *)json2dictionary:(NSDictionary *)json;
- (NSDictionary *)json2uniqueDictionary:(NSDictionary *)json;

- (id)data2syncVersion:(id)data;
- (BOOL)mappingByRestType:(NARestType)restType data:(id)data inContext:(NSManagedObjectContext *)context options:(NSDictionary *)options network_identifier:(NSString *)network_identifier network_cache_identifier:(NSString *)network_cache_identifier;

@end
