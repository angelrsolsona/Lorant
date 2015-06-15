//
//  AltaPolizaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "AltaPolizaViewController.h"

@interface AltaPolizaViewController ()

@end

@implementation AltaPolizaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_numeroPoliza setText:_polizaActual.insurenceNumber];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews
{
    [_vistaScroll setContentSize:CGSizeMake(320,1230)];
    //[_containerView setFrame:CGRectMake(0, 100, 320, 228)];
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
    
    if(textField.tag==3){
        
        [textField resignFirstResponder];
        [self CreatePicker:nil];
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
/*-(void)textFieldDidEndEditing:(UITextField *)textField{
 //[textField setBorderStyle:UITextBorderStyleNone];
 [textField setBackgroundColor:[UIColor clearColor]];
 [textField.layer setCornerRadius:0.0f];
 [textField.layer setMasksToBounds:NO];
 }
 
 }*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField resignFirstResponder];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    /*NSInteger idTag;
    NSString *mensajeError;
    if (_idRamoActual==1) {
        idTag=2;
        mensajeError=@"Debes llenar los campos de numero de poliza y numero de serie";
    }else{
        idTag=1;
        mensajeError=@"Debes llenar los campos de numero de poliza";
    }
    
    if (textField.tag==idTag) {
        if (![_numeroPoliza.text isEqualToString:@""]&&![_numeroSerie.text isEqualToString:@""]) {
            [self BuscaPoliza:_numeroPoliza.text numeroSerie:_numeroSerie.text Ramo:_idRamoActual];
        }else{
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:mensajeError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
        }
    }*/
    
    return NO;
}

-(IBAction)GuardarContinuar:(id)sender{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[MisPolizasViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark Picker Aseguradora

-(void)CreatePicker:(id)sender{
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,(self.view.bounds.size.height/2)-20, self.view.bounds.size.width, (self.view.bounds.size.height/2)+20)];
    [_maskView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    
    [self.view addSubview:_maskView];
    _providerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 264, self.view.bounds.size.width, 44)];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheet:)];
    _providerToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], done];
    _providerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:_providerToolbar];
    
    _providerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 220, 0, 0)];
    _providerPickerView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    _providerPickerView.showsSelectionIndicator = YES;
    _providerPickerView.dataSource = self;
    _providerPickerView.delegate = self;
    [self.view addSubview:_providerPickerView];
}

- (void)dismissActionSheet:(id)sender{
    [_maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 1;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return @"Picker";
}

# pragma mark - Metodos

-(void)BuscaPoliza:(NSString *)numPoliza numeroSerie:(NSString *)numeroSerie Ramo:(NSInteger)idRamo{
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Buscando datos de póliza"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    NSDictionary *parametros;
    if (idRamo==1) {
        
        parametros=@{@"insuranceNumber":numPoliza,@"serialNumberSuffix":numeroSerie};
    }else{
        parametros=@{@"insuranceNumber":numPoliza};
    }
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceDetailWS" parameters:parametros idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    
}

#pragma mark - NSConnection Delegate

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"dic %@",[dic description]);
    switch (numRequest) {
        case 1:
        {
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
             
                _polizaActual.insurenceNumber=[dic objectForKey:@"insuranceNumber"];
                _polizaActual.ownerName=[dic objectForKey:@"ownerName"];
                _polizaActual.startDate=[dic objectForKey:@"startDate"];
                _polizaActual.endDate=[dic objectForKey:@"endDate"];
                _polizaActual.contactMail=[dic objectForKey:@"contactMail"];
                _polizaActual.contactPhoneNumber=[dic objectForKey:@"contactPhoneNumber"];
                _polizaActual.nombreAseguradora=[dic objectForKey:@"Aseguradora"];
                _polizaActual.numeroSerie=[[[dic objectForKey:@"productDetail"] objectAtIndex:0] objectForKey:@"valor"];
                _polizaActual.noPlacas=[[[dic objectForKey:@"productDetail"] objectAtIndex:1] objectForKey:@"valor"];
                _polizaActual.descripcion=[[[dic objectForKey:@"productDetail"] objectAtIndex:2] objectForKey:@"valor"];
                _polizaActual.coberturas=[[NSMutableArray alloc] init];
                _polizaActual.coberturas=[dic objectForKey:@"coberturasDetail"];
                _polizaActual.idAseguradora=[[dic objectForKey:@"idAseguradora"] integerValue];
                _polizaActual.formaPago=[dic objectForKey:@"FormaPago"];
                _polizaActual.paquete=[dic objectForKey:@"Paquete"];
                _polizaActual.idPoliza=[[dic objectForKey:@"iPoliza"] integerValue];
                _polizaActual.idSistema=[[dic objectForKey:@"iSistema"] integerValue];
                _polizaActual.contratadoCon=[dic objectForKey:@"ContratadoCon"];
                _polizaActual.telefonoCabina=[dic objectForKey:@"TelefonoCabina"];
                _polizaActual.reportarSiniestro=[[dic objectForKey:@"ReportaSiniestro"] boolValue];
                
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Ocurrio un error" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                
                /*_datosAlm=[NSUserDefaults standardUserDefaults];
                 [_datosAlm setBool:YES forKey:@"login"];
                 [_datosAlm synchronize];
                 [self dismissViewControllerAnimated:YES completion:nil];*/
                
            }
        }break;
            
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexion intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

-(void)MuestraInformacionPoliza:(NSDictionary *)dic{
    
    _polizaActual.insurenceNumber=[dic objectForKey:@"insuranceNumber"];
    _polizaActual.ownerName=[dic objectForKey:@"ownerName"];
    _polizaActual.startDate=[dic objectForKey:@"startDate"];
    _polizaActual.endDate=[dic objectForKey:@"endDate"];
    _polizaActual.contactMail=[dic objectForKey:@"contactMail"];
    _polizaActual.contactPhoneNumber=[dic objectForKey:@"contactPhoneNumber"];
    _polizaActual.nombreAseguradora=[dic objectForKey:@"Aseguradora"];
    _polizaActual.numeroSerie=[[[dic objectForKey:@"productDetail"] objectAtIndex:0] objectForKey:@"valor"];
    _polizaActual.noPlacas=[[[dic objectForKey:@"productDetail"] objectAtIndex:1] objectForKey:@"valor"];
    _polizaActual.descripcion=[[[dic objectForKey:@"productDetail"] objectAtIndex:2] objectForKey:@"valor"];
    _polizaActual.coberturas=[[NSMutableArray alloc] init];
    _polizaActual.coberturas=[dic objectForKey:@"coberturasDetail"];
    _polizaActual.idAseguradora=[[dic objectForKey:@"idAseguradora"] integerValue];
    _polizaActual.formaPago=[dic objectForKey:@"FormaPago"];
    _polizaActual.paquete=[dic objectForKey:@"Paquete"];
    _polizaActual.idPoliza=[[dic objectForKey:@"iPoliza"] integerValue];
    _polizaActual.idSistema=[[dic objectForKey:@"iSistema"] integerValue];
    _polizaActual.contratadoCon=[dic objectForKey:@"ContratadoCon"];
    _polizaActual.telefonoCabina=[dic objectForKey:@"TelefonoCabina"];
    _polizaActual.reportarSiniestro=[[dic objectForKey:@"ReportaSiniestro"] boolValue];
    
    [_numeroPoliza setText:_polizaActual.insurenceNumber];
    //[]
}


@end
