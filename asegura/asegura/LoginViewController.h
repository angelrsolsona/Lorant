//
//  LoginViewController.h
//  asegura
//
//  Created by Angel  Solsona on 27/01/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NSConnection.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "Usuario.h"
#import "RegistroViewController.h"
@interface LoginViewController : UIViewController <UITextFieldDelegate,NSConnectionDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *vistaScroll;
@property (weak, nonatomic) IBOutlet UITextField *usuario;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UIImageView *fondo;

@property(strong,nonatomic) NSUserDefaults *datosAlm;
@property(strong,nonatomic) MBProgressHUD *HUD;
@property(strong,nonatomic) Usuario *usuarioFacebook;
@property(assign,nonatomic) BOOL registraFacebook;


- (IBAction)RecuperarPassword:(id)sender;
- (IBAction)Entrar:(id)sender;
- (IBAction)EntrarRegistro:(id)sender;

@end
