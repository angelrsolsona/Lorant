//
//  ReporteViewController.h
//  asegura
//
//  Created by Angel  Solsona on 27/01/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NSConnection.h"
#import "Usuario.h"
#import "NSCoreDataManager.h"
#import "MBProgressHUD.h"
#import "Poliza.h"
#import "Polizas.h"
#import "CausaSiniestro.h"
#import "NotasReporteViewController.h"
#import "RecomendacionViewController.h"
@interface ReporteViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,NSConnectionDelegate,NotasReporteViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic)UIView *maskView;
@property(strong,nonatomic)UIPickerView *providerPickerView;
@property(strong,nonatomic)UIToolbar *providerToolbar;
@property(strong,nonatomic)CLLocationManager *location;
@property(strong,nonatomic)NSMutableArray *arrayPolizas;
@property(strong,nonatomic)NSMutableArray *arrayCausas;
@property(assign,nonatomic)BOOL pickerActivo;

@property (weak, nonatomic) IBOutlet UIButton *alias;
@property (weak, nonatomic) IBOutlet UIButton *btnCausas;

@property(weak,nonatomic) IBOutlet UIScrollView *vistaScroll;
@property(weak,nonatomic) IBOutlet GMSMapView *vistaMapa;
@property(weak,nonatomic) IBOutlet UITextField *ubicacionActual;
@property (weak, nonatomic) IBOutlet UITextField *notas;
@property (weak, nonatomic) IBOutlet UIButton *btnEnviarUbicacion;
@property (weak, nonatomic) IBOutlet UIButton *btnLlamar;
@property (weak, nonatomic) IBOutlet UITextField *telefono;
@property (weak, nonatomic) IBOutlet UIButton *btnFoto;
@property (weak, nonatomic) IBOutlet UIButton *btnCompartir;

@property(strong,nonatomic)NSConnection *conexion;
@property(strong,nonatomic)Usuario *usuarioActual;
@property(strong,nonatomic) MBProgressHUD *HUD;
@property(strong,nonatomic) Poliza *polizaActual;
@property(strong,nonatomic)CausaSiniestro *causaActual;
@property(assign,nonatomic) BOOL tienesNotas;
@property(assign,nonatomic) BOOL didFindLocation;

@property(strong,nonatomic) UIImage *imagenSiniestro;
@property(assign,nonatomic) BOOL tienePoliza;
@property(assign,nonatomic) BOOL tieneCausas;
@property(strong,nonatomic) NSString *latitudActual;
@property(strong,nonatomic) NSString *longitudActual;

@property(strong,nonatomic) UIImagePickerController *picker;

@property(assign,nonatomic) BOOL seEnvioReporte;


- (IBAction)Foto:(id)sender;
- (IBAction)EnviarUbicacion:(id)sender;
- (IBAction)Llamar:(id)sender;
- (IBAction)ActivaPicker:(id)sender;


@end
