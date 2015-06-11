//
//  NSConection.m
//  carreraatletica
//
//  Created by Angel Ricardo Solsona Nevero on 13/05/14.
//  Copyright (c) 2014 Angel Ricardo Solsona Nevero. All rights reserved.
//

#import "NSConnection.h"
@implementation NSConnection


-(id)initWithRequestURL:(NSString *)url parameters:(id)parameters idRequest:(NSInteger)idRequest delegate:(id<NSConnectionDelegate>)delegate{
    
    if (self=[super init]) {
        
        _url=url;
        _parameters=parameters;
        _numRequest=idRequest;
        _delegate=delegate;
        _manager=[AFHTTPRequestOperationManager manager];
        _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
    
    return self;
}

-(void)connectionPOSTExecute{
    
    Reachability *reacahbility=[Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus=[reacahbility currentReachabilityStatus];
    
    if (networkStatus!=NotReachable) {
        
        [_manager POST:_url parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // NSLog(@"JSON: %@", responseObject);
            [_delegate connectionDidFinish:responseObject numRequest:_numRequest];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"Error: %@", error);
            [_delegate connectionDidFail:[error description]];
        }];
        
    }else{
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error de conexion" message:@"No tienes acceso a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    }
    
    
}



-(void)connectionGETExecute{
    
    [_manager GET:_url parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"JSON: %@", responseObject);
        [_delegate connectionDidFinish:responseObject numRequest:_numRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error: %@", error);
        [_delegate connectionDidFail:[error description]];
    }];
}
-(void)connectionPOSTExecuteUploadImage:(UIImage *)imagen{
    NSData *dataImagen=UIImageJPEGRepresentation(imagen, 0.7);
    [_manager POST:_url parameters:_parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataImagen name:@"image" fileName:@"foto.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        [_delegate connectionDidFinish:responseObject numRequest:_numRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [_delegate connectionDidFail:[error description]];
    }];
}
/*-(void)connectionPOSTExecuteUploadImage:(UIImage *)imagen{
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *dataTask = [sessionManager POST:@"notes" parameters:_parameters constructingBodyWithBlock:^(id formData) {
        UIImage *image1 = [UIImage imageNamed:@"image1"];
        NSData *image1Data = UIImageJPEGRepresentation(image1, 0.7);
        UIImage *image2 = [UIImage imageNamed:@"image2"];
        NSData *image2Data = UIImageJPEGRepresentation(image2, 0.7);
        
        // Añadimos las imágenes a la solicitud
        [formData appendPartWithFormData:image1Data name:@"profile_avatar"];
        [formData appendPartWithFormData:image2Data name:@"profile_background"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [dataTask resume];
}
*/

@end
