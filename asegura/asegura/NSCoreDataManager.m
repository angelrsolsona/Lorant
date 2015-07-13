//
//  NSCoreDataManager.m
//  carreraatletica
//
//  Created by Angel Ricardo Solsona Nevero on 16/05/14.
//  Copyright (c) 2014 Angel Ricardo Solsona Nevero. All rights reserved.
//

#import "NSCoreDataManager.h"

@implementation NSCoreDataManager


-(id)init{
    if (self=[super init]) {
        
        _appdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managerObject=[_appdelegate managedObjectContext];
    }
    return self;
}
-(void)SaveEntity{
    
    
}

-(NSArray *)getDataWithEntity:(NSString *)nameEntity predicate:(NSString *)predicatestr{
    
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:nameEntity inManagedObjectContext:_managerObject];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicatestr];
    [request setPredicate:predicate];
    [request setEntity:entity];
    [request setReturnsDistinctResults:YES];
    NSError *error=nil;
    NSArray *array=[_managerObject executeFetchRequest:request error:&error];
    /*NSSortDescriptor *sortdescriptor=[[NSSortDescriptor alloc] initWithKey:@"id_ruta" ascending:YES];
     NSArray *descriptor=[NSArray arrayWithObject:sortdescriptor];
     array=[array sortedArrayUsingDescriptors:descriptor];*/
    return array;
    
    
}



////////////////////////////////////////////////////////////

+(NSManagedObjectContext *)getManagedContext{
    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managerObject=[appdelegate managedObjectContext];
    return managerObject;
}

+(BOOL)SaveData{
    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managerObject=[appdelegate managedObjectContext];
    NSError *error;
    BOOL estatus =[managerObject save:&error];
    return estatus;
}

+(NSArray *)getDataWithEntity:(NSString *)nameEntity andManagedObjContext:(NSManagedObjectContext*)context{
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:nameEntity inManagedObjectContext:context];
    //NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id_ruta = %@"]
    [request setEntity:entity];
    NSError *error=nil;
    NSArray *array=[context executeFetchRequest:request error:&error];
    return array;
    
}
+(NSArray *)getDataWithEntity:(NSString *)nameEntity andManagedObjContext:(NSManagedObjectContext*)context orderWithKey:(NSString *)key{
    
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:nameEntity inManagedObjectContext:context];
    //NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id_ruta = %@"]
    [request setEntity:entity];
    NSError *error=nil;
    NSArray *array=[context executeFetchRequest:request error:&error];
    NSSortDescriptor *sortdescriptor=[[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *descriptor=[NSArray arrayWithObject:sortdescriptor];
    array=[array sortedArrayUsingDescriptors:descriptor];
    return array;
    
}
+(NSArray *)getDataWithEntity:(NSString *)nameEntity predicate:(NSString *)predicatestr andManagedObjContext:(NSManagedObjectContext*)context{
    
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:nameEntity inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicatestr];
    [request setPredicate:predicate];
    [request setEntity:entity];
    [request setReturnsDistinctResults:YES];
    NSError *error=nil;
    NSArray *array=[context executeFetchRequest:request error:&error];
    /*NSSortDescriptor *sortdescriptor=[[NSSortDescriptor alloc] initWithKey:@"id_ruta" ascending:YES];
    NSArray *descriptor=[NSArray arrayWithObject:sortdescriptor];
    array=[array sortedArrayUsingDescriptors:descriptor];*/
    return array;

    
}
+(id)getEspecificDataWithEntity:(NSString *)nameEntity predicate:(NSString *)predicatestr andManagedObjContext:(NSManagedObjectContext*)context{
    
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:nameEntity inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicatestr];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSError *error=nil;
    NSArray *array=[context executeFetchRequest:request error:&error];
    /*NSSortDescriptor *sortdescriptor=[[NSSortDescriptor alloc] initWithKey:@"id_ruta" ascending:YES];
     NSArray *descriptor=[NSArray arrayWithObject:sortdescriptor];
     array=[array sortedArrayUsingDescriptors:descriptor];*/
    id object;
    if ([array count]<1) {
        object=nil;
    }else{
        object=[array objectAtIndex:0];
    }
    return object;
    
}


@end
