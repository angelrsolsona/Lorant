//
//  NotasReporteViewController.m
//  asegura
//
//  Created by Angel  Solsona on 15/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "NotasReporteViewController.h"

@interface NotasReporteViewController ()

@end

@implementation NotasReporteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CerrarTeclado:)];
    [self.view addGestureRecognizer:tap];
    
    if (_tienesNotas) {
        [_notas setText:_nota];
        
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

-(void)CerrarTeclado:(UITapGestureRecognizer *)recognizer{
    
    [self.view endEditing:YES];
    
}

- (IBAction)Guardar:(id)sender {
    [_delegate NotasAgregada:_notas.text];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
