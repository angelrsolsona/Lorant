//
//  HistorialSinisetroTableViewController.h
//  asegura
//
//  Created by Angel  Solsona on 15/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistorialSiniestroTableViewCell.h"
#import "NSConnection.h"
#import "Usuario.h"
#import "NSCoreDataManager.h"
#import "MBProgressHUD.h"
#import "HistorialSiniestro.h"
#import "VistaCalificacion.h"
@interface HistorialSinisetroTableViewController : UITableViewController <NSConnectionDelegate>


@property(strong,nonatomic)NSMutableArray *arraySiniestros;
@property(strong,nonatomic)NSConnection *conexion;
@property(strong,nonatomic)Usuario *usuarioActual;
@property(strong,nonatomic)MBProgressHUD *HUD;
@property(strong,nonatomic)VistaCalificacion *infoView;


@end
