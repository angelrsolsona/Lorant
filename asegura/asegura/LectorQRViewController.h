//
//  LectorQRViewController.h
//  asegura
//
//  Created by Angel  Solsona on 23/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSConnection.h"

@protocol LectorQRViewControllerDelegate <NSObject>

-(void)ResultadoLector:(NSString *)noPoliza idRamo:(NSString *)idRamo;

@end
@interface LectorQRViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property(weak,nonatomic)IBOutlet UIView *viewLector;
@property(strong,nonatomic)AVCaptureSession *captureSession;
@property(strong,nonatomic)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(strong,nonatomic)NSConnection *conexion;

@property(weak,nonatomic)id <LectorQRViewControllerDelegate> delegate;

@end
