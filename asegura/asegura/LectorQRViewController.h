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

@interface LectorQRViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,NSConnectionDelegate>

@property(weak,nonatomic)IBOutlet UIView *viewLector;
@property(strong,nonatomic)AVCaptureSession *captureSession;
@property(strong,nonatomic)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(strong,nonatomic)NSConnection *conexion;

@end
