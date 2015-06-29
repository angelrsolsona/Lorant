//
//  AltaPolizaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "AltaPolizaViewController.h"


#define REGEX_BASICO @"^.{1,20}$"
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface AltaPolizaViewController ()

@end

@implementation AltaPolizaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    _usuarioActual=[array objectAtIndex:0];

    [_numeroPoliza setText:_polizaActual.insurenceNumber];
    if (_polizaActual.ramo==1) {
        [_numeroSerie setText:_polizaActual.numeroSerie];
    }
    [self ObtenAseguradoras];
    [self InicializaTextField];
    
    
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"masInformacion_segue"]) {
        MasInformacionPolizaViewController *MIVC=[segue destinationViewController];
        [MIVC setPolizaActual:_polizaActual];
        [MIVC setEsVistaDetalle:NO];
        [MIVC setDelegate:self];
    }

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL retorno=YES;
    if (!_estaActivoPicker&&!_estaActivoPickerDate) {
        
        switch (textField.tag) {
            case 3:
            case 10:
            case 11:
            {
                [self.view endEditing:YES];
                retorno=YES;
            }break;
            default:
                break;
        }
        
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        retorno=NO;
    }
    
    
    return retorno;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 3:
        {
            // Aseguradora //
            [textField resignFirstResponder];
            [self.view endEditing:YES];
            if (!_estaActivoPicker&&!_estaActivoPickerDate) {
                [self CreatePicker:textField];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
            }
        }break;
        case 4:
        {
            // numero de serie
            
        }break;
        case 6:
        {
            // placas
            
        }break;
        case 8:{
            UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
            [keyboardDoneButtonView sizeToFit];
            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"                                                                     style:UIBarButtonItemStyleBordered target:self                                                                     action:@selector(cierraTeclado)];
            [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
            textField.inputAccessoryView = keyboardDoneButtonView;
        }break;
        case 10:
        case 11:
        {
            //Fecha Vigencia
            
            [textField resignFirstResponder];
            [self.view endEditing:YES];
            
            if (!_estaActivoPickerDate&&!_estaActivoPicker) {
                [self CreateDatePicker:textField];
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
            }
        }break;
            
        default:
            break;
    }
    
    /*if(textField.tag==3){
        
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if (!_estaActivoPicker&&!_estaActivoPickerDate) {
            
                [self CreatePicker:textField];
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
        }
    }else if (textField.tag==10||textField.tag==11){
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        
        if (!_estaActivoPickerDate&&!_estaActivoPicker) {
            [self CreateDatePicker:textField];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
        }
        
    }*/
    //[textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField.layer setCornerRadius:6.0f];
    [textField.layer setMasksToBounds:YES];
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    textField.layer.borderColor=borderColor.CGColor;
    textField.layer.borderWidth=1.0;
    CGRect rc=[textField bounds];
    rc=[textField convertRect:rc toView:_vistaScroll];
    CGPoint pt=rc.origin;
    pt.x=0;
    pt.y-=60;
    [_vistaScroll setContentOffset:pt animated:YES];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField.layer setCornerRadius:0.0f];
    [textField.layer setMasksToBounds:NO];
    textField.layer.borderColor=[UIColor clearColor].CGColor;
    textField.layer.borderWidth=0.0;
 
 }

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField.layer setCornerRadius:0.0f];
    [textField.layer setMasksToBounds:NO];
    textField.layer.borderColor=[UIColor clearColor].CGColor;
    textField.layer.borderWidth=0.0;
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    BOOL retorno=YES;
    switch (textField.tag) {
        case 2:
        {
            // Alias
            int limit=19;
            retorno=!([textField.text length]>limit && [string length]>range.length);
        }break;
        case 4:
        {
            // numero de serie
            int limit=16;
            retorno=!([textField.text length]>limit && [string length]>range.length);
        }break;
        case 5:
        {
            //Descripcion
            int limit=89;
            retorno=!([textField.text length]>limit && [string length]>range.length);
        }break;
        case 6:
        {
            // placas
            int limit=9;
            retorno=!([textField.text length]>limit && [string length]>range.length);
            
        }break;
        case 7:{
            //Nombre asegurado
            int limit=89;
            retorno=!([textField.text length]>limit && [string length]>range.length);
        }break;
        case 8:{
            int limit=9;
            retorno=!([textField.text length]>limit && [string length]>range.length);
        }break;
    }

    return retorno;
}

-(IBAction)GuardarContinuar:(id)sender{
    
    BOOL camposIncorrectos;
    BOOL fechasCorrectas=[VerificacionFechas VerificaFechaesMenor:_fechaInicio.text fechaMayor:_fechaFin.text formatoFecha:@"dd/MM/yyyy"];
    if (fechasCorrectas) {
        
        if (_polizaActual.ramo==1) {
            camposIncorrectos=(![_numeroPoliza validate]||![_aliasPoliza validate]||![_numeroSerie validate]||![_descripcion validate]||![_placas validate]||![_nombreAsegurado validate]||![_telefono validate]||![_correo validate]||![_formaPago validate]||![_txtContratadoCon validate]||![_paquete validate]);
        }else{
            camposIncorrectos=(![_numeroPoliza validate]||![_aliasPoliza validate]||![_descripcion validate]||![_placas validate]||![_nombreAsegurado validate]||![_telefono validate]||![_correo validate]||![_formaPago validate]||![_txtContratadoCon validate]||![_paquete validate]);
        }
    }else{
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"El fin de vigencia no puede ser menor a la fecha de inicio" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        camposIncorrectos=YES;
    }
    
    
    if (camposIncorrectos) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes llenar todos los campos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        
    }else{
        if ([_aliasPoliza.text isEqualToString:@""]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes introducir un alias a la póliza" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
        }else{
            _HUD=[[MBProgressHUD alloc] initWithView:self.view];
            [_HUD setMode:MBProgressHUDModeIndeterminate];
            [_HUD setLabelText:@"Guardando Polizas"];
            [self.view addSubview:_HUD];
            [_HUD show:YES];
            _polizaActual.insurenceAlias=_aliasPoliza.text;
            if (_polizaActual.ramo==1) {
                _polizaActual.numeroSerie=_numeroSerie.text;
                _polizaActual.noPlacas=_placas.text;
                
            }else{
                _polizaActual.numeroSerie=@"";
                _polizaActual.noPlacas=@"";
            }
            _polizaActual.idAseguradora=[_aseguradoraActual.idAseguradora integerValue];
            _polizaActual.descripcion=_descripcion.text;
            _polizaActual.ownerName=_nombreAsegurado.text;
            _polizaActual.contactPhoneNumber=_telefono.text;
            _polizaActual.contactMail=_correo.text;
            _polizaActual.startDate=_fechaInicio.text;
            _polizaActual.endDate=_fechaFin.text;
            _polizaActual.formaPago=_formaPago.text;
            _polizaActual.contratadoCon=_txtContratadoCon.text;
            _polizaActual.paquete=_paquete.text;
            
            NSDictionary *parametros=@{@"alias":_polizaActual.insurenceAlias,
                                       @"insuranceNumber":_polizaActual.insurenceNumber,
                                       @"serialNumberSuffix":_polizaActual.numeroSerie,
                                       @"nickName":_usuarioActual.correo,
                                       @"name":_polizaActual.ownerName,
                                       @"startDate":_polizaActual.startDate,
                                       @"endDate":_polizaActual.endDate,
                                       @"contactMail":_polizaActual.contactMail,
                                       @"contactPhoneNumber":_polizaActual.contactPhoneNumber,
                                       @"productFDetail":@"",
                                       @"_iIdRamo":[NSString stringWithFormat:@"%d",_polizaActual.ramo],
                                       @"idAseguradora":[NSString stringWithFormat:@"%d",_polizaActual.idAseguradora],
                                       @"idSistema":@"1",
                                       @"idPolizaSistema":@"0",
                                       @"Placas":_polizaActual.noPlacas,
                                       @"FormaPago":_polizaActual.formaPago,
                                       @"Paquete":_polizaActual.paquete};
            
            _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/addInsurance" parameters:parametros idRequest:3 delegate:self];
            [_conexion connectionPOSTExecute];
        }
        
    }
}

#pragma mark Picker Aseguradora

-(void)CreatePicker:(id)sender{
    [self.view endEditing:YES];
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
    _estaActivoPicker=YES;
}

- (void)dismissActionSheet:(id)sender{
    [_maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    _aseguradoraActual=[_arrayAseguradoras objectAtIndex:[_providerPickerView selectedRowInComponent:0]];
    UITextField *textfield=(UITextField *)[self.view viewWithTag:3];
    [textfield setText:_aseguradoraActual.nombre];
    _estaActivoPicker=NO;
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_arrayAseguradoras count];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    Aseguradoras *aseguradora=[_arrayAseguradoras objectAtIndex:row];
    return aseguradora.nombre;
    //return @"Picker";
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
            
        case 2:{
            
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            _arrayAseguradoras=[[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                    break;
                }else{
                    Aseguradoras *aseguradora=[[Aseguradoras alloc] init];
                    aseguradora.idAseguradora=[dic objectForKey:@"ID_ASEGURADORA"];
                    aseguradora.nombre=[dic objectForKey:@"ASEGURADORA"];
                    aseguradora.idRamo=[dic objectForKey:@"ID_RAMO"];

                    
                    [_arrayAseguradoras addObject:aseguradora];
                }
            }
            [_HUD setHidden:YES];

            
        }break;
        case 3:{
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                
                if (_polizaActual.tieneMasInformacion) {
                    Polizas *polizaInformacion=[NSEntityDescription insertNewObjectForEntityForName:@"Polizas" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
                    polizaInformacion.intrumentoPago=_polizaActual.instrumentoPago;
                    polizaInformacion.banco=_polizaActual.banco;
                    polizaInformacion.diaPago=_polizaActual.diaPago;
                    polizaInformacion.observaciones=_polizaActual.observacion;
                    polizaInformacion.recordatorioInicio=_polizaActual.recordatorioPagoInicio;
                    polizaInformacion.recordatorioFin=_polizaActual.recordatorioPagoFin;
                    polizaInformacion.noPoliza=_polizaActual.insurenceNumber;
                    if (![_polizaActual.foto isEqual:nil]) {
                        polizaInformacion.foto=_polizaActual.foto;
                    }
                    if ([NSCoreDataManager SaveData]) {
                        [_HUD hide:YES];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar póliza intente de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                        [alert show];
                    }
                }else if (![_polizaActual.foto isEqual:nil]){
                    Polizas *polizaInformacion=[NSEntityDescription insertNewObjectForEntityForName:@"Polizas" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
                    polizaInformacion.foto=_polizaActual.foto;
                    if([NSCoreDataManager SaveData]){
                        [_HUD hide:YES];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar póliza intente de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                        [alert show];
                    }
                }else{
                    Polizas *polizaInformacion=[NSEntityDescription insertNewObjectForEntityForName:@"Polizas" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
                    polizaInformacion.recordarVigencia=[NSNumber numberWithBool:_recordadVigencia.on];
                    //polizaInformacion.fechaInicioVigencia=_fechaInicio.text;
                    //polizaInformacion.fechaFinVigencia=_fechaFin.text;
                    if([NSCoreDataManager SaveData]){
                        [_HUD hide:YES];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar póliza intente de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                        [alert show];
                    }

                }
                
                if (_recordadVigencia.on) {
                    
                    [self recordadVigencia];
                }
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar póliza intente de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alert show];
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
#pragma mark - Metodos;
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

-(void)ObtenAseguradoras{
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getAseguradoras" parameters:@{@"_iIdRamo":[NSString stringWithFormat:@"%d",_polizaActual.ramo]} idRequest:2 delegate:self];
    [_conexion connectionPOSTExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Aseguradoras"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];

}

-(void)cierraTeclado{
    
    [self.view endEditing:YES];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)RecuerdaVigenciaPoliza:(Poliza *)poliza{
    
    ARSNManagerCalendar *calendar=[[ARSNManagerCalendar alloc] init];
    [calendar requestAccess:^(BOOL granted, NSError *error) {
        
        [calendar getCalendar];
        
        NSMutableDictionary *informacionEvento1=[[NSMutableDictionary alloc] initWithObjectsAndKeys:poliza.insurenceNumber,@"noPoliza",@"vigencia",@"tipo", nil];
        
        BOOL eventoGuardado=[calendar addEventAt:[VerificacionFechas convierteNSStringToNSDate:poliza.endDate Formato:@"dd/MM/yyyy"] endDate:[VerificacionFechas convierteNSStringToNSDate:poliza.endDate Formato:@"dd/MM/yyyy"] withTitle:[NSString stringWithFormat:@"Fin de vigencia póliza %@",poliza.insuranceName] allDay:YES recordatorio:nil informacionEvento:informacionEvento1 withIntervalAlarm:(60*60*24*-5)];
        if (eventoGuardado) {
            
            for (NSMutableDictionary *dic in calendar.arrayEventos) {
                
                Eventos *evento=[NSEntityDescription insertNewObjectForEntityForName:@"Eventos" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
                
                evento.noPoliza=[dic objectForKey:@"noPoliza"];
                evento.tipo=[dic objectForKey:@"tipo"];
                evento.idEvento=[dic objectForKey:@"idEvento"];
                
                if([NSCoreDataManager SaveData]){
                }else{
                }
            }

        }
        
    }];
}

#pragma mark - Date Picker
-(void)CreateDatePicker:(id)sender{
    
    UITextField *button=(UITextField *)sender;
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,(self.view.bounds.size.height/2)-20, self.view.bounds.size.width, (self.view.bounds.size.height/2)+20)];
    [_maskView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    
    [self.view addSubview:_maskView];
    _providerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 264, self.view.bounds.size.width, 44)];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheetDate:)];
    _providerToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], done];
    _providerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:_providerToolbar];
    
    _pickerDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 220, 0, 0)];
    _pickerDate.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    [_pickerDate setDate:[NSDate date] animated:YES];
    [_pickerDate setTag:(button.tag*10)];
    [_pickerDate setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:_pickerDate];
    
    _estaActivoPickerDate=YES;
    
}

- (void)dismissActionSheetDate:(id)sender{
    [_maskView removeFromSuperview];
    [_pickerDate removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    if (_pickerDate.tag/10==10) {
        NSDate *selectedDate=[_pickerDate date];
        _fechaInicio.text=[formatter stringFromDate:selectedDate];
    }else if (_pickerDate.tag/10==11){
        NSDate *selectedDate=[_pickerDate date];
        _fechaFin.text=[formatter stringFromDate:selectedDate];
    }
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    _estaActivoPickerDate=NO;
    
    
}

-(void)InicializaTextField{
    [_numeroPoliza setPresentInView:self.view];
    [_aliasPoliza setPresentInView:self.view];
    [_numeroSerie setPresentInView:self.view];
    //[_numeroSerie addRegx:@"^.{17,17}$" withMsg:@"El número de serie es de 17 caracteres"];
    [_descripcion setPresentInView:self.view];
    [_placas setPresentInView:self.view];
    [_nombreAsegurado setPresentInView:self.view];
    [_telefono setPresentInView:self.view];
    [_correo setPresentInView:self.view];
    [_correo addRegx:REGEX_EMAIL withMsg:@"Introduce un correo valido"];
    [_formaPago setPresentInView:self.view];
    [_txtContratadoCon setPresentInView:self.view];
    [_paquete setPresentInView:self.view];
}

#pragma mark - Fotografia
-(IBAction)SeleccinaFoto{
   
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Seleccionar Imagen" message:@"De donde quieres obtener la foto" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Camara",@"Galeria de Fotos ", nil];
        [alert setTag:500];
        [alert show];
        alert=nil;
    
    
}
-(void)MuestraGaleria{
    
    if (_picker==nil) {
        _picker=[[UIImagePickerController alloc] init];
    }
    
    [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [_picker setDelegate:self];
    [self presentViewController:_picker animated:YES completion:nil];
    
}

-(void)MuestraCamara{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Este dispositivo no tiene camara" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }else{
        if (_picker==nil) {
            _picker=[[UIImagePickerController alloc] init];
        }
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [_picker setDelegate:self];
        [self presentViewController:_picker animated:YES completion:nil];
        _picker=nil;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *imagen=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    _polizaActual.foto=UIImagePNGRepresentation(imagen);
    
    
}

#pragma mark - Delegate UIAlert

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==500) {
        
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"Cancelar");
            }break;
            case 1:
            {
                [self MuestraCamara];
            }break;
            case 2:
            {
                [self MuestraGaleria];
            }break;
                
            default:
                break;
        }
        
    }
}

#pragma mark - Mas Informacion Delegate

-(void)GuardarInfoPoliza:(Poliza *)polizaActual{
    
    _polizaActual=polizaActual;
}




@end
