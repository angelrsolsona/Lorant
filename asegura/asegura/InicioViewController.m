//
//  InicioViewController.m
//  asegura
//
//  Created by Angel  Solsona on 26/01/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "InicioViewController.h"

@interface InicioViewController ()

@end

@implementation InicioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
    _datosAlm=[NSUserDefaults standardUserDefaults];
    BOOL estaLogueado=[_datosAlm boolForKey:@"login"];
    if (estaLogueado) {
        
    }else{
        [self performSegueWithIdentifier:@"login_segue" sender:self];
        
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDisdLayoutSubviews
{
    [_vistaScroll setContentSize:CGSizeMake(320,680)];
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
