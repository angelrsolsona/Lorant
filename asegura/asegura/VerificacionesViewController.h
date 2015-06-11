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

@interface VerificacionesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSConnectionDelegate>

@property(strong,nonatomic) IBOutlet UITableView *tabla;
@property(strong,nonatomic) NSConnection *conexion;
@property(strong,nonatomic) MBProgressHUD *HUD;

@end
