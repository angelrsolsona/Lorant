//
//  Eventos.h
//  asegura
//
//  Created by Angel  Solsona on 28/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Eventos : NSManagedObject

@property (nonatomic, retain) NSString * idEvento;
@property (nonatomic, retain) NSString * noPoliza;
@property (nonatomic, retain) NSString * tipo;

@end
