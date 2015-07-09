//
//  RegistroViewController.m
//  asegura
//
//  Created by Angel  Solsona on 19/02/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "RegistroViewController.h"
#define REGEX_BASICO @"^.{1,20}$"
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
@interface RegistroViewController ()

@end

@implementation RegistroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self InicializaTextField];

}

-(void)viewWillAppear:(BOOL)animated{
    //[_nombre becomeFirstResponder];
    if (_registroFacebook) {
        
        if (FBSession.activeSession.isOpen) {
            
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    
                    NSDictionary<FBGraphUser> *user=result;
                    NSLog(@"user:%@",[user description]);
                    [_nombre setText:[user objectForKey:@"first_name"]];
                    [_apellidoPaterno setText:[user objectForKey:@"last_name"]];
                    [_correo setText:[user objectForKey:@"email"]];

                    
                    
                }
            }];
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UItextfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleRoundedRect];
    
    if (textField.tag==5) {
        
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"                                                                     style:UIBarButtonItemStyleBordered target:self                                                                     action:@selector(cierraTeclado)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
    
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField.layer setCornerRadius:6.0f];
    [textField.layer setMasksToBounds:YES];
    CGRect rc=[textField bounds];
    rc=[textField convertRect:rc toView:_vistaScroll];
    CGPoint pt=rc.origin;
    pt.x=0;
    pt.y-=60;
    [_vistaScroll setContentOffset:pt animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField.layer setCornerRadius:0.0f];
    [textField.layer setMasksToBounds:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField.layer setCornerRadius:0.0f];
    [textField.layer setMasksToBounds:NO];
    [textField resignFirstResponder];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL retorno=YES;
    
    if (textField.tag==5) {
        int limit=9;
        retorno=!([textField.text length]>limit && [string length]>range.length);
    }
    
    return retorno;
    
}
#pragma mark - Acciones Botones

-(IBAction)Cancelar:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)Guardar:(id)sender{
    [self.view endEditing:YES];
    
    //if ([_nombre.text isEqualToString:@""]||[_apellidoPaterno.text isEqualToString:@""]||[_apellidoMaterno.text isEqualToString:@""]||[_correo.text isEqualToString:@""]||[_telefono.text isEqualToString:@""]||[_pass.text isEqualToString:@""]||[_verificarPass.text isEqualToString:@""]) {
    if (![_nombre validate]||![_apellidoPaterno validate]||![_apellidoMaterno validate]||![_correo validate]||![_telefono validate]||![_pass validate]||![_verificarPass validate]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes llenar todos los campos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
    }else{
        if (![_pass.text isEqualToString:_verificarPass.text]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Las contraseñas no coinciden por favor rectificalas" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
            
        }else{
            NSDictionary *dic=@{@"name":_nombre.text,
                                @"apaterno":_apellidoPaterno.text,
                                @"amaterno":_apellidoMaterno.text,
                                @"email":_correo.text,
                                @"tel":_telefono.text,
                                @"password":_pass.text,
                                };
            
            //NSString *url=[NSString stringWithFormat:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/addUsuario/?name=%@&apaterno=%@&amaterno=%@&email=%@&tel=%@&password=%@",_nombre.text,_apellidoPaterno.text,_apellidoMaterno.text,_correo.text,_telefono.text,_pass.text];
            
            NSConnection *conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/addUsuario/" parameters:dic idRequest:1 delegate:self];
            [conexion connectionGETExecute];
            
            _HUD=[[MBProgressHUD alloc] initWithView:self.view];
            [_HUD setMode:MBProgressHUDModeIndeterminate];
            [_HUD setLabelText:@"Enviando Datos"];
            [self.view addSubview:_HUD];
            [_HUD show:YES];
            
        }
    }
}

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"dic %@",[dic description]);
    switch (numRequest) {
        case 1:
        {
            if (![[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0002"]) {
                
                Usuario *usuario=[NSEntityDescription insertNewObjectForEntityForName:@"Usuario" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
                usuario.idUsuario=[dic objectForKey:@"userId"];
                usuario.nombre=_nombre.text;
                usuario.apellidoPaterno=_apellidoPaterno.text;
                usuario.apellidoMaterno=_apellidoMaterno.text;
                usuario.telefono=_telefono.text;
                usuario.correo=_correo.text;
                usuario.pass=_pass.text;
                BOOL exito=[NSCoreDataManager SaveData];
                if (exito) {
                    _datosAlm=[NSUserDefaults standardUserDefaults];
                    [_datosAlm setBool:YES forKey:@"login"];
                    [_datosAlm synchronize];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"El correo electrónico ya existe " delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                
            }
        }
            break;
            
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexión intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark - Metodos

-(void)cierraTeclado{
    
    [self.view endEditing:YES];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)InicializaTextField{
    //[_nombre addRegx:REGEX_BASICO withMsg:@"Este campo debe terner"];
    [_nombre setPresentInView:self.view];
    //[_apellidoPaterno addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    [_apellidoPaterno setPresentInView:self.view];
    //[_apellidoMaterno addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    [_apellidoMaterno setPresentInView:self.view];
    [_correo addRegx:REGEX_EMAIL withMsg:@"Introduce un correo valido."];
    [_correo setPresentInView:self.view];
    //[_telefono addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    [_telefono setPresentInView:self.view];
    ///[_pass addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    [_pass setPresentInView:self.view];
    //[_verificarPass addRegx:REGEX_PASSWORD withMsg:@"Enter valid email."];
    [_verificarPass setPresentInView:self.view];

    
}


@end
