//
//  VerificacionFechas.h
//  asegura
//
//  Created by Angel  Solsona on 26/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificacionFechas : NSObject

+(BOOL)VerificaPerteneciaRangoFecha:(NSString *)fechaActual fechaInicial:(NSString *)fechaInicial fechaFinal:(NSString *)fechaFinal formatoFecha:(NSString *)formato;

+(BOOL)VerificaFechaesMenor:(NSString *)fechaMenor fechaMayor:(NSString *)fechaMayor  formatoFecha:(NSString *)formato;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+(NSDate *)convierteNSStringToNSDate:(NSString*)cadena Formato:(NSString *)formato;
@end
