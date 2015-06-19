//
//  MasInformacionPolizaViewController.h
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poliza.h"
@protocol MasInformacionPolizaViewControllerDelegate <NSObject>

-(void)GuardarInfoPoliza:(Poliza *)polizaActual;

@end

@interface MasInformacionPolizaViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property(weak,nonatomic)IBOutlet UIScrollView *vistaScroll;


@property(strong,nonatomic)UIView *maskView;
@property(strong,nonatomic)UIPickerView *providerPickerView;
@property(strong,nonatomic)UIDatePicker *pickerDate;
@property(strong,nonatomic)UIToolbar *providerToolbar;
@property(strong,nonatomic)NSMutableArray *arrayIntrumentos;
@property(strong,nonatomic)NSMutableArray *arrayBancos;

@property(strong,nonatomic)Poliza *polizaActual;
@property(strong,nonatomic)NSString *fechaInicio;
@property(strong,nonatomic)NSString *fechaFin;

@property (weak, nonatomic) IBOutlet UITextField *recordatorioInicio;
@property (weak, nonatomic) IBOutlet UITextField *recordatorioFin;
@property (weak, nonatomic) IBOutlet UITextField *instrumentoPago;
@property (weak, nonatomic) IBOutlet UITextField *banco;
@property (weak, nonatomic) IBOutlet UITextField *diasPago;
@property (weak, nonatomic) IBOutlet UISwitch *recordarPago;
@property (weak, nonatomic) IBOutlet UITextField *observaciones;

@property (assign,nonatomic) BOOL estaActivoPicker;
@property (assign,nonatomic) BOOL estaActivoPickerDate;

@property(weak,nonatomic)id <MasInformacionPolizaViewControllerDelegate> delegate;

- (IBAction)Guardar:(id)sender;
@end
