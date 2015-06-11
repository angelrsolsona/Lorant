//
//  MasInformacionPolizaViewController.h
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MisPolizasViewController.h"
@interface MasInformacionPolizaViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property(weak,nonatomic)IBOutlet UIScrollView *vistaScroll;


@property(strong,nonatomic)UIView *maskView;
@property(strong,nonatomic)UIPickerView *providerPickerView;
@property(strong,nonatomic)UIToolbar *providerToolbar;
@property(strong,nonatomic)NSMutableArray *arrayIntrumentos;

@end
