//
//  MenuSencilloViewController.m
//  Sorprais
//
//  Created by Angel  Solsona on 26/11/14.
//  Copyright (c) 2014 Angel  Solsona. All rights reserved.
//

#import "MenuSencilloViewController.h"

@interface MenuSencilloViewController ()

@end

@implementation MenuSencilloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Inicio:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InicioController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}
-(IBAction)MisPolizas:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MisPolizasController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}
-(IBAction)Reporte:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReporteController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}
-(IBAction)Agencias:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AgenciasController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}
-(IBAction)Notificaciones:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificacionesController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}

-(IBAction)AcercaDe:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AcercaDeController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}

-(IBAction)Verificacion:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerificacionesController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}

-(IBAction)Cotiza:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CotizaController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}
-(IBAction)Tips:(id)sender{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TipsController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
}




-(IBAction)Soporte:(id)sender{
   /* NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    [mailComposeViewController setToRecipients:@[@"angelrsolsona@hotmail.com"]];
    [mailComposeViewController setSubject:@"Hello"];
    [mailComposeViewController setMessageBody:@"Lorem ipsum dolor sit amet"
                                       isHTML:NO];
    [navigationController presentViewController:mailComposeViewController animated:YES completion:^{
        // ...
    }];*/
}

-(IBAction)CerrarSesion:(id)sender{
    
    NSArray *eventos=[NSCoreDataManager getDataWithEntity:@"Eventos" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    for (Eventos *evento in eventos) {
        
        [[NSCoreDataManager getManagedContext] deleteObject:evento];
        [NSCoreDataManager SaveData];
    }
    
    NSArray *polizas=[NSCoreDataManager getDataWithEntity:@"Polizas" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    for (Polizas *poliza in polizas) {
        
        [[NSCoreDataManager getManagedContext] deleteObject:poliza];
        [NSCoreDataManager SaveData];
    }
    
    NSArray *fotos=[NSCoreDataManager getDataWithEntity:@"Fotos" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    for (Fotos *foto in fotos) {
        
        [[NSCoreDataManager getManagedContext] deleteObject:foto];
        [NSCoreDataManager SaveData];
    }
    
    NSArray *usuarios=[NSCoreDataManager getDataWithEntity:@"Usuario" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    for (Usuario *usuario in usuarios) {
        
        [[NSCoreDataManager getManagedContext] deleteObject:usuario];
        [NSCoreDataManager SaveData];
    }
    
    NSArray *notificaciones=[NSCoreDataManager getDataWithEntity:@"Notificaciones" andManagedObjContext:[NSCoreDataManager getManagedContext]];
    
    for (Notificaciones *notif in notificaciones) {
        
        [[NSCoreDataManager getManagedContext] deleteObject:notif];
        [NSCoreDataManager SaveData];
    }
    
    NSUserDefaults *datosAlm=[NSUserDefaults standardUserDefaults];
    [datosAlm setBool:NO forKey:@"login"];
    [datosAlm synchronize];
    
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    InicioViewController *IVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InicioController"];
    navigationController.viewControllers = @[IVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    IVC=nil;
    navigationController=nil;
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*-(void)Perfil:(UIGestureRecognizer *)gesture{
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    PerfilViewController *PVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InicioController"];
    navigationController.viewControllers = @[PVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    PVC=nil;
    navigationController=nil;

}

-(IBAction)Avisos:(id)sender{
    
     NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
     AvisosTableViewController *ATVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AvisosTableController"];
     navigationController.viewControllers = @[ATVC];
     self.frostedViewController.contentViewController = navigationController;
     [self.frostedViewController hideMenuViewController];
    navigationController=nil;
    ATVC=nil;

    
}
-(IBAction)Castings:(id)sender{
    
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    CastingsTableViewController *CaTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastingTableController"];
    navigationController.viewControllers = @[CaTVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    navigationController=nil;
    CaTVC=nil;

    
}
-(IBAction)CheckIn:(id)sender{
    
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    CheckInTableViewController *CTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckInTableController"];
    navigationController.viewControllers = @[CTVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    navigationController=nil;
    CTVC=nil;
    
}

-(IBAction)CerrarSesion:(id)sender{
    
    [_managedObject deleteObject:_usuarioActual];
    NSError *deleteError=nil;
    [_managedObject save:&deleteError];
    NSUserDefaults *datosAlm=[NSUserDefaults standardUserDefaults];
    [datosAlm setBool:NO forKey:@"login"];
    [datosAlm synchronize];
    
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    PerfilViewController *PVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InicioController"];
    navigationController.viewControllers = @[PVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    navigationController=nil;
    PVC=nil;
}*/

@end
