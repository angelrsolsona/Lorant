//
//  GaleriaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 20/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "GaleriaViewController.h"

@interface GaleriaViewController ()

@end

@implementation GaleriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_imagen setImage:[UIImage imageWithData:_imagenData]];
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

@end
