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
@interface ReporteViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>

@property(strong,nonatomic)UIView *maskView;
@property(strong,nonatomic)UIPickerView *providerPickerView;
@property(strong,nonatomic)UIToolbar *providerToolbar;
@property(strong,nonatomic)CLLocationManager *location;
@property(strong,nonatomic)NSMutableArray *arrayPolizas;
@property(strong,nonatomic)NSMutableArray *arrayCausas;
@property(assign,nonatomic)BOOL pickerActivo;

@property (weak, nonatomic) IBOutlet UIButton *alias;
@property(weak,nonatomic) IBOutlet UIScrollView *vistaScroll;
@property(weak,nonatomic) IBOutlet GMSMapView *vistaMapa;
@property(weak,nonatomic) IBOutlet UITextField *ubicacionActual;

@end
