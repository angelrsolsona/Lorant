//
//  NotificacionesViewController.h
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "NotificacionesTableViewCell.h"

@interface NotificacionesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)IBOutlet UITableView *tabla;

@end
