//
//  RecomendacionViewController.m
//  asegura
//
//  Created by Angel  Solsona on 17/08/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "RecomendacionViewController.h"

@interface RecomendacionViewController ()

@end

@implementation RecomendacionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *imagen=[UIImage imageNamed:[NSString stringWithFormat:@"Recomendacion_%@",_causaActual.nombre]];
    if (imagen==nil) {
        
        if ([_causaActual.nombre isEqualToString:@"Colisión"]) {
            imagen=[UIImage imageNamed:[NSString stringWithFormat:@"Recomendacion_Accidente"]];
        }
        if ([_causaActual.nombre isEqualToString:@"Asistencia Vial"]) {
            imagen=[UIImage imageNamed:[NSString stringWithFormat:@"Recomendacion_Asistencia"]];
        }
        if ([_causaActual.nombre isEqualToString:@"Colisión-Choque"]) {
            imagen=[UIImage imageNamed:[NSString stringWithFormat:@"Recomendacion_Accidente"]];
        }
        if ([_causaActual.nombre isEqualToString:@"Rotura De Cristales"]) {
            imagen=[UIImage imageNamed:[NSString stringWithFormat:@"Recomendacion_Rotura"]];
        }
        if ([_causaActual.nombre isEqualToString:@"Asistencia En Viajes"]) {
            imagen=[UIImage imageNamed:[NSString stringWithFormat:@"Recomendacion_Asistencia"]];
        }
        if ([_causaActual.nombre isEqualToString:@"Inundación"]) {
            imagen=[UIImage imageNamed:[NSString stringWithFormat:@"Recomendacion_Inundacion"]];
        }
        
    
    }
    
    _imagenRecomendacion.image=imagen;
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [_vistaScroll setContentSize:CGSizeMake(320,780)];
    //[_containerView setFrame:CGRectMake(0, 100, 320, 228)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)Llamar:(id)sender{
    
    NSString *telefono=[NSString stringWithFormat:@"tel://%@",_polizaActual.telefonoCabina];
    NSURL *url=[NSURL URLWithString:telefono];
    [[UIApplication sharedApplication] openURL:url];
}

@end
