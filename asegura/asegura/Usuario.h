//
//  Usuario.h
//  asegura
//
//  Created by Angel  Solsona on 07/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * apellidoMaterno;
@property (nonatomic, retain) NSString * apellidoPaterno;
@property (nonatomic, retain) NSString * correo;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * pass;
@property (nonatomic, retain) NSString * telefono;
@property (nonatomic, retain) NSString * idUsuario;

@end
