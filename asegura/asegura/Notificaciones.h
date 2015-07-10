//
//  Notificaciones.h
//  asegura
//
//  Created by Angel  Solsona on 10/07/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notificaciones : NSManagedObject

@property (nonatomic, retain) NSString * noPoliza;
@property (nonatomic, retain) NSString * fechaInicio;
@property (nonatomic, retain) NSString * fechaFin;
@property (nonatomic, retain) NSString * tipo;
@property (nonatomic, retain) NSString * mensaje;

@end
