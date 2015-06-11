//
//  AgenciasViewController.h
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "REFrostedViewController.h"
#import "NSConnection.h"
#import "MBProgressHUD.h"
#import "AgenciasMarkerAnotation.h"

@interface AgenciasViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,NSConnectionDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>

@property(weak,nonatomic)IBOutlet GMSMapView *vistaMapa;
@property(weak,nonatomic)IBOutlet UIScrollView *vistaScroll;
@property(weak,nonatomic)IBOutlet UIButton *agencia;
@property(weak,nonatomic)IBOutlet UIView *selectorAgencia;
@property(weak,nonatomic)IBOutlet UISegmentedControl *segmentalControl;
@property (weak, nonatomic) IBOutlet UILabel *nombreAgencia;
@property (weak, nonatomic) IBOutlet UILabel *direccionAgencia;
@property (weak, nonatomic) IBOutlet UILabel *telefonos;

@property(strong,nonatomic)UIView *maskView;
@property(strong,nonatomic)UIPickerView *providerPickerView;
@property(strong,nonatomic)UIToolbar *providerToolbar;
@property(strong,nonatomic)CLLocationManager *location;
@property(strong,nonatomic)NSConnection *conexion;
@property(strong,nonatomic) MBProgressHUD *HUD;

@property(strong,nonatomic) NSMutableSet *arrayAgencias;
@property(strong,nonatomic) NSMutableArray *arrayMarcas;
@property(strong,nonatomic) NSMutableArray *arrayEstados;

@property(assign,nonatomic) NSInteger tagPicker;
@property(assign,nonatomic) NSInteger idMarcaActual;
@property(assign,nonatomic) NSInteger idEstado;
@property(assign,nonatomic) CLLocationCoordinate2D cordenadaActual;




@end
