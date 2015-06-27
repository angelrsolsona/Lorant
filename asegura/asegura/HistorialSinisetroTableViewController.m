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
    
    NSArray *fecha=[historial.fechaUsuario componentsSeparatedByString:@"T"];
    
    [cell.fechaReporte setText:[fecha objectAtIndex:0]];
    [cell.horaReporte setText:[fecha objectAtIndex:1]];
    [cell.noPoliza setText:historial.noPoliza];
    [cell.causaSiniestro setText:historial.siniestro];
    [cell.informacion setText:historial.informacion];

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[historial.latitud floatValue] longitude:[historial.longitud floatValue]                                                          zoom:14];
    
    [cell.vistaMapa setCamera:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([historial.latitud floatValue],[historial.longitud floatValue]);
    marker.title = [NSString stringWithFormat:@"Mi Ubicacion:(%.3f,%.3f)",[historial.latitud floatValue],[historial.longitud floatValue]];
    //marker.snippet = @"Australia";
    marker.map = cell.vistaMapa;
    
    
    return cell;
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
                [_arraySiniestros addObject:historial];
                
            }
            
            [self.tableView reloadData];
           
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
