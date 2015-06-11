//
//  AcercaDeViewController.h
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
@interface AcercaDeViewController : UIViewController <UIWebViewDelegate>

@property(strong,nonatomic)IBOutlet UIWebView *vistaWeb;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *loading;

@end
