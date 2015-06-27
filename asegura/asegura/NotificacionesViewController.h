//
//  NotificacionesViewController.h
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "NotificacionesTableViewCell.h"

#import "NSConnection.h"
#import "Usuario.h"
#import "NSCoreDataManager.h"
#import "MBProgressHUD.h"
#import "Poliza.h"
#import "VerificacionFechas.h"


@interface NotificacionesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSConnectionDelegate>

@property(strong,nonatomic)IBOutlet UITableView *tabla;
@property(strong,nonatomic)NSConnection *conexion;
@property(strong,nonatomic)Usuario *usuarioActual;
@property(strong,nonatomic) MBProgressHUD *HUD;
@property(strong,nonatomic) NSMutableArray *arrayPolizas;
@end
