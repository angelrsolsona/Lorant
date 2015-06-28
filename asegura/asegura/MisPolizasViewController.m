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
    [_HUD setLabelText:@"Obteniendo Polizas"];
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
    [cell.fecha setText:poliza.fechaHasta];
    [cell.nombreAseguradora setText:poliza.nombreAseguradora];
    
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
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
        [_HUD setLabelText:@"Eliminando Polizas"];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
        
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


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
                [_HUD setLabelText:@"El usuario no tiene polizas"];
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
                [_arrayPolizas removeObjectAtIndex:_indiceBorrarActual];
                [_tabla reloadData];
                [_HUD hide:YES];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No se puede eliminar la poliza intentalo de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
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






@end
