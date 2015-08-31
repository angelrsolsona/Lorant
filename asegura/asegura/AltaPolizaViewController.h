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
#import "TextFieldValidator.h"
#import "VerificacionFechas.h"
#import "ARSNManagerCalendar.h"
#import "Eventos.h"
#import "Notificaciones.h"
#import "UIViewController+BackButtonHandler.h"

@protocol AltaPolizaViewControllerDelegate <NSObject>

-(void)PolizaEditada:(Poliza *)poliza;

@end
@interface AltaPolizaViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,NSConnectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MasInformacionPolizaViewControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

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
@property(strong,nonatomic)Polizas *polizaActualInterna;
@property(strong,nonatomic)NSMutableArray *arrayAseguradoras;
@property(strong,nonatomic)Aseguradoras *aseguradoraActual;
@property (strong,nonatomic) Usuario *usuarioActual;

@property (assign,nonatomic) BOOL estaActivoPicker;
@property (assign,nonatomic) BOOL estaActivoPickerDate;
@property(strong,nonatomic) UIImagePickerController *picker;
@property(assign,nonatomic)BOOL esEdicion;

@property (weak, nonatomic) IBOutlet TextFieldValidator *numeroPoliza;
@property (weak, nonatomic) IBOutlet TextFieldValidator *numeroSerie;
@property (weak, nonatomic) IBOutlet TextFieldValidator *descripcion;
@property (weak, nonatomic) IBOutlet TextFieldValidator *placas;
@property (weak, nonatomic) IBOutlet TextFieldValidator *nombreAsegurado;
@property (weak, nonatomic) IBOutlet TextFieldValidator *telefono;
@property (weak, nonatomic) IBOutlet TextFieldValidator *correo;
@property (weak, nonatomic) IBOutlet UILabel *fechaVigencia;
@property (weak, nonatomic) IBOutlet TextFieldValidator *formaPago;
@property (weak, nonatomic) IBOutlet UISwitch *recordadVigencia;
@property (weak, nonatomic) IBOutlet UILabel *contratadoCon;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtContratadoCon;
@property (weak, nonatomic) IBOutlet TextFieldValidator *paquete;
@property (weak, nonatomic) IBOutlet UITextField *fechaInicio;
@property (weak, nonatomic) IBOutlet UITextField *fechaFin;
@property (weak, nonatomic) IBOutlet TextFieldValidator *aliasPoliza;
@property (weak, nonatomic) IBOutlet UIButton *btnMasInfo;

@property(weak,nonatomic) id <AltaPolizaViewControllerDelegate> delegate;


@end
