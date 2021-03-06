//
//  MisPolizasViewController.m
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "MisPolizasViewController.h"

@interface MisPolizasViewController ()

@end

@implementation MisPolizasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    NSArray *array=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    _usuarioActual=[array objectAtIndex:0];
    //[self.frostedViewController setPanGestureEnabled:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    _esVistaDetalle=NO;
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS/" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionPOSTExecute];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [_HUD setMode:MBProgressHUDModeIndeterminate];
    [_HUD setLabelText:@"Obteniendo Pólizas"];
    [self.view addSubview:_HUD];
    [_HUD show:YES];

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
        [DVC setEsVistaDetalle:_esVistaDetalle];
        
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayPolizas count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MisPolizasTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Celda" forIndexPath:indexPath];
    Poliza *poliza=[_arrayPolizas objectAtIndex:indexPath.row];
    [cell.alias setText:poliza.insuranceName];
    
    NSString *dateString = poliza.fechaHasta;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    
    
    
    [cell.fecha setText:newDateString];
    [cell.nombreAseguradora setText:poliza.nombreAseguradora];
    [cell.btnEliminar addTarget:self action:@selector(EliminaPoliza:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (poliza.ramo) {
        case 1:
        {
            [cell.iconoRojo setImage:[UIImage imageNamed:@"IconoPolizaRojoAutos"]];
        }break;
        case 2:
        {
            [cell.iconoRojo setImage:[UIImage imageNamed:@"IconoPolizaRojoHogar"]];
        }break;
        case 3:
        {
            [cell.iconoRojo setImage:[UIImage imageNamed:@"IconoPolizaRojoVida"]];
        }break;
        case 4:
        {
            [cell.iconoRojo setImage:[UIImage imageNamed:@"IconoPolizaRojoGasto"]];
        }break;
        case 5:
        {
            [cell.iconoRojo setImage:[UIImage imageNamed:@"IconoPolizaRojoEducacion"]];
        }break;
        case 6:
        {
            [cell.iconoRojo setImage:[UIImage imageNamed:@"IconoPolizaRojoMascota"]];
        }break;
        case 7:
        {
            [cell.iconoRojo setImage:[UIImage imageNamed:@"IconoPolizaRojoOtros"]];
        }break;
        default:
            break;
    }
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _esVistaDetalle=YES;
    _polizaActual=[_arrayPolizas objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detalle_segue" sender:self];
}

/*-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        _indiceBorrarActual=indexPath.row;
        Poliza *poliza=[_arrayPolizas objectAtIndex:indexPath.row];
        _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/deleteInsuranceWS/" parameters:@{@"nickName":_usuarioActual.correo,@"insuranceNumber":poliza.insurenceNumber} idRequest:2 delegate:self];
        [_conexion connectionPOSTExecute];
        
        _HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [_HUD setMode:MBProgressHUDModeIndeterminate];
        [_HUD setLabelText:@"Eliminando Pólizas"];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
        
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}*/


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
                    poliza.numeroSerie=[dic objectForKey:@"NoSerie"];
                    poliza.nombreAseguradora=[dic objectForKey:@"Aseguradora"];
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
                [_tabla reloadData];
            }
        }break;
        
        case 2:{
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0001"]) {
                Poliza *poliza=[_arrayPolizas objectAtIndex:_indiceBorrarActual];
                NSArray *array=[NSCoreDataManager getDataWithEntity:@"Polizas" predicate:[NSString stringWithFormat:@"noPoliza==\"%@\"",poliza.insurenceNumber] andManagedObjContext:[NSCoreDataManager getManagedContext]];
                for (Polizas *polizas in array) {
                    [[NSCoreDataManager getManagedContext] deleteObject:polizas];
                    [NSCoreDataManager SaveData];
                }
                
                
                NSArray *arrayDiaPago=[NSCoreDataManager getDataWithEntity:@"Eventos" predicate:[NSString stringWithFormat:@"noPoliza=\"%@\" AND tipo=\"pago\"",poliza.insurenceNumber] andManagedObjContext:[NSCoreDataManager getManagedContext]];
                
                NSArray *arrayVigencia=[NSCoreDataManager getDataWithEntity:@"Eventos" predicate:[NSString stringWithFormat:@"noPoliza=\"%@\" AND tipo=\"vigencia\"",poliza.insurenceNumber] andManagedObjContext:[NSCoreDataManager getManagedContext]];
                
                NSArray *arrayNotifPago=[NSCoreDataManager getDataWithEntity:@"Notificaciones" predicate:[NSString stringWithFormat:@"noPoliza=\"%@\" AND tipo=\"pago\" ",poliza.insurenceNumber] andManagedObjContext:[NSCoreDataManager getManagedContext]];
                
                NSArray *arrayNotifVigencia=[NSCoreDataManager getDataWithEntity:@"Notificaciones" predicate:[NSString stringWithFormat:@"noPoliza=\"%@\" AND tipo=\"vigencia\" ",poliza.insurenceNumber] andManagedObjContext:[NSCoreDataManager getManagedContext]];
                
                for (Notificaciones *notifPago in arrayNotifPago) {
                    
                    [[NSCoreDataManager getManagedContext] deleteObject:notifPago];
                    [NSCoreDataManager SaveData];
                }
                
                for (Notificaciones *notifVig in arrayNotifVigencia) {
                    
                    [[NSCoreDataManager getManagedContext] deleteObject:notifVig];
                    [NSCoreDataManager SaveData];
                }
                
                if ([arrayDiaPago count]>0) {
                    Eventos *eventoDiaPago=[arrayDiaPago objectAtIndex:0];
                    
                    ARSNManagerCalendar *calendar=[[ARSNManagerCalendar alloc] init];
                    [calendar requestAccess:^(BOOL granted, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [calendar getCalendar];
                            [calendar removeEventWithIdentifier:eventoDiaPago.idEvento removeFutureEvents:YES];
                        });
                        
                        
                    }];
                }
                
                if ([arrayVigencia count]>0) {
                    Eventos *eventoVigencia=[arrayVigencia objectAtIndex:0];
                    
                    ARSNManagerCalendar *calendar=[[ARSNManagerCalendar alloc] init];
                    [calendar requestAccess:^(BOOL granted, NSError *error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [calendar getCalendar];
                            [calendar removeEventWithIdentifier:eventoVigencia.idEvento removeFutureEvents:YES];
                        });
                        
                    }];
                }

                
                [_arrayPolizas removeObjectAtIndex:_indiceBorrarActual];
                [_tabla reloadData];
                [_HUD hide:YES];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No se puede eliminar la póliza intentalo de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
            }
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    [_HUD setHidden:YES];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexión intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

-(void)EliminaPoliza:(id)sender{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"¿Seguro que deseas borrar la póliza?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
    [alert show];
    
    UIButton *btn=(UIButton *)sender;
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:_tabla];
    NSIndexPath *indexPath = [_tabla indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%ld",(long)indexPath.row);
    _indiceBorrarActual=indexPath.row;
   


    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
                
        
        Poliza *poliza=[_arrayPolizas objectAtIndex:_indiceBorrarActual];
        _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/deleteInsuranceWS/" parameters:@{@"nickName":_usuarioActual.correo,@"insuranceNumber":poliza.insurenceNumber} idRequest:2 delegate:self];
        [_conexion connectionPOSTExecute];
        
        _HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [_HUD setMode:MBProgressHUDModeIndeterminate];
        [_HUD setLabelText:@"Eliminando Pólizas"];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
    
    }
    
}






@end
