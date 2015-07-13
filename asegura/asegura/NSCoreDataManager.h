//
//  NSCoreDataManager.h
//  carreraatletica
//
//  Created by Angel Ricardo Solsona Nevero on 16/05/14.
//  Copyright (c) 2014 Angel Ricardo Solsona Nevero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface NSCoreDataManager : NSObject

@property(strong,nonatomic) AppDelegate *appdelegate;
@property(strong,nonatomic) NSManagedObjectContext *managerObject;

-(id)init;
-(void)SaveEntity;
-(NSArray *)getDataWithEntity:(NSString *)nameEntity predicate:(NSString *)predicatestr;
/////////////////////////////////////////

+(NSManagedObjectContext *)getManagedContext;
+(BOOL)SaveData;
+(NSArray *)getDataWithEntity:(NSString *)nameEntity andManagedObjContext:(NSManagedObjectContext*)context;
+(NSArray *)getDataWithEntity:(NSString *)nameEntity andManagedObjContext:(NSManagedObjectContext*)context orderWithKey:(NSString *)key;
+(NSArray *)getDataWithEntity:(NSString *)nameEntity predicate:(NSString *)predicate andManagedObjContext:(NSManagedObjectContext*)context;
+(id)getEspecificDataWithEntity:(NSString *)nameEntity predicate:(NSString *)predicatestr andManagedObjContext:(NSManagedObjectContext*)context;

@end
