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
    if (_ramoActual==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Búsqueda de Póliza" message:@"Introduce el número de póliza y el número de serie" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Enviar", nil];
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        [[alert textFieldAtIndex:0] setPlaceholder:@"Número de póliza"];
        [[alert textFieldAtIndex:1] setPlaceholder:@"Número de serie"];
        [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
        [[alert textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
        [[alert textFieldAtIndex:1] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
        [[alert textFieldAtIndex:0] setDelegate:self];
        [[alert textFieldAtIndex:1] setDelegate:self];
        [[alert textFieldAtIndex:1] setTag:2];
        [alert setTag:1];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Búsqueda de Póliza" message:@"Introduce el número de póliza" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Enviar", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setPlaceholder:@"Número de póliza"];
        [[alert textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
        [alert setTag:1];
        [alert show];
    }
    
    
    /*if (_ramoActual==1) {
        [self performSegueWithIdentifier:@"altaPolizaAuto_segue" sender:self];
        
    }else{
        [self performSegueWithIdentifier:@"altaPolizaNormal_segue" sender:self];
    }*/
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detalle_segue"]) {
        DetallePolizaViewController *DVC=[segue destinationViewController];
        [DVC setPolizaActual:_polizaActual];
        [DVC setEsBusquedaNueva:YES];
    }
    if ([segue.identifier isEqualToString:@"altaPolizaNormal_segue"]||[segue.identifier isEqualToString:@"altaPolizaAuto_segue"]) {
        
        AltaPolizaViewController *APVC=[segue destinationViewController];
        [APVC setIdRamoActual:_ramoActual];
        [APVC setPolizaActual:_polizaActual];
        [APVC setEsEdicion:NO];

    }
    if ([segue.identifier isEqualToString:@"lector_segue"]) {
        
        LectorQRViewController *LVC=[segue destinationViewController];
        [LVC setDelegate:self];
    }
    
}


-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];

            NSLog(@"Dic %@",[dic description]);
            
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                _polizaActual=[[Poliza alloc] init];
                _polizaActual.insurenceNumber=[dic objectForKey:@"insuranceNumber"];
                _polizaActual.ownerName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ownerName"]];
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
                _polizaActual.idPolizaSistema=[[dic objectForKey:@"IdPolizaM"] integerValue];
                _polizaActual.idSistema=[[dic objectForKey:@"iSistema"] integerValue];
                _polizaActual.contratadoCon=[dic objectForKey:@"ContratadoCon"];
                _polizaActual.telefonoCabina=[dic objectForKey:@"TelefonoCabina"];
                _polizaActual.reportarSiniestro=[[dic objectForKey:@"ReportaSiniestro"] boolValue];
                _polizaActual.insurenceAlias=[dic objectForKey:@"insuranceAlias"];
                _polizaActual.ramo=_ramoActual;
                
                [self performSegueWithIdentifier:@"detalle_segue" sender:self];
                
                
            }else if([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0008"]){
                
                /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"La póliza que deseas registrar no es administrada en lorantmms.\n ¿Deseas agregarla?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
                [alert setTag:2];
                [alert show];*/
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:[NSString stringWithFormat:@"Los datos de la póliza son correctos?.\n Número de Póliza:%@ \n Número de Serie:%@",_polizaActual.insurenceNumber,_polizaActual.numeroSerie] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
                [alert setTag:2];
                [alert show];
            
            
            }else if([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0007"]){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"La póliza ya esta registrada" delegate:nil cancelButtonTitle:@"No" otherButtonTitles: nil];
                [alert show];
                
            }else if([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0010"]){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Favor de Validar el No. de Serie" delegate:nil cancelButtonTitle:@"No" otherButtonTitles: nil];
                [alert show];
                
            }

            
            
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    [_HUD hide:YES];
    NSLog(@"error %@",error);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexión intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark UIAlert Delegate 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex) {
                NSString *noPoliza;
                NSString *noSerie;
                if (_ramoActual==1) {
                    
                    noPoliza=[[alertView textFieldAtIndex:0] text];
                    noSerie=[[alertView textFieldAtIndex:1] text];
                }else{
                    noPoliza=[[alertView textFieldAtIndex:0] text];
                    noSerie=@"";
                }
                
                if ([noPoliza isEqualToString:@""]||[noPoliza isEqualToString:@""]) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes llenar los datos de la póliza" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                    [alert show];
                }else{
                
                    _polizaActual=[[Poliza alloc] init];
                    _polizaActual.insurenceNumber=noPoliza;
                    _polizaActual.ramo=_ramoActual;
                    _polizaActual.numeroSerie=noSerie;
                    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/searchInsurance" parameters:@{@"insuranceNumber":_polizaActual.insurenceNumber,@"_iIdRamo":[NSString stringWithFormat:@"%ld",(long)_polizaActual.ramo],@"serialNumberSuffix":_polizaActual.numeroSerie} idRequest:1 delegate:self];
                    [_conexion connectionPOSTExecute];
                    
                    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
                    [_HUD setMode:MBProgressHUDModeIndeterminate];
                    [_HUD setLabelText:@"Buscando Póliza ..."];
                    [self.view addSubview:_HUD];
                    [_HUD show:YES];
                }
                
            }
        }break;
        case 2:
        {
            if (buttonIndex) {
                
                if (_ramoActual==1) {
                 [self performSegueWithIdentifier:@"altaPolizaAuto_segue" sender:self];
                 
                 }else{
                 [self performSegueWithIdentifier:@"altaPolizaNormal_segue" sender:self];
                 }
                
            }
        }
            
        default:
            break;
    }
}

#pragma mark -Lector Delegate

-(void)ResultadoLector:(NSString *)noPoliza idRamo:(NSString *)idRamo{
    
    
    _polizaActual=[[Poliza alloc] init];
    _polizaActual.insurenceNumber=noPoliza;
    _polizaActual.ramo=[idRamo integerValue];
    [self performSelector:@selector(BuscaPoliza) withObject:nil afterDelay:0.5];
    
}

-(void)BuscaPoliza{
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/searchInsurance" parameters:@{@"insuranceNumber":_polizaActual.insurenceNumber,@"_iIdRamo":[NSString stringWithFormat:@"%ld",(long)_polizaActual.ramo]} idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Buscando Póliza ..."];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"Escribiendo");
    BOOL retorno=YES;
    switch (textField.tag) {
        case 2:
        {
            // numero de serie
            int limit=16;
            retorno=!([textField.text length]>limit && [string length]>range.length);
        }break;
    }
    
    return retorno;
}




@end
