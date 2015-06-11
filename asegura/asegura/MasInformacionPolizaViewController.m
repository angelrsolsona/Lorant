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
    _arrayIntrumentos=[[NSMutableArray alloc] initWithObjects:@"Tarjeta de Crédito",@"Tarjeta de Débito",@"Déposito en Ventanilla",@"Transferencia Eléctronica", nil];
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
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[MisPolizasViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

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
            [button setText:@"Banco 1"];
        }break;
        default:
            break;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 10:
        {
            return [_arrayIntrumentos count];
        }break;
        case 30:
        {
            return 1;
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
            return @"Banco 1";
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
        [self CreatePicker:textField];
        
    }
    
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



@end
