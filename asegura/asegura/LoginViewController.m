//
//  LoginViewController.m
//  asegura
//
//  Created by Angel  Solsona on 27/01/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TerminaEditar:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [_fondo setUserInteractionEnabled:YES];
    [_fondo addGestureRecognizer:tap];
    
}

-(void)viewWillAppear:(BOOL)animated{
    _datosAlm=[NSUserDefaults standardUserDefaults];
    BOOL esLogin=[[_datosAlm objectForKey:@"login"] boolValue];
    if (esLogin) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(CerrarLogin) userInfo:nil repeats:NO];
    }
    
    _registraFacebook=NO;
}

-(void)CerrarLogin{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigator=[segue destinationViewController];
    RegistroViewController *registro=[[navigator viewControllers] objectAtIndex:0];
    registro.registroFacebook=_registraFacebook;
    
}


-(void)TerminaEditar:(UIGestureRecognizer *)recognizer{
    
    [self.view endEditing:YES];
    [_vistaScroll setContentOffset:CGPointMake(0, 0)animated:YES];
}

- (IBAction)RecuperarPassword:(id)sender {
    [self.view endEditing:YES];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Recuperar Contraseña" message:@"Introduce tu correo electrónico" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Aceptar", nil];
    [alert setTag:100];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    alert=nil;
}

- (IBAction)Entrar:(id)sender {
    [self.view endEditing:YES];

    if (![_usuario.text isEqualToString:@""]&&![_pass isEqual:@""]) {
        _HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [_HUD setMode:MBProgressHUDModeIndeterminate];
        [_HUD setLabelText:@"Enviando Datos"];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
        NSDictionary *dic=@{@"nickName":_usuario.text,
                            @"password":_pass.text,
                            };
        
        NSConnection *conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/login/" parameters:dic idRequest:1 delegate:self];
        [conexion connectionGETExecute];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes llenar todos los campos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
    
}

- (IBAction)EntrarRegistro:(id)sender {
    
    /*_datosAlm=[NSUserDefaults standardUserDefaults];
    [_datosAlm setBool:YES forKey:@"login"];
    [_datosAlm synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];*/
    [self performSegueWithIdentifier:@"registro_segue" sender:self];
}

-(IBAction)LoginFacebook:(id)sender{
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        _registraFacebook=YES;
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             [self performSegueWithIdentifier:@"registro_segue" sender:self];
         }];
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect rc=[textField bounds];
    rc=[textField convertRect:rc toView:_vistaScroll];
    CGPoint pt=rc.origin;
    pt.x=0;
    pt.y-=60;
    [_vistaScroll setContentOffset:pt animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return NO;
}

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"dic %@",[dic description]);
    switch (numRequest) {
        case 1:
        {
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                Usuario *usuario=[NSEntityDescription insertNewObjectForEntityForName:@"Usuario" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
                usuario.nombre=[dic objectForKey:@"userName"];
                usuario.apellidoPaterno=[dic objectForKey:@"userLastName"];
                usuario.telefono=[dic objectForKey:@"noTelefono"];
                usuario.correo=_usuario.text;
                usuario.pass=_pass.text;
                if([NSCoreDataManager SaveData]){
                    _datosAlm=[NSUserDefaults standardUserDefaults];
                    [_datosAlm setBool:YES forKey:@"login"];
                    [_datosAlm synchronize];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"El usuario o la contraseña son incorrectos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                
                /*_datosAlm=[NSUserDefaults standardUserDefaults];
                [_datosAlm setBool:YES forKey:@"login"];
                [_datosAlm synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];*/
                
            }
        }break;
        case 2:{
            
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Envío Exitoso" message:@"El correo fue enviado existosamente por favor revísalo para poder recuperar tu contraseña" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"El usuario no existe" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                
                /*_datosAlm=[NSUserDefaults standardUserDefaults];
                 [_datosAlm setBool:YES forKey:@"login"];
                 [_datosAlm synchronize];
                 [self dismissViewControllerAnimated:YES completion:nil];*/
                
            }
            
            
        }
            
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    [_HUD hide:YES];
    NSLog(@"error%@",[error description]);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexión intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark - UIAlertView Delegate 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==100) {
        _HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [_HUD setMode:MBProgressHUDModeIndeterminate];
        [_HUD setLabelText:@"Enviando Correo"];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"Cancelar");
            }break;
            case 1:
            {
                NSString *email=[alertView textFieldAtIndex:0].text;
                NSConnection *conexion=[[NSConnection alloc] initWithRequestURL:@"http://grupo.lmsmexico.com.mx/wsmovil/api/poliza/retrievePassword/" parameters:@{@"nickName":email} idRequest:2 delegate:self];
                [conexion connectionPOSTExecute];
                conexion=nil;
            }
                
            default:
                break;
        }
    }
    
}



@end
