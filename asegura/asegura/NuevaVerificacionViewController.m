//
//  NuevaVerificacionViewController.m
//  asegura
//
//  Created by Angel  Solsona on 30/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "NuevaVerificacionViewController.h"

@interface NuevaVerificacionViewController ()

@end

@implementation NuevaVerificacionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(IBAction)NuevoVehiculo:(id)sender{
    
    
}

-(IBAction)Guardar:(id)sender{
    
    if (![_alias.text isEqual:@""]&&![_placas isEqual:@""]) {
        [self CalculaPeriodo];
        /*Verificacion *nvoVerificacion=[NSEntityDescription insertNewObjectForEntityForName:@"Verificacion" inManagedObjectContext:[NSCoreDataManager getManagedContext]];
        [nvoVerificacion setAlias:_alias.text];
        [nvoVerificacion setPlacas:_placas.text];
        [nvoVerificacion setCalcomania:<#(NSString *)#>];
        [nvoVerificacion setPeriodoUno:];
        [nvoVerificacion setPeriodoDos:<#(NSString *)#>];*/
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Debes llenar todos los campos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)CalculaPeriodo{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (int i=0; i<[_placas.text length]; i++) {
        unichar character=[_placas.text characterAtIndex:i];
        NSCharacterSet *numericCharacter=[NSCharacterSet decimalDigitCharacterSet];
        if ([numericCharacter characterIsMember:character]) {
            [array addObject:[NSString stringWithFormat:@"%c",[_placas.text characterAtIndex:i]]];
            
        }
    }
    NSLog(@"array %@",[array description]);
    NSString *ultimoNumero=[array objectAtIndex:[array count]-1];
    NSString *periodo1;
    NSString *periodo2;
    NSString *calcomania;
    switch ([ultimoNumero integerValue]) {
        case 5:
        case 6:
        {
            NSLog(@"Amarillo");
            calcomania=@"VerificacionAmarillo";
            periodo1=@"Enero - Febrero";
            periodo2=@"Julio - Agosto";
        }break;
        case 7:
        case 8:
        {
            NSLog(@"rosa");
            calcomania=@"VerificacionRosa";
            periodo1=@"Febrero - Marzo";
            periodo2=@"Agosto - Septiembre";
        }break;
        case 3:
        case 4:
        {
            NSLog(@"Rojo");
            calcomania=@"VerificacionRojo";
            periodo1=@"Marzo - Abril";
            periodo2=@"Septiembre - Octubre";
        }break;
        case 1:
        case 2:
        {
            NSLog(@"Verde");
            calcomania=@"VerificacionVerde";
            periodo1=@"Abril - Mayo";
            periodo2=@"Octubre - Noviembre";
        }break;
        case 9:
        case 0:
        {
            NSLog(@"Azul");
            calcomania=@"VerificacionAzul";
            periodo1=@"Mayo - Junio";
            periodo2=@"Noviembre - Diciembre";
        }break;
            
        default:
            break;
    }
    
    [_calcomania setImage:[UIImage imageNamed:calcomania]];
    [_periodo1 setText:periodo1];
    [_periodo2 setText:periodo2];
    
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField.layer setCornerRadius:6.0f];
    [textField.layer setMasksToBounds:YES];
    CGRect rc=[textField bounds];
    rc=[textField convertRect:rc toView:_vistaScroll];
    CGPoint pt=rc.origin;
    pt.x=0;
    pt.y-=60;
    [_vistaScroll setContentOffset:pt animated:YES];
    
}
/*-(void)textFieldDidEndEditing:(UITextField *)textField{
 //[textField setBorderStyle:UITextBorderStyleNone];
 [textField setBackgroundColor:[UIColor clearColor]];
 [textField.layer setCornerRadius:0.0f];
 [textField.layer setMasksToBounds:NO];
 }
 
 }*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField resignFirstResponder];
    [_vistaScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return NO;
}


@end
