//
//  CotizaViewController.m
//  asegura
//
//  Created by Angel  Solsona on 31/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "CotizaViewController.h"

@interface CotizaViewController ()

@end

@implementation CotizaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self RedondeaBoton:_btnLlamar conBorde:NO];
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

#pragma mark - Muestra Menu
- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(IBAction)Llamar:(id)sender{
    
    NSString *telefono=@"tel://30936840";
    NSURL *url=[NSURL URLWithString:telefono];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)RedondeaBoton:(UIButton *)boton conBorde:(BOOL)conBorde{
    
    //[boton setBackgroundColor:[UIColor whiteColor]];
    [boton.layer setCornerRadius:6.0f];
    [boton.layer setMasksToBounds:YES];
    if (conBorde) {
        UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        boton.layer.borderColor=borderColor.CGColor;
        boton.layer.borderWidth=1.0;
    }
    
}

@end
