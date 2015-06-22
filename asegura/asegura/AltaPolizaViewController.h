//
//  AltaPolizaViewController.h
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSConnection.h"
#import "MBProgressHUD.h"
#import "CoberturasTableViewCell.h"
#import "Poliza.h"
#import "Aseguradoras.h"
#import "Usuario.h"
#import "Polizas.h"
#import "NSCoreDataManager.h"
#import "MasInformacionPolizaViewController.h"
@interface AltaPolizaViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,NSConnectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MasInformacionPolizaViewControllerDelegate>

@property(weak,nonatomic)IBOutlet UIScrollView *vistaScroll;

@property(strong,nonatomic)UIView *maskView;
@property(strong,nonatomic)UIPickerView *providerPickerView;
@property(strong,nonatomic)UIDatePicker *pickerDate;
@property(strong,nonatomic)UIToolbar *providerToolbar;
@property(assign,nonatomic)NSInteger idRamoActual;
@property(assign,nonatomic)NSInteger idAseguradoraActual;
@property(strong,nonatomic)NSConnection *conexion;
@property(strong,nonatomic)MBProgressHUD *HUD;
@property(strong,nonatomic)Poliza *polizaActual;
@property(strong,nonatomic)NSMutableArray *arrayAseguradoras;
@property(strong,nonatomic)Aseguradoras *aseguradoraActual;
@property (strong,nonatomic) Usuario *usuarioActual;

@property (assign,nonatomic) BOOL estaActivoPicker;
@property (assign,nonatomic) BOOL estaActivoPickerDate;
@property(strong,nonatomic) UIImagePickerController *picker;


@property (weak, nonatomic) IBOutlet UITextField *numeroPoliza;
@property (weak, nonatomic) IBOutlet UITextField *numeroSerie;
@property (weak, nonatomic) IBOutlet UITextField *descripcion;
@property (weak, nonatomic) IBOutlet UITextField *placas;
@property (weak, nonatomic) IBOutlet UITextField *nombreAsegurado;
@property (weak, nonatomic) IBOutlet UITextField *telefono;
@property (weak, nonatomic) IBOutlet UITextField *correo;
@property (weak, nonatomic) IBOutlet UILabel *fechaVigencia;
@property (weak, nonatomic) IBOutlet UITextField *formaPago;
@property (weak, nonatomic) IBOutlet UISwitch *recordadVigencia;
@property (weak, nonatomic) IBOutlet UILabel *contratadoCon;
@property (weak, nonatomic) IBOutlet UITextField *txtContratadoCon;
@property (weak, nonatomic) IBOutlet UITextField *paquete;
@property (weak, nonatomic) IBOutlet UITextField *fechaInicio;
@property (weak, nonatomic) IBOutlet UITextField *fechaFin;
@property (weak, nonatomic) IBOutlet UITextField *aliasPoliza;


@end
