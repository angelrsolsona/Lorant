//
//  ReporteViewController.m
//  asegura
//
//  Created by Angel  Solsona on 27/01/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "ReporteViewController.h"

@interface ReporteViewController ()


@end

@implementation ReporteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    /*UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createPickerView:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];*/
    [self RedondeaBoton:_alias conBorde:YES];
    [self RedondeaBoton:_btnCausas conBorde:YES];
    [self RedondeaBoton:_btnEnviarUbicacion conBorde:NO];
    [self RedondeaBoton:_btnFoto conBorde:YES];
    [self RedondeaBoton:_btnCompartir conBorde:YES];
    _pickerActivo=NO;
    _tienesNotas=NO;
    _tienePoliza=NO;
    _tieneCausas=NO;
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    _usuarioActual=[array objectAtIndex:0];
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS/" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Pólizas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    _polizaActual=[[Poliza alloc] init];
    _causaActual=[[CausaSiniestro alloc] init];
    [_telefono setText:_usuarioActual.telefono];
    [self BuscarLocalizacion];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [_vistaScroll setContentSize:CGSizeMake(320,780)];
    //[_containerView setFrame:CGRectMake(0, 100, 320, 228)];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"notas_segue"]) {
        NotasReporteViewController *NVC=[segue destinationViewController];
        [NVC setDelegate:self];
        if (_tienesNotas) {
            [NVC setNota:_notas.text];
            [NVC setTienesNotas:_tienesNotas];
        }else{
            [NVC setTienesNotas:_tienesNotas];
        }
    }
}


#pragma mark - Muestra Menu
- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)CreatePicker:(id)sender{
    _pickerActivo=YES;
    UIButton *button=(UIButton *)sender;
    
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
    [_providerPickerView setTag:(button.tag*10)];
    [self.view addSubview:_providerPickerView];
}

- (void)dismissActionSheet:(id)sender{
    _pickerActivo=NO;
    [_maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    UIButton *button=(UIButton*)[self.view viewWithTag:(_providerPickerView.tag/10)];
    switch (_providerPickerView.tag) {
        case 10:
        {
            _polizaActual=[_arrayPolizas objectAtIndex:[_providerPickerView selectedRowInComponent:0]];
            [button setTitle:_polizaActual.insuranceName forState:UIControlStateNormal];
            [self DetallePoliza];
            [self ObtenTipoSiniestro:[NSString stringWithFormat:@"%d",_polizaActual.idAseguradora]];
        }break;
        case 30:
        {
            _causaActual=[_arrayCausas objectAtIndex:[_providerPickerView selectedRowInComponent:0]];
            [button setTitle:[NSString stringWithFormat:@"%@",_causaActual.nombre] forState:UIControlStateNormal];
            _tieneCausas=YES;
        }break;
        default:
            break;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 10:
        {
            return [_arrayPolizas count];
        }break;
        case 30:
        {
            return [_arrayCausas count];
        }
            
        default:
            return 1;
            break;
    }
    //return 1;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (pickerView.tag) {
        case 10:
        {
            Poliza *poliza=[_arrayPolizas objectAtIndex:row];
            return poliza.insuranceName;
            //return @"Poliza 1";
        }break;
        case 30:
        {
            CausaSiniestro *causa=[_arrayCausas objectAtIndex:row];
            return causa.nombre;
        }
            
        default:
            return @"Texto";
            break;
    }
    
    //return @"Picker";
}


#pragma mark - Delegate CLLocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (!_didFindLocation) {
        _didFindLocation=YES;
        CLLocation *ubicacionActual=[locations lastObject];
        
        NSString *latitud=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.latitude];
        NSString *longitud=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.longitude];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:ubicacionActual.coordinate.latitude longitude:ubicacionActual.coordinate.longitude zoom:14];
        _vistaMapa.myLocationEnabled = YES;
        [_vistaMapa setCamera:camera];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([latitud floatValue],[longitud floatValue]);
        marker.title = [NSString stringWithFormat:@"Mi Ubicación:(%.3f,%.3f)",[latitud floatValue],[longitud floatValue]];
        //marker.snippet = @"Australia";
        marker.map = _vistaMapa;
        
        
        
        NSLog(@"Ubicacion:(%f %f)",ubicacionActual.coordinate.latitude,ubicacionActual.coordinate.longitude);
        _latitudActual=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.latitude];
        _longitudActual=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.longitude];

        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(ubicacionActual.coordinate.latitude, ubicacionActual.coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            
            NSLog(@"reverse geocoding results:");
            GMSAddress *addressObj=[response firstResult];
            
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            NSString *direccion=@"";
            for (NSString *cadena in addressObj.lines) {
                direccion=[direccion stringByAppendingString:[NSString stringWithFormat:@"%@, ",cadena]];
            }
            //[_ubicacionActual setText:[NSString stringWithFormat:@"%@ %@,%@",addressObj.thoroughfare,addressObj.subLocality,addressObj.administrativeArea]];
            [_ubicacionActual setText:direccion];
            
        }];
    
    /*CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:ubicacionActual completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error!=nil){
        CLPlacemark *place=[placemarks objectAtIndex:0];
        NSLog(@"Found placemarks: %@, error: %@", placemarks, [placemarks description]);
        [_ubicacionActual setText:[NSString stringWithFormat:@"%@ %@, %@",place.thoroughfare,place.subThoroughfare,place.locality]];
            
        }else{
            [_ubicacionActual setPlaceholder:@"Escribe tu ubicacion"];
            
        }
        
    }];*/
    }else{
    
        [_location stopUpdatingLocation];
    }

    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleRoundedRect];
    if (textField.tag==2) {
        if (_pickerActivo) {
            [self dismissActionSheet:nil];
        }
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"notas_segue" sender:nil];
    }else{
        
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
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleNone];
    if (textField.tag==1) {
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField.layer setCornerRadius:0.0f];
        [textField.layer setMasksToBounds:NO];
    }
   
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL retorno=YES;
    if (!_pickerActivo) {
        
        switch (textField.tag) {
            case 1:
            case 2:
            case 3:
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


-(IBAction)Compartir:(id)sender{
    NSString *textToShare = @"Acabo de tener un accidente";
    //NSURL *myWebsite = [NSURL URLWithString:@""];
    UIImage *imagen;
    NSArray *objectsToShare;
    if (_imagenSiniestro==nil) {
        objectsToShare= @[textToShare];
    }else{
        imagen=_imagenSiniestro;
        objectsToShare= @[textToShare,imagen];
       
    }
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
#pragma mark NSConnection Delegate
-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            _arrayPolizas=[[NSMutableArray alloc] init];
            BOOL hayError=NO;
            for (NSDictionary *dic in array) {
                if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0005"]) {
                    hayError=YES;
                    break;
                }else{
                    Poliza *poliza=[[Poliza alloc] init];
                    poliza.insuranceName=[dic objectForKey:@"insuranceName"];
                    poliza.insurenceNumber=[dic objectForKey:@"insuranceNumber"];
                    poliza.idAseguradora=[[dic objectForKey:@"idAseguradora"] integerValue];
                    poliza.idPolizaM=[[dic objectForKey:@"IdPolizaM"] integerValue];
                    poliza.ramo=[[dic objectForKey:@"idRamo"] integerValue];
                    NSArray *fecha=[[dic objectForKey:@"FechaHasta"] componentsSeparatedByString:@"T"];
                    poliza.fechaHasta=[fecha objectAtIndex:0];
                    poliza.numeroSerie=[dic objectForKey:@"NoSerie"];
                    [_arrayPolizas addObject:poliza];
                }
                
            }
            
            if (hayError) {
                
                [_HUD setMode:MBProgressHUDModeText];
                [_HUD setLabelText:@"El usuario no tiene pólizas"];
                [self.view addSubview:_HUD];
                [_HUD show:YES];
                [_HUD hide:YES afterDelay:2.0];
            }else{
                UIButton *button=(UIButton*)[self.view viewWithTag:1];
                [button setTitle:@"Escoje una póliza" forState:UIControlStateNormal];
            }
        }break;
        case 2:{
            
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            _arrayCausas=[[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                
                CausaSiniestro *causa=[[CausaSiniestro alloc] init];
                causa.idRamo=[NSString stringWithFormat:@"%d",_polizaActual.ramo];
                causa.idTipo=[dic objectForKey:@"ID_TIPO_SINIESTRO"];
                causa.nombre=[dic objectForKey:@"SINIESTRO"];
                
                [_arrayCausas addObject:causa];
            }
            //[_HUD hide:YES];
            UIButton *button=(UIButton*)[self.view viewWithTag:3];
            [button setTitle:@"Escoje una causa" forState:UIControlStateNormal];
            
            
        }break;
        case 3:{
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            BOOL hayError=NO;
            NSLog(@"respuesta %@",[dic description]);
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                
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
                _polizaActual.insurenceAlias=[dic objectForKey:@"insuranceAlias"];
                
                NSArray *array=[NSCoreDataManager getDataWithEntity:@"Polizas" predicate:[NSString stringWithFormat:@"noPoliza==\"%@\"",_polizaActual.insurenceNumber] andManagedObjContext:[NSCoreDataManager getManagedContext]];
                if ([array count]>0) {
                    Polizas *polizas=[array objectAtIndex:0];
                    _polizaActual.instrumentoPago=polizas.intrumentoPago;
                    _polizaActual.banco=polizas.banco;
                    _polizaActual.diaPago=polizas.diaPago;
                    _polizaActual.observacion=polizas.observaciones;
                    _polizaActual.recordatorioPagoInicio=polizas.recordatorioInicio;
                    _polizaActual.recordatorioPagoFin=polizas.recordatorioFin;
                    _polizaActual.recordatorioPago=[polizas.recordadDiaPago boolValue];
                    _polizaActual.foto=polizas.foto;
                    _polizaActual.tieneMasInformacion=YES;
                }
                [_HUD setHidden:YES];
                _tienePoliza=YES;
            }

        }break;
        case 4:{
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                [_HUD hide:YES];
                NSString *telefono=[NSString stringWithFormat:@"tel://%@",_polizaActual.telefonoCabina];
                NSURL *url=[NSURL URLWithString:telefono];
                [[UIApplication sharedApplication] openURL:url];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No se puede eliminar la póliza inténtalo de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
            }
            
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    [_HUD hide:YES];
    NSLog(@"%@",error);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexión intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark Notas Delegate

-(void)NotasAgregada:(NSString *)nota{
    
    _tienesNotas=YES;
    [_notas setText:nota];
}

#pragma mark Metodos

-(void)ObtenTipoSiniestro:(NSString *)idAseguradora{
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/geTtipoSiniestro/" parameters:@{@"idAseguradora":idAseguradora} idRequest:2 delegate:self];
    [_conexion connectionPOSTExecute];
    /*_HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Causas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];*/

}

-(void)BuscarLocalizacion{
    _didFindLocation=NO;
    _location=[[CLLocationManager alloc] init];
    [_location setDelegate:self];
    [_location setDesiredAccuracy:kCLLocationAccuracyBest];
    NSString * osVersion = [[UIDevice currentDevice] systemVersion];
    if ([osVersion floatValue]>= 8.0 ) {
        [_location requestAlwaysAuthorization]; //Requests permission to use location services whenever the app is running.
        // [_CLLocationManager requestWhenInUseAuthorization]; //Requests permission to use location services while the app is in the foreground.
    }
    [_location startUpdatingLocation];
}

-(void)DetallePoliza{
    
    NSString *noPoliza=@"";
    NSString *noSerie=@"";
    if (_polizaActual.ramo==1) {
        noPoliza=_polizaActual.insurenceNumber;
        noSerie=_polizaActual.numeroSerie;
    }else{
        noPoliza=_polizaActual.insurenceNumber;
        noSerie=@"";
    }
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceDetailWS" parameters:@{@"insuranceNumber":noPoliza,@"serialNumberSuffix":noSerie} idRequest:3 delegate:self];
    [_conexion connectionPOSTExecute];

    
   /* _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceDetailWS" parameters:@{@"insuranceNumber":_polizaActual.insurenceNumber} idRequest:3 delegate:self];
    [_conexion connectionPOSTExecute]; */
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo información"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];

    
}

-(void)RedondeaBoton:(UIButton *)boton conBorde:(BOOL)conBorde{
    
    //[boton setBackgroundColor:[UIColor whiteColor]];
    [boton.layer setCornerRadius:6.0f];
    [boton.layer setMasksToBounds:YES];
    if (conBorde) {
        UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        boton.layer.borderColor=borderColor.CGColor;
        boton.layer.borderWidth=1.0;
    }
    
}

#pragma mark - Acciones Botones

- (IBAction)Foto:(id)sender {
    
}

- (IBAction)EnviarUbicacion:(id)sender {
    
    if (_tieneCausas&&_tienePoliza) {
        
        NSDictionary *parametros=@{@"IdPolizaM":[NSString stringWithFormat:@"%d",_polizaActual.idPolizaM],
                                   @"idSiniestro":_causaActual.idTipo,
                                   @"latitude":_latitudActual,
                                   @"longitud":_longitudActual,
                                   @"nickName":_usuarioActual.correo,
                                   @"numeroTel":_usuarioActual.telefono,
                                   @"informacion":[NSString stringWithFormat:@"%@",_notas.text]};
        
        _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/ms_RegistroSiniestro" parameters:parametros idRequest:4 delegate:self];
        [_conexion connectionPOSTExecute];
        
        _HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [_HUD setMode:MBProgressHUDModeIndeterminate];
        [_HUD setLabelText:@"Enviando ubicación"];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
    }else{
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una póliza y una causa" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];

    }
}

- (IBAction)Llamar:(id)sender {
}

- (IBAction)ActivaPicker:(id)sender {
    
    UIButton *boton=(UIButton *)sender;
    if (!_pickerActivo) {

        switch (boton.tag) {
            case 1:{
                if ([_arrayPolizas count]>0) {
                    [self CreatePicker:sender];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No tienes pólizas dadas de alta" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                    [alert show];
                }
            }break;
                
            case 3:{
                if ([_arrayCausas count]>0) {
                    [self CreatePicker:sender];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Esta póliza no tiene causas asignadas" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                    [alert show];
                }
            }break;
                
            default:
                break;
        }
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - Fotografia
-(IBAction)SeleccinaFoto{

        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Seleccionar Imagen" message:@"¿De dónde quieres obtener la foto?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Cámara",@"Galería de Fotos ", nil];
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
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Este dispositivo no tiene cámara" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
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
    _imagenSiniestro=imagen;
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImageWriteToSavedPhotosAlbum(_imagenSiniestro, nil, nil, nil);
    
    
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


@end
