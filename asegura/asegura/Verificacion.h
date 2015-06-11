//
//  Verificacion.h
//  asegura
//
//  Created by Angel  Solsona on 06/04/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Verificacion : NSManagedObject

@property (nonatomic, retain) NSString * alias;
@property (nonatomic, retain) NSString * placas;
@property (nonatomic, retain) NSString * calcomania;
@property (nonatomic, retain) NSString * periodoUno;
@property (nonatomic, retain) NSString * periodoDos;

@end
