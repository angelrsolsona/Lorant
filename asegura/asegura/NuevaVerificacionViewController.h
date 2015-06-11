//
//  NuevaVerificacionViewController.h
//  asegura
//
//  Created by Angel  Solsona on 30/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Verificacion.h"
#import "NSCoreDataManager.h"

@interface NuevaVerificacionViewController : UIViewController

@property(weak,nonatomic) IBOutlet UITextField *alias;
@property(weak,nonatomic) IBOutlet UITextField *placas;
@property(weak,nonatomic) IBOutlet UIImageView *calcomania;
@property(weak,nonatomic) IBOutlet UILabel *periodo1;
@property(weak,nonatomic) IBOutlet UILabel *periodo2;
@property(weak,nonatomic) IBOutlet UIScrollView *vistaScroll;

@end
