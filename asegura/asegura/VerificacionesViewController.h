//
//  VerificacionesViewController.h
//  asegura
//
//  Created by Angel  Solsona on 10/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "VerificacionTableViewCell.h"
#import "NSConnection.h"
#import "MBProgressHUD.h"
#import "Poliza.h"
#import "Usuario.h"
#import "NSCoreDataManager.h"
#import "VerificacionFechas.h"
#import "ARSNManagerCalendar.h"
#import "Eventos.h"
#import "Notificaciones.h"

@interface VerificacionesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSConnectionDelegate>

@property(weak,nonatomic) IBOutlet UITableView *tabla;
@property(weak,nonatomic) IBOutlet UISwitch *recordarVerificacion;
@property(strong,nonatomic) NSConnection *conexion;
@property(strong,nonatomic) MBProgressHUD *HUD;
@property(strong,nonatomic) NSMutableArray *arrayVerificacion;
@property(strong,nonatomic) NSMutableArray *arrayNotificaciones;
@property(strong,nonatomic)Usuario *usuarioActual;
@property(strong,nonatomic)NSCoreDataManager *coreDataManager;
@end
