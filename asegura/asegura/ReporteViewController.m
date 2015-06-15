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
    
    _pickerActivo=NO;
    
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    _usuarioActual=[array objectAtIndex:0];
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS/" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Polizas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    _polizaActual=[[Poliza alloc] init];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    _location=[[CLLocationManager alloc] init];
    [_location setDelegate:self];
    [_location setDesiredAccuracy:kCLLocationAccuracyBest];
    NSString * osVersion = [[UIDevice currentDevice] systemVersion];
    if ([osVersion floatValue]>= 8.0 ) {
        [_location requestAlwaysAuthorization]; //Requests permission to use location services whenever the app is running.
        // [_CLLocationManager requestWhenInUseAuthorization]; //Requests permission to use location services while the app is in the foreground.
    }
    [_location startUpdatingLocation];
    
    NSString *stringPath=[[NSBundle mainBundle] pathForResource:@"causasSiniestro" ofType:@"plist"];
    NSDictionary *dic=[[NSDictionary alloc] initWithContentsOfFile:stringPath];
    _arrayCausas=[[NSMutableArray alloc] init];
    _arrayCausas=[[dic objectForKey:@"Auto"] objectForKey:@"Causa"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

-(IBAction)CreatePicker:(id)sender{
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
        }break;
        case 30:
        {
            [button setTitle:[NSString stringWithFormat:@"%@",[_arrayCausas objectAtIndex:[_providerPickerView selectedRowInComponent:0]]] forState:UIControlStateNormal];
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
            return [_arrayCausas objectAtIndex:row];
        }
            
        default:
            return @"Texto";
            break;
    }
    
    //return @"Picker";
}


#pragma mark - Delegate CLLocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *ubicacionActual=[locations lastObject];
    
    NSString *latitud=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.latitude];
    NSString *longitud=[NSString stringWithFormat:@"%f",ubicacionActual.coordinate.longitude];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:ubicacionActual.coordinate.latitude longitude:ubicacionActual.coordinate.longitude
                                                                 zoom:14];
    _vistaMapa.myLocationEnabled = YES;
    [_vistaMapa setCamera:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([latitud floatValue],[longitud floatValue]);
    marker.title = [NSString stringWithFormat:@"Mi Ubicacion:(%.3f,%.3f)",[latitud floatValue],[longitud floatValue]];
    //marker.snippet = @"Australia";
    marker.map = _vistaMapa;
    
    
    
    NSLog(@"Ubicacion:(%f %f)",ubicacionActual.coordinate.latitude,ubicacionActual.coordinate.longitude);
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:ubicacionActual completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error!=nil){
        CLPlacemark *place=[placemarks objectAtIndex:0];
        NSLog(@"Found placemarks: %@, error: %@", placemarks, [placemarks description]);
        [_ubicacionActual setText:[NSString stringWithFormat:@"%@ %@, %@",place.thoroughfare,place.subThoroughfare,place.locality]];
            
        }else{
            [_ubicacionActual setPlaceholder:@"Escribe tu ubicacion"];
            
        }
        
    }];
    
    [_location stopUpdatingLocation];
    

    
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

-(IBAction)Compartir:(id)sender{
    NSString *textToShare = @"Acabo de tener un accidente";
    //NSURL *myWebsite = [NSURL URLWithString:@""];
    
    NSArray *objectsToShare = @[textToShare];
    
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
                    poliza.ramo=[[dic objectForKey:@"idRamo"] integerValue];
                    NSArray *fecha=[[dic objectForKey:@"FechaHasta"] componentsSeparatedByString:@"T"];
                    poliza.fechaHasta=[fecha objectAtIndex:0];
                    [_arrayPolizas addObject:poliza];
                }
                
            }
            
            if (hayError) {
                
                [_HUD setMode:MBProgressHUDModeText];
                [_HUD setLabelText:@"El usuario no tiene polizas"];
                [self.view addSubview:_HUD];
                [_HUD show:YES];
                [_HUD hide:YES afterDelay:2.0];
            }else{
                UIButton *button=(UIButton*)[self.view viewWithTag:1];
                [button setTitle:@"Escoje una póliza" forState:UIControlStateNormal];
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



@end
