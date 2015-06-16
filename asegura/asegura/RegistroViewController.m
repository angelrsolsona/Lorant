//
//  RegistroViewController.m
//  asegura
//
//  Created by Angel  Solsona on 19/02/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "RegistroViewController.h"

@interface RegistroViewController ()

@end

@implementation RegistroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleRoundedRect];
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

-(IBAction)Cancelar:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)Guardar:(id)sender{
    [self.view endEditing:YES];
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
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexion intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}


@end