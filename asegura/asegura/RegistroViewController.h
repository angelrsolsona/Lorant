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
#import "TextFieldValidator.h"
@interface RegistroViewController : UIViewController <UITextFieldDelegate,NSConnectionDelegate>

@property(weak,nonatomic)IBOutlet TextFieldValidator *nombre;
@property(weak,nonatomic)IBOutlet TextFieldValidator *apellidoPaterno;
@property(weak,nonatomic)IBOutlet TextFieldValidator *apellidoMaterno;
@property(weak,nonatomic)IBOutlet TextFieldValidator *correo;
@property(weak,nonatomic)IBOutlet TextFieldValidator *telefono;
@property(weak,nonatomic)IBOutlet TextFieldValidator *pass;
@property(weak,nonatomic)IBOutlet TextFieldValidator *verificarPass;
@property(weak,nonatomic)IBOutlet UIScrollView *vistaScroll;

@property(strong,nonatomic)NSUserDefaults *datosAlm;
@property(strong,nonatomic)MBProgressHUD *HUD;
@property(strong,nonatomic)Usuario *usuarioFacebook;
@property(assign,nonatomic)BOOL
registroFacebook;

@end
