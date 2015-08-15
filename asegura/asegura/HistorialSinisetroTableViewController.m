//
//  HistorialSinisetroTableViewController.m
//  asegura
//
//  Created by Angel  Solsona on 15/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "HistorialSinisetroTableViewController.h"

@interface HistorialSinisetroTableViewController ()

@end

@implementation HistorialSinisetroTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    _usuarioActual=[array objectAtIndex:0];
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getRecuperaSiniestro/" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Siniestros"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_arraySiniestros count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"numero %d",indexPath.row);
    HistorialSiniestroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    HistorialSiniestro *historial=[_arraySiniestros objectAtIndex:indexPath.row];
    
    NSArray *fecha=[historial.fechaRegistro componentsSeparatedByString:@"T"];
    
    [cell.fechaReporte setText:[fecha objectAtIndex:0]];
    [cell.horaReporte setText:[fecha objectAtIndex:1]];
    [cell.noPoliza setText:historial.noPoliza];
    [cell.causaSiniestro setText:historial.siniestro];
    [cell.informacion setText:historial.informacion];

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[historial.latitud floatValue] longitude:[historial.longitud floatValue]                                                          zoom:14];
    
    [cell.vistaMapa setCamera:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([historial.latitud floatValue],[historial.longitud floatValue]);
    marker.title = [NSString stringWithFormat:@"Mi Ubicación:(%.3f,%.3f)",[historial.latitud floatValue],[historial.longitud floatValue]];
    //marker.snippet = @"Australia";
    marker.map = cell.vistaMapa;
    NSLog(@"Calificacion %@",historial.calificacion);
    NSInteger calificacion= [historial.calificacion integerValue];
    for(int i=0;i<5;i++){
        UIImageView *estrella=[[UIImageView alloc] initWithFrame:CGRectMake(i*35, 3, 27, 27)];
        if(i<calificacion){
            [estrella setImage:[UIImage imageNamed:@"EstrellaActiva"]];
        }else{
            [estrella setImage:[UIImage imageNamed:@"EstrellaInActiva"]];
        }
        
        [cell.vistaCalificacion addSubview:estrella];
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Calificar:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [cell.vistaCalificacion addGestureRecognizer:tap];
    
    
    
    return cell;
}

#pragma mark - Vista Calificaciones
-(void)Calificar:(id)sender{
    
    UITapGestureRecognizer *tap=(UITapGestureRecognizer *)sender;
    CGPoint location = [tap locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    /*UIButton *btn=(UIButton *)sender;
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:_tabla];
    NSIndexPath *indexPath = [_tabla indexPathForRowAtPoint:rootViewPoint];*/
    NSLog(@"%ld",(long)indexPath.row);
    _siniestroActual=[_arraySiniestros objectAtIndex:indexPath.row];
    [self CreaVistaCalificacion];
    
}

-(void)CreaVistaCalificacion{
    
    
    
    /*_alertaFondo=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    [_alertaFondo setBackgroundColor:[UIColor blackColor]];
    ///_alertaFondo.layer.opacity=0.5f;*/
    
    _infoView=[[[NSBundle mainBundle] loadNibNamed:@"VistaCalificacion" owner:self options:nil] objectAtIndex:0];
    [_infoView setBackgroundColor:[UIColor colorWithRed:224/255 green:224/255 blue:224/255 alpha:0.7]];
    [_infoView setFrame:CGRectMake(5,100, _infoView.frame.size.width, _infoView.frame.size.height)];
    
    [_infoView.estrella1 addTarget:self action:@selector(SeleccionaEstrella:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.estrella2 addTarget:self action:@selector(SeleccionaEstrella:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.estrella3 addTarget:self action:@selector(SeleccionaEstrella:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.estrella4 addTarget:self action:@selector(SeleccionaEstrella:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.estrella5 addTarget:self action:@selector(SeleccionaEstrella:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.btnCancelar addTarget:self action:@selector(CancelarCalificacion) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.btnEnviar addTarget:self action:@selector(EnviarCalificacion) forControlEvents:UIControlEventTouchUpInside];
    
    [self RedondeaBoton:_infoView.btnCancelar conBorde:NO];
    [self RedondeaBoton:_infoView.btnEnviar conBorde:NO];
    
    /*[_alertaFondo addSubview:_infoView];
    [self.view addSubview:_alertaFondo];*/
    
    _popup=[KLCPopup popupWithContentView:_infoView];
    [_popup show];
    
}

-(void)EnviarCalificacion{
    
    [_popup dismiss:YES];
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"http://grupo.lmsmexico.com.mx/wsmovil/api/poliza/sendScore" parameters:@{@"nickName":_usuarioActual.correo,@"sinisterId":_siniestroActual.idSinisetro,@"calificacion":[NSString stringWithFormat:@"%d",_calificacionActual]} idRequest:2 delegate:self];
    [_conexion connectionPOSTExecute];
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Enviando Calificación"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];

}

-(void)CancelarCalificacion{
    [_popup dismiss:YES];
}
-(void)SeleccionaEstrella:(id)sender{
    NSLog(@"Seleccionando Estrella");
    UIButton *btn=(UIButton *)sender;
    for (int i=1; i<=5; i++) {
        UIButton *estrella=(UIButton *)[_infoView viewWithTag:i];
        if(i<=btn.tag){
            [estrella setBackgroundImage:[UIImage imageNamed:@"EstrellaActiva"] forState:UIControlStateNormal];
        }else{
            [estrella setBackgroundImage:[UIImage imageNamed:@"EstrellaInActiva"] forState:UIControlStateNormal];
        }
        
    }
    
    _calificacionActual=btn.tag;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark NSConnection Delegate
-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            _arraySiniestros=[[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                
                HistorialSiniestro *historial=[[HistorialSiniestro alloc] init];
                historial.idPolizaM=[dic objectForKey:@"ID_POLIZA_M"];
                historial.noPoliza=[dic objectForKey:@"NO_POLIZA"];
                historial.siniestro=[dic objectForKey:@"SINIESTRO"];
                historial.noTelefono=[dic objectForKey:@"NO_TEL"];
                historial.latitud=[dic objectForKey:@"LATITUD"];
                historial.longitud=[dic objectForKey:@"LONGITUD"];
                if ([[dic objectForKey:@"INFORMACION"] isEqual:[NSNull null]]) {
                     historial.informacion=@"NA";
                }else{
                     historial.informacion=[dic objectForKey:@"INFORMACION"];
                }
               
                historial.fechaUsuario=[dic objectForKey:@"FECHA_USUARIO_INICIO"];
                historial.fechaRegistro=[dic objectForKey:@"FECHA_REGISTRO"];
                historial.fechaReporte=[dic objectForKey:@"FECHAREPORTE"];
                historial.idSinisetro=[dic objectForKey:@"ID_SINIESTRO"];
                historial.calificacion=[dic objectForKey:@"CALIFICACION"];
                [_arraySiniestros addObject:historial];
                
            }
            
            [self.tableView reloadData];
           
        }break;
        case 2:
        {
         
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                [_HUD hide:YES];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Calificación exitosa" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getRecuperaSiniestro/" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
                [_conexion connectionPOSTExecute];
                _HUD=[[MBProgressHUD alloc] initWithView:self.view];
                [_HUD setMode:MBProgressHUDModeIndeterminate];
                [_HUD setLabelText:@"Obteniendo Siniestros"];
                [self.view addSubview:_HUD];
                [_HUD show:YES];
                
            }else{
                [_HUD hide:YES];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Siniestro ya calificado anteriormente" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
            }
            
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexión intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
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
