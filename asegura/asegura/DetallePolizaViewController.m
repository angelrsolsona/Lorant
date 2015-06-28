//
//  DetallePolizaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 11/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "DetallePolizaViewController.h"

@interface DetallePolizaViewController ()

@end

@implementation DetallePolizaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    _usuarioActual=[array objectAtIndex:0];
    if (_esBusquedaNueva) {
         //NSLog(@"dueño %@",_polizaActual.ownerName);
        [_lblVerFoto setHidden:YES];
        [self MuestraDatosPoliza];
    }else{
        [_lblVerFoto setHidden:NO];
        [_btnGuardar setHidden:YES];
        NSString *noPoliza=@"";
        NSString *noSerie=@"";
        if (_polizaActual.ramo==1) {
            noPoliza=_polizaActual.insurenceNumber;
            noSerie=_polizaActual.numeroSerie;
        }else{
            noPoliza=_polizaActual.insurenceNumber;
            noSerie=@"";
        }
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceDetailWS" parameters:@{@"insuranceNumber":noPoliza,@"serialNumberSuffix":noSerie} idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Polizas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    //NSLog(@"valor de vista %f",self.view.frame.size.height);
    [_vistaScroll setContentSize:CGSizeMake(320,1600)];
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
        [MIVC setEsVistaDetalle:_esVistaDetalle];
        [MIVC setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"foto_segue"]) {
        GaleriaViewController *GVC=[segue destinationViewController];
        [GVC setImagenData:_polizaActual.foto];
    }
}


#pragma mark NSConnection Delegate
-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
   [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            BOOL hayError=NO;
            
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
                
                [self MuestraDatosPoliza];
                    
            }
        }break;
        case 2:{
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
                    if([NSCoreDataManager SaveData]){
                        [_HUD hide:YES];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar póliza intente de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                        [alert show];
                    }
                    
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
    NSLog(@"error %@",error);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexion intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

-(void)MuestraDatosPoliza{
    
    [_noPoliza setText:_polizaActual.insurenceNumber];
    if ([_polizaActual.insurenceAlias isEqual:[NSNull null]]) {
        [_aliasPoliza setBorderStyle:UITextBorderStyleRoundedRect];
        [_aliasPoliza setPlaceholder:@"Introduce un alias"];
    }else{
        [_aliasPoliza setText:_polizaActual.insurenceAlias];
    }
    [_aseguradora setText:_polizaActual.nombreAseguradora];
    [_nombreAsegurado setText:_polizaActual.ownerName];
    [_telefonoTitular setText:_polizaActual.contactPhoneNumber];
    [_correoTitular setText:_polizaActual.contactMail];
    [_fechaInicio setText:_polizaActual.startDate];
    [_fechaVigencia setText:_polizaActual.endDate];
    [_formaPago setText:_polizaActual.formaPago];
    [_contratadoCon setText:[NSString stringWithFormat:@"Agente: %@",_polizaActual.contratadoCon]];
    [_paquete setText:_polizaActual.paquete];
    [_tablaCoberturas reloadData];
    [_tablaDetalle reloadData];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (tableView.tag) {
        case 1:
        {
            return [_polizaActual.productDetail count];
        }break;
            
        case 2:
        {
            if ([_polizaActual.coberturas count]>0) {
                return [_polizaActual.coberturas count];
            }else{
                return 1;
            }
        }break;
            
        default:
            
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CoberturasTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic;
    switch (tableView.tag) {
        case 1:
        {
             dic=[_polizaActual.productDetail objectAtIndex:indexPath.row];
        }break;
            
        case 2:
        {
            if ([_polizaActual.coberturas count]>0) {
                dic=[_polizaActual.coberturas objectAtIndex:indexPath.row];
            }else{
                dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"Sin información",@"label",@"",@"valor", nil];
                
            }
            
        }break;
            
        default:
            
            return 0;
            break;
    }

    [cell.descripcionCobertura setText:[dic objectForKey:@"label"]];
    [cell.valorCobertura setText:[dic objectForKey:@"valor"]];
    
    return cell;
    
    
}


- (IBAction)GuardarPoliza:(id)sender {
    
    if ([_aliasPoliza.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes introducir un alias a la póliza" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
    }else{
        _HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [_HUD setMode:MBProgressHUDModeIndeterminate];
        [_HUD setLabelText:@"Guardando Polizas"];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
        _polizaActual.numeroSerie=[self BuscarElemento:@"Número de Serie" array:_polizaActual.productDetail];
        _polizaActual.noPlacas=[self BuscarElemento:@"Placas" array:_polizaActual.productDetail];
        _polizaActual.insurenceAlias=_aliasPoliza.text;
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
                                   @"idSistema":[NSString stringWithFormat:@"%d",_polizaActual.idSistema],
                                   @"idPolizaSistema":[NSString stringWithFormat:@"%d",_polizaActual.idPolizaSistema],
                                   @"Placas":_polizaActual.noPlacas,
                                   @"FormaPago":_polizaActual.formaPago,
                                   @"Paquete":_polizaActual.paquete};
        
        _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/addInsurance" parameters:parametros idRequest:2 delegate:self];
        [_conexion connectionPOSTExecute];
    }
    
}
-(NSString *)BuscarElemento:(NSString *)string array:(NSMutableArray *)array{
    NSString *stringFind=@"";
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"label"] isEqualToString:string]) {
            stringFind=[dic objectForKey:@"valor"];
            break;
        }
    }
    
    return stringFind;
}

#pragma mark - Mas Informacion Delegate

-(void)GuardarInfoPoliza:(Poliza *)polizaActual{
    
    _polizaActual=polizaActual;
}

#pragma mark - Fotografia
-(IBAction)SeleccinaFoto{
    if (_esBusquedaNueva) {
        [_lblVerFoto setHidden:YES];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Seleccionar Imagen" message:@"De donde quieres obtener la foto" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Camara",@"Galeria de Fotos ", nil];
        [alert setTag:500];
        [alert show];
        alert=nil;
        
    }else{
        [_lblVerFoto setHidden:NO];
        if(_polizaActual.foto.length>0){
            [self performSegueWithIdentifier:@"foto_segue" sender:self];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Esta póliza no tiene foto" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alert show];

        }
    }
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return NO;
}


@end
