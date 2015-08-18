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
#import "MasInformacionPolizaViewController.h"
#import "Usuario.h"
#import "NSCoreDataManager.h"
#import "Polizas.h"
#import "GaleriaViewController.h"
#import "TextFieldValidator.h"
#import "AltaPolizaViewController.h"
@interface DetallePolizaViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSConnectionDelegate,MasInformacionPolizaViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AltaPolizaViewControllerDelegate,UITextFieldDelegate>

@property(weak,nonatomic) IBOutlet UIScrollView *vistaScroll;
@property (weak, nonatomic) IBOutlet TextFieldValidator *noPoliza;
@property (weak, nonatomic) IBOutlet TextFieldValidator *aliasPoliza;
@property (weak, nonatomic) IBOutlet TextFieldValidator *aseguradora;
@property (weak, nonatomic) IBOutlet TextFieldValidator *nombreAsegurado;
@property (weak, nonatomic) IBOutlet TextFieldValidator *telefonoTitular;
@property (weak, nonatomic) IBOutlet TextFieldValidator *correoTitular;
@property (weak, nonatomic) IBOutlet TextFieldValidator *fechaVigencia;
@property (weak, nonatomic) IBOutlet TextFieldValidator *fechaInicio;
@property (weak, nonatomic) IBOutlet TextFieldValidator *formaPago;
/// placas solo para autos
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtPlacas;
@property (weak, nonatomic) IBOutlet UILabel *lblPlacas;

@property (weak, nonatomic) IBOutlet UILabel *contratadoCon;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtContratadoCon;
@property (weak, nonatomic) IBOutlet TextFieldValidator *paquete;
@property (weak, nonatomic) IBOutlet UITableView *tablaDetalle;
@property (weak, nonatomic) IBOutlet UITableView *tablaCoberturas;
@property (weak, nonatomic) IBOutlet UILabel *lblVerFoto;
@property (weak, nonatomic) IBOutlet UISwitch *recordadVigencia;
@property (weak, nonatomic) IBOutlet UIButton *btnGuardar;

@property (weak,nonatomic) IBOutlet UIBarButtonItem *btnEditar;
@property (weak, nonatomic) IBOutlet UIButton *btnMasInfo;

@property (strong,nonatomic) Poliza *polizaActual;
@property (strong,nonatomic) Usuario *usuarioActual;
@property (strong,nonatomic) NSConnection *conexion;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (assign,nonatomic) BOOL esBusquedaNueva;
@property (assign,nonatomic) BOOL esVistaDetalle;

@property(assign,nonatomic) BOOL estaEditando;

@property(strong,nonatomic) UIImagePickerController *picker;


- (IBAction)GuardarPoliza:(id)sender;

@end
