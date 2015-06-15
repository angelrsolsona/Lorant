//
//  HistorialSiniestroTableViewCell.h
//  asegura
//
//  Created by Angel  Solsona on 15/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface HistorialSiniestroTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fechaReporte;
@property (weak, nonatomic) IBOutlet UILabel *noPoliza;
@property (weak, nonatomic) IBOutlet UILabel *horaReporte;
@property (weak, nonatomic) IBOutlet UILabel *causaSiniestro;
@property (weak, nonatomic) IBOutlet GMSMapView *vistaMapa;
@property (weak, nonatomic) IBOutlet UILabel *informacion;

@end
