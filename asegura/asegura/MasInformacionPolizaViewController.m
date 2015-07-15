//
//  MasInformacionPolizaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "MasInformacionPolizaViewController.h"

@interface MasInformacionPolizaViewController ()

@end

@implementation MasInformacionPolizaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrayIntrumentos=[[NSMutableArray alloc] initWithObjects:@"Tarjeta de Crédito",@"Tarjeta de Débito",@"Depósito en Ventanilla",@"Transferencia Electrónica", nil];
    
    _arrayBancos=[[NSMutableArray alloc]init];
    [_arrayBancos addObject:@"BANCO NACIONAL DE MEXICO, S.A."];
    [_arrayBancos addObject:@"BANCO SANTANDER (MEXICO), S.A., INSTITUCION DE BANCA MULTIPLE, GRUPO FINANCIERO SANTANDER MEXICO"];
    [_arrayBancos addObject:@"HSBC MEXICO, S.A."];
    [_arrayBancos addObject:@"SCOTIABANK INVERLAT, S.A."];
    [_arrayBancos addObject:@"BBVA BANCOMER, S.A."];
    [_arrayBancos addObject:@"BANCO MERCANTIL DEL NORTE, S.A."];
    [_arrayBancos addObject:@"BANCO INTERACCIONES, S.A., INSTITUCION DE BANCA MULTIPLE, GRUPO FINANCIERO INTERACCIONES"];
    [_arrayBancos addObject:@"BANCO INBURSA, S.A."];
    [_arrayBancos addObject:@"BANCA MIFEL, S.A."];
    [_arrayBancos addObject:@"BANCO REGIONAL DE MONTERREY, S.A."];
    [_arrayBancos addObject:@"BANCO INVEX, S.A."];
    [_arrayBancos addObject:@"BANCO DEL BAJIO, S.A."];
    [_arrayBancos addObject:@"BANSI, S.A."];
    [_arrayBancos addObject:@"BANCA AFIRME, S. A."];
    [_arrayBancos addObject:@"BANK OF AMERICA MEXICO, S.A."];
    [_arrayBancos addObject:@"BANCO J.P. MORGAN, S.A."];
    [_arrayBancos addObject:@"BANCO VE POR MAS, S.A."];
    [_arrayBancos addObject:@"AMERICAN EXPRESS BANK (MEXICO), S.A."];
    [_arrayBancos addObject:@"INVESTA BANK, S.A., INSTITUCIÓN DE BANCA MÚLTIPLE"];
    [_arrayBancos addObject:@"CIBANCO, S. A."];
    [_arrayBancos addObject:@"BANK OF TOKYO-MITSUBISHI UFJ (MEXICO), S.A."];
    [_arrayBancos addObject:@"BANCO MONEX, S.A."];
    [_arrayBancos addObject:@"DEUTSCHE BANK MEXICO, S.A."];
    [_arrayBancos addObject:@"BANCO AZTECA, S.A."];
    [_arrayBancos addObject:@"BANCO CREDIT SUISSE (MEXICO), S.A."];
    [_arrayBancos addObject:@"BANCO AUTOFIN MEXICO, S.A."];
    [_arrayBancos addObject:@"BARCLAYS BANK MEXICO, S.A."];
    [_arrayBancos addObject:@"BANCO AHORRO FAMSA, S.A."];
    [_arrayBancos addObject:@"INTERCAM BANCO, S.A., INSTITUCIÓN DE BANCA MÚLTIPLE, INTERCAM GRUPO FINANCIERO"];
    [_arrayBancos addObject:@"ABC CAPITAL, S.A. INSTITUCION DE BANCA MULTIPLE"];
    [_arrayBancos addObject:@"BANCO ACTINVER, S.A."];
    [_arrayBancos addObject:@"BANCO COMPARTAMOS, S.A."];
    [_arrayBancos addObject:@"BANCO MULTIVA, S.A."];
    [_arrayBancos addObject:@"UBS BANK MEXICO, S.A."];
    [_arrayBancos addObject:@"BANCOPPEL, S.A."];
    [_arrayBancos addObject:@"CONSUBANCO, S.A."];
    [_arrayBancos addObject:@"BANCO WAL-MART DE MEXICO ADELANTE, S.A."];
    [_arrayBancos addObject:@"VOLKSWAGEN BANK, S.A."];
    [_arrayBancos addObject:@"BANCO BASE, S.A."];
    [_arrayBancos addObject:@"BANCO PAGATODO, S.A."];
    [_arrayBancos addObject:@"BANCO FORJADORES, S.A."];
    [_arrayBancos addObject:@"BANKAOOL, S.A., INSTITUCIÓN DE BANCA MÚLTIPLE"];
    [_arrayBancos addObject:@"BANCO INMOBILIARIO MEXICANO, S.A."];
    [_arrayBancos addObject:@"FUNDACION DONDE BANCO, S.A."];
    [_arrayBancos addObject:@"BANCO BANCREA, S.A."];
    [_arrayBancos addObject:@"OTRO"];
    
    if (_polizaActual.tieneMasInformacion) {
        [_instrumentoPago setText:_polizaActual.instrumentoPago];
        [_banco setText:_polizaActual.banco];
        [_diasPago setText:_polizaActual.diaPago];
        [_observaciones setText:_polizaActual.observacion];
        [_recordatorioInicio setText:_polizaActual.recordatorioPagoInicio];
        [_recordatorioFin setText:_polizaActual.recordatorioPagoFin];
        [_recordarPago setOn:_polizaActual.recordatorioPago animated:YES];
    }else{
        [_recordatorioInicio setText:_polizaActual.startDate];
        [_recordatorioFin setText:_polizaActual.endDate];
    }
    
    if (_esVistaDetalle) {
        [_btnGuardar setHidden:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)GuardarContinuar:(id)sender{
    
}
#pragma mark - Date Picker
-(void)CreateDatePicker:(id)sender{
    
     UITextField *button=(UITextField *)sender;
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,(self.view.bounds.size.height/2)-20, self.view.bounds.size.width, (self.view.bounds.size.height/2)+20)];
    [_maskView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    
    [self.view addSubview:_maskView];
    _providerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 264, self.view.bounds.size.width, 44)];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheetDate:)];
    _providerToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], done];
    _providerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:_providerToolbar];
    
    _pickerDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 220, 0, 0)];
    _pickerDate.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    [_pickerDate setDate:[VerificacionFechas convierteNSStringToNSDate:button.text Formato:@"dd/MM/yyyy"] animated:YES];
    [_pickerDate setMinimumDate:[VerificacionFechas convierteNSStringToNSDate:_polizaActual.startDate Formato:@"dd/MM/yyyy"]];
    [_pickerDate setMaximumDate:[VerificacionFechas convierteNSStringToNSDate:_polizaActual.endDate Formato:@"dd/MM/yyyy"]];
    [_pickerDate setTag:(button.tag*10)];
    [_pickerDate setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:_pickerDate];
    
    _estaActivoPickerDate=YES;
    
}

- (void)dismissActionSheetDate:(id)sender{
    [_maskView removeFromSuperview];
    [_pickerDate removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    if (_pickerDate.tag/10==4) {
        NSDate *selectedDate=[_pickerDate date];
        _fechaInicio=[formatter stringFromDate:selectedDate];
        _recordatorioInicio.text=_fechaInicio;
    }else if (_pickerDate.tag/10==5){
        NSDate *selectedDate=[_pickerDate date];
        _fechaFin=[formatter stringFromDate:selectedDate];
        _recordatorioFin.text=_fechaFin;
    }
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    _estaActivoPickerDate=NO;
    
    
}



#pragma mark - UIpicker

-(void)CreatePicker:(id)sender{
    
    UITextField *button=(UITextField *)sender;
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,(self.view.bounds.size.height/2)-20, self.view.bounds.size.width, (self.view.bounds.size.height/2)+20)];
    [_maskView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    
    [self.view addSubview:_maskView];
    _providerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 264, self.view.bounds.size.width, 44)];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheet:)];
    _providerToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], done];
    _providerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:_providerToolbar];
    
    _providerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 220, 0, 0)];
    _providerPickerView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    _providerPickerView.showsSelectionIndicator = YES;
    _providerPickerView.dataSource = self;
    _providerPickerView.delegate = self;
    [_providerPickerView setTag:(button.tag*10)];
    [self.view addSubview:_providerPickerView];
    
    _estaActivoPicker=YES;
}

- (void)dismissActionSheet:(id)sender{
    [_maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    UITextField *button=(UITextField*)[self.view viewWithTag:(_providerPickerView.tag/10)];
    switch (_providerPickerView.tag) {
        case 10:
        {
            
            [button setText:[NSString stringWithFormat:@"%@",[_arrayIntrumentos objectAtIndex:[_providerPickerView selectedRowInComponent:0]]]];
        }break;
        case 30:
        {
             [button setText:[NSString stringWithFormat:@"%@",[_arrayBancos objectAtIndex:[_providerPickerView selectedRowInComponent:0]]]];
        }break;
        default:
            break;
    }
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    _estaActivoPicker=NO;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 10:
        {
            return [_arrayIntrumentos count];
        }break;
        case 30:
        {
            return [_arrayBancos count];
        }
            
        default:
            return 1;
            break;
    }
    //return 1;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (pickerView.tag) {
        case 10:
        {
            
            return [_arrayIntrumentos objectAtIndex:row];
        }break;
        case 30:
        {
            return [_arrayBancos objectAtIndex:row];
        }
            
        default:
            return @"Texto";
            break;
    }
    
    //return @"Picker";
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleRoundedRect];
    if (textField.tag==1 || textField.tag==3) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if (!_estaActivoPicker&&!_estaActivoPickerDate) {
            [self CreatePicker:textField];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
        }
        
        
    }else if (textField.tag==4||textField.tag==5){
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        
        if (!_estaActivoPickerDate&&!_estaActivoPicker) {
            [self CreateDatePicker:textField];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
        }
  
    }else if (textField.tag==2){
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"                                                                     style:UIBarButtonItemStyleBordered target:self                                                                     action:@selector(cierraTeclado)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }

    
        /*[textField setBackgroundColor:[UIColor whiteColor]];
        [textField.layer setCornerRadius:6.0f];
        [textField.layer setMasksToBounds:YES];*/
        CGRect rc=[textField bounds];
        rc=[textField convertRect:rc toView:_vistaScroll];
        CGPoint pt=rc.origin;
        pt.x=0;
        pt.y-=60;
        [_vistaScroll setContentOffset:pt animated:YES];
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL retorno=YES;
    if (!_estaActivoPicker&&!_estaActivoPickerDate) {
        
        switch (textField.tag) {
            case 1:
            case 3:
            case 4:
            case 5:
            {
                [self.view endEditing:YES];
                retorno=YES;
            }break;
            default:
                break;
        }
        
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una opción" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        retorno=NO;
    }
    
    
    return retorno;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL retorno=YES;
    switch (textField.tag) {
        case 2:
        {
            // Dias de pago
            int limit=1;
            retorno=!([textField.text length]>limit && [string length]>range.length);
        }break;
    }
    
    return retorno;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 2:
        {
            // Dias de pago
            if (!([textField.text integerValue]>=1 && [textField.text integerValue]<=31)) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Debes elegir una fecha válida" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
                [textField setText:@""];
            }
        }break;
    }

}

#pragma mark - Acciones de Boton



- (IBAction)Guardar:(id)sender {
    
    if (_recordarPago.on) {
        if ([_recordatorioInicio.text isEqualToString:@""]||[_recordatorioFin.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Los campos de fecha no pueden estar vacíos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];

        }else{
            if ([VerificacionFechas VerificaFechaesMenor:_recordatorioInicio.text fechaMayor:_recordatorioFin.text formatoFecha:@"dd/MM/yyyy"]) {
                
                _polizaActual.instrumentoPago=_instrumentoPago.text;
                _polizaActual.banco=_banco.text;
                _polizaActual.diaPago=_diasPago.text;
                _polizaActual.observacion=_observaciones.text;
                _polizaActual.recordatorioPagoInicio=_recordatorioInicio.text;
                _polizaActual.recordatorioPagoFin=_recordatorioFin.text;
                NSLog(@"selected %d",_recordarPago.on);
                _polizaActual.recordatorioPago=_recordarPago.on;
                _polizaActual.tieneMasInformacion=YES;
                [_delegate GuardarInfoPoliza:_polizaActual];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Aviso" message:@"La fecha de inicio no puede ser mayor que la fecha de fin" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [alert show];
            }
            
        }
        
    }else{
        
        _polizaActual.instrumentoPago=_instrumentoPago.text;
        _polizaActual.banco=_banco.text;
        _polizaActual.diaPago=_diasPago.text;
        _polizaActual.observacion=_observaciones.text;
        _polizaActual.recordatorioPagoInicio=_recordatorioInicio.text;
        _polizaActual.recordatorioPagoFin=_recordatorioFin.text;
        NSLog(@"selected %d",_recordarPago.on);
        _polizaActual.recordatorioPago=_recordarPago.on;
        _polizaActual.tieneMasInformacion=YES;
        [_delegate GuardarInfoPoliza:_polizaActual];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)cierraTeclado{
    
    [self.view endEditing:YES];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
