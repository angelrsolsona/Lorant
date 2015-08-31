//
//  VerificacionesViewController.m
//  asegura
//
//  Created by Angel  Solsona on 10/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "VerificacionesViewController.h"

@interface VerificacionesViewController ()

@end

@implementation VerificacionesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    _usuarioActual=[array objectAtIndex:0];
    
    /*NSArray *arrayEventos=[NSCoreDataManager getDataWithEntity:@"Eventos" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    for (Eventos *ev in arrayEventos) {
        [[NSCoreDataManager getManagedContext] deleteObject:ev];
        [NSCoreDataManager SaveData];
    }*/
    
    /*_conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionGETExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Pólizas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    NSUserDefaults *datosAlm=[NSUserDefaults standardUserDefaults];
    
    _recordarVerificacion.on=[datosAlm boolForKey:@"recordarVerificacion"];
    
    _coreDataManager=[[NSCoreDataManager alloc] init];*/
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionGETExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Pólizas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    NSUserDefaults *datosAlm=[NSUserDefaults standardUserDefaults];
    
    _recordarVerificacion.on=[datosAlm boolForKey:@"recordarVerificacion"];
    
    _coreDataManager=[[NSCoreDataManager alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"detalle_segue"]) {
        DetallePolizaViewController *DVC=[segue destinationViewController];
        [DVC setPolizaActual:_polizaActual];
        [DVC setEsVistaDetalle:YES];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_arrayVerificacion count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VerificacionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Celda"];
    
    Poliza *poliza=[_arrayVerificacion objectAtIndex:indexPath.row];
    [cell.alias setText:poliza.insuranceName];
    if(poliza.perido1!=nil){
        [cell.periodo1 setText:poliza.perido1];
        [cell.periodo2 setText:poliza.perido2];
        [cell.calcomania setImage:[UIImage imageNamed:poliza.calcomania]];
    }else{
        [cell.periodo1 setText:@"Sin Placas"];
        [cell.periodo2 setText:@"Editar Poliza"];
        [cell.periodo2 setTextColor:[UIColor blueColor]];
        [cell.calcomania setHidden:YES];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AgregaPlaca:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [cell.periodo2 setUserInteractionEnabled:YES];
        [cell.periodo2 addGestureRecognizer:tap];
    }
    
    
    
    return cell;
    
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

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            _arrayVerificacion=[[NSMutableArray alloc] init];
            NSLog(@"repuesta %@",[array description]);
            for (NSDictionary *dic in array) {
                //[_arrayMarcas addObject:[dic objectForKey:@"MARCA"]];
                Poliza *poliza=[[Poliza alloc] init];
                poliza.insuranceName=[dic objectForKey:@"insuranceName"];
                poliza.insurenceNumber=[dic objectForKey:@"insuranceNumber"];
                poliza.idAseguradora=[[dic objectForKey:@"idAseguradora"] integerValue];
                poliza.ramo=[[dic objectForKey:@"idRamo"] integerValue];
                poliza.noPlacas=[dic objectForKey:@"NoPlacas"];
                NSArray *fecha=[[dic objectForKey:@"FechaHasta"] componentsSeparatedByString:@"T"];
                poliza.numeroSerie=[dic objectForKey:@"NoSerie"];
                poliza.fechaHasta=[fecha objectAtIndex:0];
                NSLog(@"no Placas %hhd",[poliza.noPlacas isEqualToString:@"S/P"]);
                if (poliza.ramo==1) {
                    if ([poliza.noPlacas isEqual:@"S/P"]||[poliza.noPlacas isEqualToString:@"PERMISO"]||[poliza.noPlacas isEqualToString:@"N/A"]) {
                        NSLog(@"Enconte una");
                        [_arrayVerificacion addObject:poliza];
                    }else{
                        poliza=[self CalculaPeriodo:poliza];
                        [_arrayVerificacion addObject:poliza];
                    }
                    
                    
                }
                
            }
            [_HUD hide:YES];
            [_tabla reloadData];
            
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexión intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

-(Poliza *)CalculaPeriodo:(Poliza *)poliza{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (int i=0; i<[poliza.noPlacas length]; i++) {
        unichar character=[poliza.noPlacas characterAtIndex:i];
        NSCharacterSet *numericCharacter=[NSCharacterSet decimalDigitCharacterSet];
        if ([numericCharacter characterIsMember:character]) {
            [array addObject:[NSString stringWithFormat:@"%c",[poliza.noPlacas characterAtIndex:i]]];
            
        }
    }
    NSLog(@"array %@",[array description]);
    if ([array count]>0) {
        
        NSString *ultimoNumero=[array objectAtIndex:[array count]-1];
        NSString *periodo1;
        NSString *periodo2;
        NSString *calcomania;
        NSString *fechaInicioPeriodo1;
        NSString *fechaFinPeriodo1;
        NSString *fechaInicioPeriodo2;
        NSString *fechaFinPeriodo2;
        switch ([ultimoNumero integerValue]) {
            case 5:
            case 6:
            {
                NSLog(@"Amarillo");
                calcomania=@"VerificacionAmarillo";
                periodo1=@"Enero - Febrero";
                periodo2=@"Julio - Agosto";
                fechaInicioPeriodo1=[NSString stringWithFormat:@"01/01/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo1=[NSString stringWithFormat:@"28/02/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaInicioPeriodo2=[NSString stringWithFormat:@"01/07/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo2=[NSString stringWithFormat:@"31/08/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                
            }break;
            case 7:
            case 8:
            {
                NSLog(@"rosa");
                calcomania=@"VerificacionRosa";
                periodo1=@"Febrero - Marzo";
                periodo2=@"Agosto - Septiembre";
                fechaInicioPeriodo1=[NSString stringWithFormat:@"01/02/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo1=[NSString stringWithFormat:@"31/03/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaInicioPeriodo2=[NSString stringWithFormat:@"01/08/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo2=[NSString stringWithFormat:@"30/09/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                
            }break;
            case 3:
            case 4:
            {
                NSLog(@"Rojo");
                calcomania=@"VerificacionRojo";
                periodo1=@"Marzo - Abril";
                periodo2=@"Septiembre - Octubre";
                fechaInicioPeriodo1=[NSString stringWithFormat:@"01/03/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo1=[NSString stringWithFormat:@"30/04/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaInicioPeriodo2=[NSString stringWithFormat:@"01/09/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo2=[NSString stringWithFormat:@"31/10/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
            }break;
            case 1:
            case 2:
            {
                NSLog(@"Verde");
                calcomania=@"VerificacionVerde";
                periodo1=@"Abril - Mayo";
                periodo2=@"Octubre - Noviembre";
                fechaInicioPeriodo1=[NSString stringWithFormat:@"01/04/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo1=[NSString stringWithFormat:@"31/05/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaInicioPeriodo2=[NSString stringWithFormat:@"01/10/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo2=[NSString stringWithFormat:@"30/11/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
            }break;
            case 9:
            case 0:
            {
                NSLog(@"Azul");
                calcomania=@"VerificacionAzul";
                periodo1=@"Mayo - Junio";
                periodo2=@"Noviembre - Diciembre";
                fechaInicioPeriodo1=[NSString stringWithFormat:@"01/05/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo1=[NSString stringWithFormat:@"30/06/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaInicioPeriodo2=[NSString stringWithFormat:@"01/11/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
                fechaFinPeriodo2=[NSString stringWithFormat:@"31/12/%@",[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
            }break;
                
            default:
                break;
        }
        poliza.perido1=periodo1;
        poliza.perido2=periodo2;
        poliza.calcomania=calcomania;
        poliza.fechaInicioPeriodo1=fechaInicioPeriodo1;
        poliza.fechaFinPeriodo1=fechaFinPeriodo1;
        poliza.fechaInicioPeriodo2=fechaInicioPeriodo2;
        poliza.fechaFinPeriodo2=fechaFinPeriodo2;
        
    }
    
    return poliza;
    //[_calcomania setImage:[UIImage imageNamed:calcomania]];
    //[_periodo1 setText:periodo1];
    //[_periodo2 setText:periodo2];
    
    
    
}

-(IBAction)CambiaSwitch:(id)sender{
    
    NSUserDefaults *datosAlm=[NSUserDefaults standardUserDefaults];
    if (_recordarVerificacion.on) {
        if ([self AgregarACalendario]) {
            [datosAlm setBool:YES forKey:@"recordarVerificacion"];
            [datosAlm synchronize];
        }
    
    }else{
        if ([self EliminarDeCalendario]) {
            
            [datosAlm setBool:NO forKey:@"recordarVerificacion"];
            [datosAlm synchronize];
        }
        
    }
    [datosAlm synchronize];
    //[_HUD setHidden:YES];
}

-(BOOL)AgregarACalendario{
    __block BOOL exito;
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Generando Recordatorios"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    
    ARSNManagerCalendar *calendar=[[ARSNManagerCalendar alloc] init];
    [calendar requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            
            BOOL periodoI1;
            BOOL periodoF1;
            BOOL periodoI2;
            BOOL periodoF2;
            [calendar getCalendar];
            int valor=0;
            for (Poliza *poliza in _arrayVerificacion) {
                
                EKRecurrenceRule *rule1=[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
                EKRecurrenceRule *rule2=[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
                
                EKRecurrenceRule *rule3=[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
                
                EKRecurrenceRule *rule4=[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
                
                NSMutableDictionary *informacionEvento1=[[NSMutableDictionary alloc] initWithObjectsAndKeys:poliza.insurenceNumber,@"noPoliza",@"verificacion",@"tipo", nil];
                NSMutableDictionary *informacionEvento2=[[NSMutableDictionary alloc] initWithObjectsAndKeys:poliza.insurenceNumber,@"noPoliza",@"verificacion",@"tipo", nil];
                NSMutableDictionary *informacionEvento3=[[NSMutableDictionary alloc] initWithObjectsAndKeys:poliza.insurenceNumber,@"noPoliza",@"verificacion",@"tipo", nil];
                NSMutableDictionary *informacionEvento4=[[NSMutableDictionary alloc] initWithObjectsAndKeys:poliza.insurenceNumber,@"noPoliza",@"verificacion",@"tipo", nil];
                
                periodoI1=[calendar addEventAt:[VerificacionFechas convierteNSStringToNSDate:poliza.fechaInicioPeriodo1 Formato:@"dd/MM/yyyy"] endDate:nil withTitle:[NSString stringWithFormat:@"Inicia tu período 1 de verificación de la póliza %@",poliza.insuranceName] allDay:YES recordatorio:rule1 informacionEvento:informacionEvento1];
                
                periodoF1=[calendar addEventAt:[VerificacionFechas convierteNSStringToNSDate:poliza.fechaFinPeriodo1 Formato:@"dd/MM/yyyy"] endDate:nil withTitle:[NSString stringWithFormat:@"Termina tu período 1 de verificación de la póliza %@",poliza.insuranceName] allDay:YES recordatorio:rule2 informacionEvento:informacionEvento2];
                
                periodoI2=[calendar addEventAt:[VerificacionFechas convierteNSStringToNSDate:poliza.fechaInicioPeriodo2 Formato:@"dd/MM/yyyy"] endDate:nil withTitle:[NSString stringWithFormat:@"Inicia tu período 2 de verificación de la póliza %@",poliza.insuranceName] allDay:YES recordatorio:rule3 informacionEvento:informacionEvento3];
                
                periodoF2=[calendar addEventAt:[VerificacionFechas convierteNSStringToNSDate:poliza.fechaFinPeriodo2 Formato:@"dd/MM/yyyy"] endDate:nil withTitle:[NSString stringWithFormat:@"Termina tu período 2 de verificación de la póliza %@",poliza.insuranceName] allDay:YES recordatorio:rule4 informacionEvento:informacionEvento4];
                
                if (periodoI1 && periodoF1 && periodoI2 && periodoF2) {
                    
                    for (NSMutableDictionary *dic in calendar.arrayEventos) {
                        
                        Eventos *evento=[NSEntityDescription insertNewObjectForEntityForName:@"Eventos" inManagedObjectContext:_coreDataManager.managerObject];
                        
                        evento.noPoliza=[dic objectForKey:@"noPoliza"];
                        evento.tipo=[dic objectForKey:@"tipo"];
                        evento.idEvento=[dic objectForKey:@"idEvento"];
                    
                        NSError *error=nil;
                        
                        if([_coreDataManager.managerObject save:&error]){
                            NSLog(@"elemento guardado");
                            
                        }else{
                            NSLog(@"error elemento %@",[error localizedDescription]);
                        }
                    }
                    calendar.arrayEventos=[[NSMutableArray alloc] init];
                    
                    Notificaciones *notificacion1=[NSEntityDescription insertNewObjectForEntityForName:@"Notificaciones" inManagedObjectContext:_coreDataManager.managerObject];
                    notificacion1.noPoliza=poliza.insurenceNumber;
                    notificacion1.tipo=@"verificacion";
                    //notificacion1.fechaInicio=poliza.fechaInicioPeriodo1;
                    //notificacion1.fechaFin=poliza.fechaFinPeriodo1;
                    notificacion1.fechaInicio=[VerificacionFechas transformaNSDatetoString:[VerificacionFechas convierteNSStringToNSDate:[VerificacionFechas obtenerFechaTipo:DIA_MES cadena:poliza.fechaInicioPeriodo1 separador:@"/"] Formato:@"dd/MM"] formato:@"dd/MM"];
                    notificacion1.fechaFin=[VerificacionFechas transformaNSDatetoString:[VerificacionFechas convierteNSStringToNSDate:[VerificacionFechas obtenerFechaTipo:DIA_MES cadena:poliza.fechaFinPeriodo1 separador:@"/"] Formato:@"dd/MM"] formato:@"dd/MM"];
                    notificacion1.mensaje=@"Período 1 de verificación";
                    
                    Notificaciones *notificacion2=[NSEntityDescription insertNewObjectForEntityForName:@"Notificaciones" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
                    notificacion2.noPoliza=poliza.insurenceNumber;
                    notificacion2.tipo=@"verificacion";
                    //notificacion2.fechaInicio=poliza.fechaInicioPeriodo2;
                    //notificacion2.fechaFin=poliza.fechaFinPeriodo2;
                    notificacion2.fechaInicio=[VerificacionFechas transformaNSDatetoString:[VerificacionFechas convierteNSStringToNSDate:[VerificacionFechas obtenerFechaTipo:DIA_MES cadena:poliza.fechaInicioPeriodo2 separador:@"/"] Formato:@"dd/MM"] formato:@"dd/MM"];
                    notificacion2.fechaFin=[VerificacionFechas transformaNSDatetoString:[VerificacionFechas convierteNSStringToNSDate:[VerificacionFechas obtenerFechaTipo:DIA_MES cadena:poliza.fechaFinPeriodo2 separador:@"/"] Formato:@"dd/MM"] formato:@"dd/MM"];
                    notificacion2.mensaje=@"Período 2 de verificación";

                    //calendar.arrayEventos=[[NSMutableArray alloc] init];
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [_HUD hide:YES];
                    });
                   
    
                }else{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar en el calendario" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                    [alert show];
                }
            }
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No has dado permiso a la aplicación para usar el calendario" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
            exito=NO;
        }
    }];
     //[_HUD hide:YES];
    return exito;
    
}
-(BOOL)EliminarDeCalendario{
    
    __block BOOL exito;
    
    ARSNManagerCalendar *calendar=[[ARSNManagerCalendar alloc] init];
    [calendar requestAccess:^(BOOL granted, NSError *error) {
       
        if (granted) {
            
            //NSArray *array=[NSCoreDataManager getDataWithEntity:@"Eventos" predicate:@"tipo CONTAINS\"verificacion\"" andManagedObjContext:[NSCoreDataManager getManagedContext]];
            NSArray *array=[_coreDataManager getDataWithEntity:@"Eventos" predicate:@"tipo ==[c] \"verificacion\""];
            NSArray *arrayNotificacion=[NSCoreDataManager getDataWithEntity:@"Notificaciones" predicate:@"tipo == \"verificacion\"" andManagedObjContext:[NSCoreDataManager getManagedContext]];
            
            for (Eventos *evento in array) {
                NSLog(@"id del evento %@",evento.idEvento);
                if([calendar removeEventWithIdentifier:evento.idEvento removeFutureEvents:YES]){
                    NSLog(@"Eliminado evento de poliza %@ idEvento %@",evento.noPoliza,evento.idEvento );
                    [[NSCoreDataManager getManagedContext] deleteObject:evento];
                    [NSCoreDataManager SaveData];
                }else{
                    NSLog(@"el evento no se encontro y no se elimino");
                    [[NSCoreDataManager getManagedContext] deleteObject:evento];
                    [NSCoreDataManager SaveData];
                }
            }
            
            for (Notificaciones *notif in arrayNotificacion) {
                
                [[NSCoreDataManager getManagedContext] deleteObject:notif];
                [NSCoreDataManager SaveData];
                NSLog(@"Eliminando notificaciones");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                exito=YES;
                [_HUD hide:YES];
            });
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No has dado permiso a la aplicación para usar el calendario" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
            exito=NO;
        }
        
    }];
    
    return exito;
}

-(void)AgregaPlaca:(id)sender{
    UITapGestureRecognizer *tap=(UITapGestureRecognizer *)sender;
    CGPoint location = [tap locationInView:self.tabla];
    NSIndexPath *indexPath = [self.tabla indexPathForRowAtPoint:location];
    /*UIButton *btn=(UIButton *)sender;
     CGPoint center= btn.center;
     CGPoint rootViewPoint = [btn.superview convertPoint:center toView:_tabla];
     NSIndexPath *indexPath = [_tabla indexPathForRowAtPoint:rootViewPoint];*/
    NSLog(@"%ld",(long)indexPath.row);
    _polizaActual=[_arrayVerificacion objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detalle_segue" sender:self];
}


@end
