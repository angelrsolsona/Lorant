//
//  DetalleTipViewController.h
//  asegura
//
//  Created by Angel  Solsona on 31/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleTipViewController : UIViewController

@property(assign,nonatomic)NSInteger numTipActual;
@property(weak,nonatomic) IBOutlet UIImageView *imagenTip;
@property(weak,nonatomic) IBOutlet UITextView *descripcion;

@end
