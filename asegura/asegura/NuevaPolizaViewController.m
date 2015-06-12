//
//  NuevaPolizaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 23/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "NuevaPolizaViewController.h"

@interface NuevaPolizaViewController ()

@end

@implementation NuevaPolizaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SeleccionaRamo:(id)sender{
    
    UIButton *boton=(UIButton *)sender;
    _ramoActual=boton.tag;
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"Introduce el numero de poliza" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Enviar", nil];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alert setTag:1];
    [alert show];
    
    
    if (_ramoActual==1) {
        [self performSegueWithIdentifier:@"altaPolizaAuto_segue" sender:self];
        
    }else{
        [self performSegueWithIdentifier:@"altaPolizaNormal_segue" sender:self];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AltaPolizaViewController *APVC=[segue destinationViewController];
    [APVC setIdRamoActual:_ramoActual];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex) {
                NSString *noPoliza=[[alertView textFieldAtIndex:0] text];
                
            }
        }break;
        case 2:
        {
            if (!buttonIndex) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            
        default:
            break;
    }
}

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            BOOL hayError=NO;
            
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0007"]) {
                
                _polizaActual.insurenceNumber=[dic objectForKey:@"insuranceNumber"];
                _polizaActual.ownerName=[dic objectForKey:@"ownerName"];
                _polizaActual.startDate=[dic objectForKey:@"startDate"];
                _polizaActual.endDate=[dic objectForKey:@"endDate"];
                _polizaActual.contactMail=[dic objectForKey:@"contactMail"];
                _polizaActual.contactPhoneNumber=[dic objectForKey:@"contactPhoneNumber"];
                _polizaActual.nombreAseguradora=[dic objectForKey:@"Aseguradora"];
                _polizaActual.productDetail=[[NSMutableArray alloc] init];
                _polizaActual.productDetail=[dic objectForKey:@"productDetail"];
                _polizaActual.coberturas=[[NSMutableArray alloc] init];
                _polizaActual.coberturas=[dic objectForKey:@"coberturasDetail"];
                _polizaActual.idAseguradora=[[dic objectForKey:@"idAseguradora"] integerValue];
                _polizaActual.formaPago=[dic objectForKey:@"FormaPago"];
                _polizaActual.paquete=[dic objectForKey:@"Paquete"];
                _polizaActual.idPolizaSistema=[[dic objectForKey:@"idPolizaSistema"] integerValue];
                _polizaActual.idSistema=[[dic objectForKey:@"iSistema"] integerValue];
                _polizaActual.contratadoCon=[dic objectForKey:@"ContratadoCon"];
                _polizaActual.telefonoCabina=[dic objectForKey:@"TelefonoCabina"];
                _polizaActual.reportarSiniestro=[[dic objectForKey:@"ReportaSiniestro"] boolValue];
                
                
                
            }else if([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0008"]){
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"La poliza no existe.\n ¿Deseas agregarla?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
                [alert show];
            
            
            }
            
            
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    NSLog(@"error %@",error);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexion intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}




@end
