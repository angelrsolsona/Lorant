//
//  RegistroViewController.h
//  asegura
//
//  Created by Angel  Solsona on 19/02/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Usuario.h"
#import "NSCoreDataManager.h"
#import "NSConnection.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
@interface RegistroViewController : UIViewController <UITextFieldDelegate,NSConnectionDelegate>

@property(weak,nonatomic)IBOutlet UITextField *nombre;
@property(weak,nonatomic)IBOutlet UITextField *apellidoPaterno;
@property(weak,nonatomic)IBOutlet UITextField *apellidoMaterno;
@property(weak,nonatomic)IBOutlet UITextField *correo;
@property(weak,nonatomic)IBOutlet UITextField *telefono;
@property(weak,nonatomic)IBOutlet UITextField *pass;
@property(weak,nonatomic)IBOutlet UITextField *verificarPass;
@property(weak,nonatomic)IBOutlet UIScrollView *vistaScroll;

@property(strong,nonatomic)NSUserDefaults *datosAlm;
@property(strong,nonatomic)MBProgressHUD *HUD;
@property(strong,nonatomic)Usuario *usuarioFacebook;
@property(assign,nonatomic)BOOL
registroFacebook;

@end
