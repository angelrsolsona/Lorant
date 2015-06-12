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
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/searchInsurance" parameters:@{@"insuranceNumber":_polizaActual.insurenceNumber,@"_iIdRamo":[NSString stringWithFormat:@"%ld",(long)_polizaActual.ramo]} idRequest:1 delegate:self];
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

- (void)viewDidLayoutSubviews
{
    //NSLog(@"valor de vista %f",self.view.frame.size.height);
    [_vistaScroll setContentSize:CGSizeMake(320,1230)];
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

#pragma mark NSConnection Delegate
-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
   [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            BOOL hayError=NO;
            
            if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"ER0007"]) {
    
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
                
                [self MuestraDatosPoliza];
                    
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
    [_aseguradora setText:_polizaActual.nombreAseguradora];
    [_telefonoTitular setText:_polizaActual.contactPhoneNumber];
    [_correoTitular setText:_polizaActual.contactMail];
    [_fechaVigencia setText:_polizaActual.fechaHasta];
    [_formaPago setText:_polizaActual.formaPago];
    [_contratadoCon setText:[NSString stringWithFormat:@"Contratado con: %@",_polizaActual.contratadoCon]];
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
            return [_polizaActual.coberturas count];
        }break;
            
        default:
            
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CoberturasTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    return cell;
    
    
}


@end
