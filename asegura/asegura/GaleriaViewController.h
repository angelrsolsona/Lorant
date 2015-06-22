//
//  GaleriaViewController.h
//  asegura
//
//  Created by Angel  Solsona on 20/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaleriaViewController : UIViewController

@property(strong,nonatomic)NSData *imagenData;
@property(weak,nonatomic) IBOutlet UIImageView *imagen;

@end
