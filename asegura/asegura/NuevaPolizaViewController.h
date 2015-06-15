//
//  NuevaPolizaViewController.h
//  asegura
//
//  Created by Angel  Solsona on 23/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AltaPolizaViewController.h"
#import "NSConnection.h"
#import "Poliza.h"
@interface NuevaPolizaViewController : UIViewController <UIAlertViewDelegate,NSConnectionDelegate>

@property(weak,nonatomic) IBOutlet UIView *viewPreview;
@property(assign,nonatomic) NSInteger ramoActual;

@property (strong,nonatomic) NSConnection *conexion;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong,nonatomic) Poliza *polizaActual;

@end
