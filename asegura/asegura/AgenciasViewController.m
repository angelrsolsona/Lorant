//
//  AgenciasViewController.m
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "AgenciasViewController.h"

@interface AgenciasViewController ()

@end

@implementation AgenciasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];

    _didLoctionFind=NO;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SeleccionaMarca)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [_selectorAgencia addGestureRecognizer:tap];
    
    _location=[[CLLocationManager alloc] init];
    [_location setDelegate:self];
    [_location setDesiredAccuracy:kCLLocationAccuracyBest];
    NSString * osVersion = [[UIDevice currentDevice] systemVersion];
    if ([osVersion floatValue]>= 8.0 ) {
        [_location requestAlwaysAuthorization]; //Requests permission to use location services whenever the app is running.
        // [_CLLocationManager requestWhenInUseAuthorization]; //Requests permission to use location services while the app is in the foreground.
    }
    [_location startUpdatingLocation];

    
    /*GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:19.003453 longitude:-99.7765673 zoom:14];
    _vistaMapa.myLocationEnabled = YES;
    [_vistaMapa setCamera:camera];*/
    
    _arrayMarcas=[[NSMutableArray alloc] initWithObjects:@"Seleccione una Marca", nil];
    _tagPicker=1;
    [self ObtenMarcas];
    [self ObtenEstados];
    [_btnLlamar setEnabled:NO];
    [self RedondeaBoton:_btnLlamar conBorde:NO];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [_vistaScroll setContentSize:CGSizeMake(320,680)];
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
    
    return NO;
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
    _providerPickerView.tag=_tagPicker;
    
    [self.view addSubview:_providerPickerView];
}

- (void)dismissActionSheet:(id)sender{
    
    switch (_tagPicker) {
        case 100:
        {
             [_agencia setTitle:[_arrayMarcas objectAtIndex:[_providerPickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
            _idMarcaActual=[_providerPickerView selectedRowInComponent:0]-1;
            [self BuscaAgencias];
        }break;
        case 200:
        {
            _idEstado=[_providerPickerView selectedRowInComponent:0]+1;
            [self BuscaAgencias];
        }break;
            
        default:
        {
            
        }break;
    }

   
    [_maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (pickerView.tag) {
        case 100:
        {
            return [_arrayMarcas count];
        }break;
        case 200:
        {
            return [_arrayEstados count];
        }break;
            
        default:
        {
            return 1;
        }break;
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    switch (pickerView.tag) {
        case 100:
        {
            return [_arrayMarcas objectAtIndex:row];
        }break;
        case 200:
        {
            return [_arrayEstados objectAtIndex:row];
        }break;
            
        default:
        {
            return @"Vacio";
        }break;
    }

}

#pragma mark - Delegate CLLocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *ubicacionActual=[locations lastObject];
    _cordenadaActual=CLLocationCoordinate2DMake(ubicacionActual.coordinate.latitude, ubicacionActual.coordinate.longitude);
    NSString *latitud=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.latitude];
    NSString *longitud=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.longitude];
    if (!_didLoctionFind) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:ubicacionActual.coordinate.latitude longitude:ubicacionActual.coordinate.longitude zoom:10];
        [_vistaMapa setCamera:camera];
        _didLoctionFind=YES;
    }
    _vistaMapa.myLocationEnabled = YES;
    [_vistaMapa setDelegate:self];
}

#pragma mark - NSConnection Delegate

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
   
    switch (numRequest) {
        case 1:
        {
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            for (NSDictionary *dic in array) {
                [_arrayMarcas addObject:[dic objectForKey:@"MARCA"]];
            }
        }break;
        case 2:{
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Valor de array agencias %@",[array description]);
            if ([array count]>0) {
                _arrayAgencias=[[NSMutableSet alloc] init];
                for (NSDictionary *dic in array) {
                    NSArray *arrayCordenada=[[dic objectForKey:@"COORDENADA"] componentsSeparatedByString:@","];
                    NSString *latitud=[arrayCordenada objectAtIndex:0];
                    NSString *longitud=[arrayCordenada objectAtIndex:1];
                    
                    AgenciasMarkerAnotation *marker=[[AgenciasMarkerAnotation alloc] init];
                    [marker setPosition:CLLocationCoordinate2DMake([latitud floatValue], [longitud floatValue])];
                    [marker setTitle:[dic objectForKey:@"AGENCIA"]];
                    [marker setSnippet:[dic objectForKey:@"DOMICILIO"]];
                    [marker setMarkerID:[dic objectForKey:@"COORDENADA"]];
                    [marker setNombreAgencia:[dic objectForKey:@"AGENCIA"]];
                    [marker setTelefono:[dic objectForKey:@"TELEFONO"]];
                    [marker setCorreo:[dic objectForKey:@"CORREO"]];
                    [marker setCorreo1:[dic objectForKey:@"CORREO1"]];
                    [marker setDistancia:[dic objectForKey:@"DISTANCIA"]];
                    [marker setDomicilio:[dic objectForKey:@"DOMICILIO"]];
                    [marker setCp:[dic objectForKey:@"CP"]];
                    
                    [_arrayAgencias addObject:marker];
                }
                [self DibujaMarkers:_arrayAgencias];
                
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se encontraron agencias" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
            }
            /*if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Envio Exitoso" message:@"El correo fue enviado existosamente por favor revisalo para poder recuperar tu contraseña" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"El usuario no existe" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                

                
            }*/
            
            
        }
            
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexion intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark - Obtenciones

-(void)ObtenMarcas{
    _tagPicker=100;
    _conexion=[[NSConnection alloc] initWithRequestURL:@"http://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getMarcas" parameters:nil idRequest:1 delegate:self];
    [_conexion connectionGETExecute];
    _conexion=nil;
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Marcas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    
}

-(void)ObtenEstados{
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Estados" ofType:@"plist"]];
    _arrayEstados=[[NSMutableArray alloc] initWithArray:[dic objectForKey:@"Estados"]];
}

-(IBAction)SeleccionSegmental:(id)sender{
    
    UISegmentedControl *segmental=(UISegmentedControl *)sender;
    
    if (segmental.selectedSegmentIndex==0) {
        [self BuscaAgencias];
        
    }else if(segmental.selectedSegmentIndex==1){
        _tagPicker=200;
        [self CreatePicker:nil];
    }
    
}

#pragma mark - Dibuja Mapa

-(void)DibujaMarkers:(NSMutableSet *)array{
    
    [_vistaMapa clear];
    for (GMSMarker *marker in array) {
        if (marker.map==nil) {
            [marker setMap:_vistaMapa];
        }
    }
}

#pragma mark - Busqueda Agencia

-(void)SeleccionaMarca{
    _tagPicker=100;
    [self CreatePicker:nil];
}

-(void)BuscaAgencias{
    if (_segmentalControl.selectedSegmentIndex==0) {
        NSString *cordenadas=[NSString stringWithFormat:@"%f,%f",_cordenadaActual.latitude,_cordenadaActual.longitude];
        _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getAgencias" parameters:@{@"Coordenada":cordenadas,@"IDMarca":[NSString stringWithFormat:@"%ld",(long)_idMarcaActual],@"IdTipoBusqueda":@"0"} idRequest:2 delegate:self];
        [_conexion connectionGETExecute];
    }else if (_segmentalControl.selectedSegmentIndex==1){
        
        _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getAgencias" parameters:@{@"Estado":[NSString stringWithFormat:@"%ld",(long)_idEstado],@"IDMarca":[NSString stringWithFormat:@"%d",_idMarcaActual],@"IdTipoBusqueda":@"1"} idRequest:2 delegate:self];
        [_conexion connectionGETExecute];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir tu modo de busqueda" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - Delegate Google Maps

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(AgenciasMarkerAnotation *)marker{
    
    
    [_nombreAgencia setText:marker.nombreAgencia];
    [_direccionAgencia setText:marker.domicilio];
    //[_telefonos setText:[NSString stringWithFormat:@"Teléfono:%@\nCorreo:%@",marker.telefono,marker.correo]];
    //_telefonosLink.dataDetectorTypes=UIDataDetectorTypeNone;
    [_telefonosLink setText:[NSString stringWithFormat:@"Teléfono: %@\nCorreo: %@",marker.telefono,marker.correo]];
    [NSThread sleepForTimeInterval:0.1];
    //_telefonosLink.dataDetectorTypes=UIDataDetectorTypeAddress;
    
    _markerActual=marker;
    [_btnLlamar setEnabled:YES];
    return NO;
}

-(IBAction)Llamar:(id)sender{
    
    NSString *telefono=[NSString stringWithFormat:@"tel://%@",_markerActual.telefono];
    NSURL *url=[NSURL URLWithString:telefono];
    [[UIApplication sharedApplication] openURL:url];
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


@end
