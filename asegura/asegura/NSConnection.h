//
//  NSConection.h
//  carreraatletica
//
//  Created by Angel Ricardo Solsona Nevero on 13/05/14.
//  Copyright (c) 2014 Angel Ricardo Solsona Nevero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "Reachability.h"

@protocol NSConnectionDelegate <NSObject>
@required
-(void)connectionDidFinish:(id)result numRequest:(NSInteger)numRequest;
-(void)connectionDidFail:(NSString*)error;

@end

@interface NSConnection : NSObject

@property(assign,nonatomic) NSInteger numRequest;
@property(strong,nonatomic) NSString *url;
@property(strong,nonatomic) id parameters;
@property(strong,nonatomic) AFHTTPRequestOperationManager *manager;
@property(weak,nonatomic) id <NSConnectionDelegate> delegate;

-(id)initWithRequestURL:(NSString *) url parameters:(id)parameters idRequest:(NSInteger)idRequest delegate:(id<NSConnectionDelegate>)delegate;
-(void)connectionPOSTExecute;
-(void)connectionGETExecute;
-(void)connectionPOSTExecuteUploadImage:(UIImage *)imagen;

@end
