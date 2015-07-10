//
//  NotificacionesViewController.m
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "NotificacionesViewController.h"

@interface NotificacionesViewController ()

@end

@implementation NotificacionesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    _usuarioActual=[array objectAtIndex:0];
    NSUserDefaults *datosAlm=[NSUserDefaults standardUserDefaults];
    _recordadVerificacion=[datosAlm boolForKey:@"recordarVerificacion"];
    //[self.frostedViewController setPanGestureEnabled:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS/" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Pólizas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    
    
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayNotificaciones count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotificacionesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Celda" forIndexPath:indexPath];
    ObjNotificacion *notificacion=[_arrayNotificaciones objectAtIndex:indexPath.row];
    [cell.lblNotificacion setText:notificacion.tituloNotificacion];
    
    return cell;
    
}

#pragma mark - NSConnection Delegate

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            _arrayNotificaciones=[[NSMutableArray alloc] init];
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
                    poliza.numeroSerie=[dic objectForKey:@"NoSerie"];
                    poliza.noPlacas=[dic objectForKey:@"NoPlacas"];
                    poliza.nombreAseguradora=[dic objectForKey:@"Aseguradora"];
                    //[_arrayPolizas addObject:poliza];
                    NSInteger diasFaltantes=[VerificacionFechas daysBetweenDate:[NSDate date] andDate:[VerificacionFechas convierteNSStringToNSDate:poliza.fechaHasta Formato:@"yyyy-MM-dd"]];
                    if (diasFaltantes<5 && diasFaltantes>0) {
                        NSLog(@"Agregar notificacion vigencia");
                        ObjNotificacion *notificacion=[[ObjNotificacion alloc] init];
                        [notificacion setTituloNotificacion:[NSString stringWithFormat:@"La póliza \"%@\" está por vencer",poliza.insuranceName]];
                        [_arrayNotificaciones addObject:notificacion];
                    }else if(diasFaltantes<0){
                        ObjNotificacion *notificacion=[[ObjNotificacion alloc] init];
                        [notificacion setTituloNotificacion:[NSString stringWithFormat:@"La póliza \"%@\" está vencida",poliza.insuranceName]];
                        [_arrayNotificaciones addObject:notificacion];

                    }
                    
                    if (_recordadVerificacion) {
                        if (poliza.ramo==1){
                            if ([poliza.noPlacas isEqual:@"S/P"]||[poliza.noPlacas isEqualToString:@"PERMISO"]||[poliza.noPlacas isEqualToString:@"N/A"]||[poliza.noPlacas isEqual:nil]){
                                NSLog(@"No entra");
                            }else{
                                poliza=[self CalculaPeriodo:poliza];
                                NSString *fechaActual=[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"dd/MM/yyyy"];
                                BOOL fechaValida=([VerificacionFechas VerificaPerteneciaRangoFecha:fechaActual fechaInicial:poliza.fechaInicioPeriodo1 fechaFinal:poliza.fechaFinPeriodo1 formatoFecha:@"dd/MM/yyyy"]||[VerificacionFechas VerificaPerteneciaRangoFecha:fechaActual fechaInicial:poliza.fechaInicioPeriodo2 fechaFinal:poliza.fechaFinPeriodo2 formatoFecha:@"dd/MM/yyyy"]);
                                if (fechaValida) {
                                    ObjNotificacion *notificacion=[[ObjNotificacion alloc] init];
                                    [notificacion setTituloNotificacion:[NSString stringWithFormat:@"El auto con la póliza \"%@\" está en periodo de verificación",poliza.insuranceName]];
                                    [_arrayNotificaciones addObject:notificacion];
                                }
                                
                                
                                NSArray *arrayNotificaciones=[NSCoreDataManager getDataWithEntity:@"Notificaciones" predicate:[NSString stringWithFormat:@"noPoliza=\"%@\" AND tipo=\"verificacion\"",poliza.insurenceNumber] andManagedObjContext:[NSCoreDataManager getManagedContext]];
                                
                                for (Notificaciones *notif in arrayNotificaciones) {
                                    
                                    BOOL fechaValida=([VerificacionFechas VerificaPerteneciaRangoFecha:fechaActual fechaInicial:notif.fechaInicio fechaFinal:notif.fechaFin formatoFecha:@"dd/MM/yyyy"]);
                                    if (fechaValida) {
                                        ObjNotificacion *notificacion=[[ObjNotificacion alloc] init];
                                        [notificacion setTituloNotificacion:[NSString stringWithFormat:@"Notificacion: El auto con la póliza \"%@\" está en periodo de verificación",poliza.insuranceName]];
                                        [_arrayNotificaciones addObject:notificacion];
                                    }else{
                                        ObjNotificacion *notificacion=[[ObjNotificacion alloc] init];
                                        [notificacion setTituloNotificacion:[NSString stringWithFormat:@"Notificacion: El auto con la póliza \"%@\" vencio en periodo de verificación",poliza.insuranceName]];
                                        [_arrayNotificaciones addObject:notificacion];
                                    }
                                }
                                
                           
                            }

                        }
                    }
                    
                }
                
            }
            
            [_tabla reloadData];
            
            if (hayError) {
                
                [_HUD setMode:MBProgressHUDModeText];
                [_HUD setLabelText:@"El usuario no tiene pólizas"];
                [self.view addSubview:_HUD];
                [_HUD show:YES];
                [_HUD hide:YES afterDelay:2.0];
            }else{
                [_tabla reloadData];
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
    
    return poliza;
    //[_calcomania setImage:[UIImage imageNamed:calcomania]];
    //[_periodo1 setText:periodo1];
    //[_periodo2 setText:periodo2];
    
    
    
}


@end
