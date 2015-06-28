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
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS" parameters:@{@"nickName":_usuarioActual.correo} idRequest:1 delegate:self];
    [_conexion connectionGETExecute];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [cell.periodo1 setText:poliza.perido1];
    [cell.periodo2 setText:poliza.perido2];
    [cell.calcomania setImage:[UIImage imageNamed:poliza.calcomania]];
    
    
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
            for (NSDictionary *dic in array) {
                //[_arrayMarcas addObject:[dic objectForKey:@"MARCA"]];
                Poliza *poliza=[[Poliza alloc] init];
                poliza.insuranceName=[dic objectForKey:@"insuranceName"];
                poliza.insurenceNumber=[dic objectForKey:@"insuranceNumber"];
                poliza.idAseguradora=[[dic objectForKey:@"idAseguradora"] integerValue];
                poliza.ramo=[[dic objectForKey:@"idRamo"] integerValue];
                poliza.noPlacas=[dic objectForKey:@"NoPlacas"];
                NSArray *fecha=[[dic objectForKey:@"FechaHasta"] componentsSeparatedByString:@"T"];
                poliza.fechaHasta=[fecha objectAtIndex:0];
                NSLog(@"no Placas %hhd",[poliza.noPlacas isEqualToString:@"S/P"]);
                if (poliza.ramo==1) {
                    if ([poliza.noPlacas isEqual:@"S/P"]||[poliza.noPlacas isEqualToString:@"PERMISO"]||[poliza.noPlacas isEqualToString:@"N/A"]) {
                        NSLog(@"Enconte una");
                    }else{
                        poliza=[self CalculaPeriodo:poliza];
                        [_arrayVerificacion addObject:poliza];
                    }
                    
                    
                }
                
            }
            [_tabla reloadData];
            
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexion intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
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
        switch ([ultimoNumero integerValue]) {
            case 5:
            case 6:
            {
                NSLog(@"Amarillo");
                calcomania=@"VerificacionAmarillo";
                periodo1=@"Enero - Febrero";
                periodo2=@"Julio - Agosto";
            }break;
            case 7:
            case 8:
            {
                NSLog(@"rosa");
                calcomania=@"VerificacionRosa";
                periodo1=@"Febrero - Marzo";
                periodo2=@"Agosto - Septiembre";
            }break;
            case 3:
            case 4:
            {
                NSLog(@"Rojo");
                calcomania=@"VerificacionRojo";
                periodo1=@"Marzo - Abril";
                periodo2=@"Septiembre - Octubre";
            }break;
            case 1:
            case 2:
            {
                NSLog(@"Verde");
                calcomania=@"VerificacionVerde";
                periodo1=@"Abril - Mayo";
                periodo2=@"Octubre - Noviembre";
            }break;
            case 9:
            case 0:
            {
                NSLog(@"Azul");
                calcomania=@"VerificacionAzul";
                periodo1=@"Mayo - Junio";
                periodo2=@"Noviembre - Diciembre";
            }break;
                
            default:
                break;
        }
        poliza.perido1=periodo1;
        poliza.perido2=periodo2;
        poliza.calcomania=calcomania;
    }
    
    return poliza;
    //[_calcomania setImage:[UIImage imageNamed:calcomania]];
    //[_periodo1 setText:periodo1];
    //[_periodo2 setText:periodo2];
    
    
    
}

-(IBAction)CambiaSwitch:(id)sender{
    
    NSUserDefaults *datosAlm=[NSUserDefaults standardUserDefaults];
    if (_recordarVerificacion.on) {
        [datosAlm setBool:YES forKey:@"recordarVerificacion"];
    }else{
        [datosAlm setBool:NO forKey:@"recordarVerificacion"];
    }
    [datosAlm synchronize];
}

@end
