//
//  AcercaDeViewController.m
//  asegura
//
//  Created by Angel  Solsona on 09/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "AcercaDeViewController.h"

@interface AcercaDeViewController ()

@end

@implementation AcercaDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];

    NSString *fullURL = @"http://www.lorantms.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_vistaWeb setDelegate:self];
    [_vistaWeb loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_loading startAnimating];
    [_loading setHidden:NO];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loading stopAnimating];
    [_loading setHidden:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",[error description]);
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Determine if we want the system to handle it.
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Muestra Menu
- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

@end
