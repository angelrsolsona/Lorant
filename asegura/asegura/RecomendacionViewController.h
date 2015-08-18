//
//  RecomendacionViewController.h
//  asegura
//
//  Created by Angel  Solsona on 17/08/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CausaSiniestro.h"
#import "Poliza.h"
@interface RecomendacionViewController : UIViewController

@property(strong,nonatomic)CausaSiniestro *causaActual;
@property(strong,nonatomic)Poliza *polizaActual;
@property (weak, nonatomic) IBOutlet UIImageView *imagenRecomendacion;
@property (weak, nonatomic) IBOutlet UIScrollView *vistaScroll;


-(IBAction)Llamar:(id)sender;

@end
