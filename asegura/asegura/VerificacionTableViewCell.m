//
//  VerificacionTableViewCell.m
//  asegura
//
//  Created by Angel  Solsona on 30/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "VerificacionTableViewCell.h"

@implementation VerificacionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    
    [_periodo2 setTextColor:[UIColor blackColor]];
    [_calcomania setHidden:NO];
    
}

@end
