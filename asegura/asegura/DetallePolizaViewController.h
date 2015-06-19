//
//  DetallePolizaViewController.h
//  asegura
//
//  Created by Angel  Solsona on 11/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSConnection.h"
#import "Poliza.h"
#import "MBProgressHUD.h"
#import "CoberturasTableViewCell.h"

@interface DetallePolizaViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSConnectionDelegate>

@property(weak,nonatomic) IBOutlet UIScrollView *vistaScroll;
@property (weak, nonatomic) IBOutlet UITextField *noPoliza;
@property (weak, nonatomic) IBOutlet UITextField *aliasPoliza;
@property (weak, nonatomic) IBOutlet UITextField *aseguradora;
@property (weak, nonatomic) IBOutlet UITextField *nombreAsegurado;
@property (weak, nonatomic) IBOutlet UITextField *telefonoTitular;
@property (weak, nonatomic) IBOutlet UITextField *correoTitular;
@property (weak, nonatomic) IBOutlet UILabel *fechaVigencia;
@property (weak, nonatomic) IBOutlet UILabel *fechaInicio;
@property (weak, nonatomic) IBOutlet UITextField *formaPago;
@property (weak, nonatomic) IBOutlet UILabel *contratadoCon;
@property (weak, nonatomic) IBOutlet UILabel *paquete;
@property (weak, nonatomic) IBOutlet UITableView *tablaDetalle;
@property (weak, nonatomic) IBOutlet UITableView *tablaCoberturas;
@property (weak, nonatomic) IBOutlet UILabel *lblVerFoto;
@property (weak, nonatomic) IBOutlet UISwitch *recordadVigencia;
@property (weak, nonatomic) IBOutlet UIButton *btnGuardar;

@property (strong,nonatomic) Poliza *polizaActual;
@property (strong,nonatomic) NSConnection *conexion;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (assign,nonatomic) BOOL esBusquedaNueva;

- (IBAction)GuardarPoliza:(id)sender;

@end
