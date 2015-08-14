//
//  HistorialSiniestroTableViewCell.m
//  asegura
//
//  Created by Angel  Solsona on 15/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "HistorialSiniestroTableViewCell.h"

@implementation HistorialSiniestroTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    
    NSArray *viewsToRemove = [_vistaCalificacion subviews];
    for (UIImageView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
}

@end
