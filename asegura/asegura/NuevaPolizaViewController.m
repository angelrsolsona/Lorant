//
//  NuevaPolizaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 23/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "NuevaPolizaViewController.h"

@interface NuevaPolizaViewController ()

@end

@implementation NuevaPolizaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SeleccionaRamo:(id)sender{
    
    UIButton *boton=(UIButton *)sender;
    _ramoActual=boton.tag;
    
    if (_ramoActual==1) {
        [self performSegueWithIdentifier:@"altaPolizaAuto_segue" sender:self];
        
    }else{
        [self performSegueWithIdentifier:@"altaPolizaNormal_segue" sender:self];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AltaPolizaViewController *APVC=[segue destinationViewController];
    [APVC setIdRamoActual:_ramoActual];
    
}


@end
