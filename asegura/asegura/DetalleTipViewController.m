//
//  DetalleTipViewController.m
//  asegura
//
//  Created by Angel  Solsona on 31/03/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "DetalleTipViewController.h"

@interface DetalleTipViewController ()

@end

@implementation DetalleTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
    switch (_numTipActual) {
        case 1:
        {
            [_imagenTip setImage:[UIImage imageNamed:@"IconoPolizaRojoAutos"]];
            NSAttributedString *attrString=[[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TipsAutos" withExtension:@"rtf"] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
            [_descripcion setAttributedText:attrString];
            
            NSArray *fontFamilies = [UIFont familyNames];
            
            for (int i = 0; i < [fontFamilies count]; i++)
            {
                NSString *fontFamily = [fontFamilies objectAtIndex:i];
                NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
                NSLog (@"%@: %@", fontFamily, fontNames);
            }

            NSMutableAttributedString *res =[NSMutableAttributedString.alloc initWithFileURL:[ NSBundle.mainBundle URLForResource:@"TipsAutos" withExtension:@"rtf"]
                                                                                     options:nil
                                                                          documentAttributes:nil
                                                                                       error:nil
                                             ];
            [res beginEditing];
           
            __block BOOL found = NO;    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"%@",[(UIFont *)value fontName]);
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size:15.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica-Bold"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size: 17.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    
                    
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [_descripcion setAttributedText:res];
            
        }break;
        case 2:
        {
             [_imagenTip setImage:[UIImage imageNamed:@"IconoPolizaRojoHogar"]];
            NSAttributedString *attrString=[[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TipsHogar" withExtension:@"rtf"] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
            [_descripcion setAttributedText:attrString];
            NSMutableAttributedString *res =[NSMutableAttributedString.alloc initWithFileURL:[ NSBundle.mainBundle URLForResource:@"TipsHogar" withExtension:@"rtf"]
                                                                                     options:nil
                                                                          documentAttributes:nil
                                                                                       error:nil
                                             ];
            [res beginEditing];
            
            __block BOOL found = NO;    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"%@",[(UIFont *)value fontName]);
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size:15.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica-Bold"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size: 17.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    
                    
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [_descripcion setAttributedText:res];
        }break;
        case 3:
        {
             [_imagenTip setImage:[UIImage imageNamed:@"IconoPolizaRojoVida"]];
            NSAttributedString *attrString=[[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TipsVida" withExtension:@"rtf"] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
            [_descripcion setAttributedText:attrString];
            NSMutableAttributedString *res =[NSMutableAttributedString.alloc initWithFileURL:[ NSBundle.mainBundle URLForResource:@"TipsVida" withExtension:@"rtf"]
                                                                                     options:nil
                                                                          documentAttributes:nil
                                                                                       error:nil
                                             ];
            [res beginEditing];
            
            __block BOOL found = NO;    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"%@",[(UIFont *)value fontName]);
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size:15.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica-Bold"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size: 17.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    
                    
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [_descripcion setAttributedText:res];
        }break;
        case 4:
        {
             [_imagenTip setImage:[UIImage imageNamed:@"IconoPolizaRojoGasto"]];
            NSAttributedString *attrString=[[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TipsGastos" withExtension:@"rtf"] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
            [_descripcion setAttributedText:attrString];
            
            NSMutableAttributedString *res =[NSMutableAttributedString.alloc initWithFileURL:[ NSBundle.mainBundle URLForResource:@"TipsGastos" withExtension:@"rtf"]
                                                                                     options:nil
                                                                          documentAttributes:nil
                                                                                       error:nil
                                             ];
            [res beginEditing];
            
            __block BOOL found = NO;    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"%@",[(UIFont *)value fontName]);
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size:15.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica-Bold"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size: 17.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    
                    
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [_descripcion setAttributedText:res];

        }break;
        case 5:
        {
             [_imagenTip setImage:[UIImage imageNamed:@"IconoPolizaRojoEducacion"]];
            NSAttributedString *attrString=[[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TipsEducacion" withExtension:@"rtf"] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
            [_descripcion setAttributedText:attrString];
            NSMutableAttributedString *res =[NSMutableAttributedString.alloc initWithFileURL:[ NSBundle.mainBundle URLForResource:@"TipsEducacion" withExtension:@"rtf"]
                                                                                     options:nil
                                                                          documentAttributes:nil
                                                                                       error:nil
                                             ];
            [res beginEditing];
            
            __block BOOL found = NO;    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"%@",[(UIFont *)value fontName]);
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size:15.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica-Bold"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size: 17.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    
                    
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [_descripcion setAttributedText:res];
        }break;
        case 6:
        {
             [_imagenTip setImage:[UIImage imageNamed:@"IconoPolizaRojoMascota"]];
            NSAttributedString *attrString=[[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TipsMascota" withExtension:@"rtf"] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
            [_descripcion setAttributedText:attrString];
            NSMutableAttributedString *res =[NSMutableAttributedString.alloc initWithFileURL:[ NSBundle.mainBundle URLForResource:@"TipsMascota" withExtension:@"rtf"]
                                                                                     options:nil
                                                                          documentAttributes:nil
                                                                                       error:nil
                                             ];
            [res beginEditing];
            
            __block BOOL found = NO;    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"%@",[(UIFont *)value fontName]);
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size:15.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica-Bold"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size: 17.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    
                    
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [_descripcion setAttributedText:res];
        }break;
        case 7:
        {
             [_imagenTip setImage:[UIImage imageNamed:@"IconoPolizaRojoOtros"]];
            NSAttributedString *attrString=[[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TipsOtro" withExtension:@"rtf"] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
            [_descripcion setAttributedText:attrString];
            NSMutableAttributedString *res =[NSMutableAttributedString.alloc initWithFileURL:[ NSBundle.mainBundle URLForResource:@"TipsOtro" withExtension:@"rtf"]
                                                                                     options:nil
                                                                          documentAttributes:nil
                                                                                       error:nil
                                             ];
            [res beginEditing];
            
            __block BOOL found = NO;    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"%@",[(UIFont *)value fontName]);
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size:15.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    if ([[(UIFont *)value fontName] isEqualToString:@"Helvetica-Bold"]) {
                        UIFont *oldFont = [UIFont fontWithName:@"Oswald-Regular" size: 17.0];
                        UIFont *newFont = oldFont;
                        [res removeAttribute:NSFontAttributeName range:range];
                        [res addAttribute:NSFontAttributeName value:newFont range:range];
                        found = YES;
                    }
                    
                    
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [_descripcion setAttributedText:res];
        }break;
            
        default:
            break;
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
