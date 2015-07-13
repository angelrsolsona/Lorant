//
//  ObjNotificacion.h
//  asegura
//
//  Created by Angel  Solsona on 28/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notificaciones.h"
@interface ObjNotificacion : NSObject

@property(strong,nonatomic)NSString *tituloNotificacion;
@property(strong,nonatomic)Notificaciones *notificacion;
@property(strong,nonatomic)NSDate *fechaNotificacion;

@end
