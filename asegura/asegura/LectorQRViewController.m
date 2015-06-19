//
//  LectorQRViewController.m
//  asegura
//
//  Created by Angel  Solsona on 23/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "LectorQRViewController.h"

@interface LectorQRViewController ()

@end

@implementation LectorQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSError *error;
    AVCaptureDevice *captureDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input=[AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (input) {
        _captureSession=[[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        
        AVCaptureMetadataOutput *captureMetaDataOutput=[[AVCaptureMetadataOutput alloc] init];
        [_captureSession addOutput:captureMetaDataOutput];
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue=dispatch_queue_create("myQueue", NULL);
        [captureMetaDataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [captureMetaDataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        _videoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:_viewLector.layer.bounds];
        [_viewLector.layer addSublayer:_videoPreviewLayer];
        [_captureSession startRunning];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo iniciar el lector" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
    }
    

}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects !=nil && [metadataObjects count]>0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj=[metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self performSelectorOnMainThread:@selector(TextoEncntrado:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
        }
    }
}

-(void)TextoEncntrado:(NSString *)valor{
    
    NSLog(@"Valor %@",valor);
    NSArray *valores=[valor componentsSeparatedByString:@"&"];
    if ([valores count]>1) {
        [_captureSession stopRunning];
         [_delegate ResultadoLector:[valores objectAtIndex:0] idRamo:[valores objectAtIndex:1]];
       [self.navigationController popViewControllerAnimated:YES];
    }
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
