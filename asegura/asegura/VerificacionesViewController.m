//
//  VerificacionesViewController.m
//  asegura
//
//  Created by Angel  Solsona on 10/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "VerificacionesViewController.h"

@interface VerificacionesViewController ()

@end

@implementation VerificacionesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    _conexion=[[NSConnection alloc] initWithRequestURL:@"https://grupo.lmsmexico.com.mx/wsmovil/api/poliza/getInsuranceListWS" parameters:@{@"nickName":@"amontesinos@lorantmms.com"} idRequest:1 delegate:self];
    [_conexion connectionGETExecute];
    
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VerificacionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Celda"];
    
    return cell;
    
}

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

-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest{
    [_HUD hide:YES];
    NSError *error;
    
    switch (numRequest) {
        case 1:
        {
            NSArray *array=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            for (NSDictionary *dic in array) {
                //[_arrayMarcas addObject:[dic objectForKey:@"MARCA"]];
            }
        }break;
        default:
            break;
    }
    
}
-(void)connectionDidFail:(NSString *)error{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error de conexion intenta de nuevo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    
}

@end
