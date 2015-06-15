//
//  NotasReporteViewController.h
//  asegura
//
//  Created by Angel  Solsona on 15/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotasReporteViewControllerDelegate <NSObject>

-(void)NotasAgregada:(NSString *)nota;
-(void)DetalleAgregado:(NSString *)detalle;


@end

@interface NotasReporteViewController : UIViewController <UITextViewDelegate>

@property(weak,nonatomic) IBOutlet UITextView  *notas;
@property(weak,nonatomic) IBOutlet UITextView *detalleSiniestro;
@property(weak,nonatomic) id <NotasReporteViewControllerDelegate> delegate;
@property(assign,nonatomic) BOOL tienesNotas;
@property(strong,nonatomic) NSString *nota;

- (IBAction)Guardar:(id)sender;

@end
