//
//  VerificacionFechas.h
//  asegura
//
//  Created by Angel  Solsona on 26/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificacionFechas : NSObject

typedef NS_OPTIONS(NSUInteger, TipoFecha){
    DIA_MES=1,
    DIA_ANIO=2,
    MES_ANIO=3,
    DIA_MES_ANIO=4
};

+(BOOL)VerificaPerteneciaRangoFecha:(NSString *)fechaActual fechaInicial:(NSString *)fechaInicial fechaFinal:(NSString *)fechaFinal formatoFecha:(NSString *)formato;

+(BOOL)VerificaFechaesMenor:(NSString *)fechaMenor fechaMayor:(NSString *)fechaMayor  formatoFecha:(NSString *)formato;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+(NSDate *)convierteNSStringToNSDate:(NSString*)cadena Formato:(NSString *)formato;
+(NSString *)transformaNSDatetoString:(NSDate *)date formato:(NSString *)formato;
+(NSString *)obtenerFechaTipo:(TipoFecha)tipoFecha cadena:(NSString *)fecha separador:(NSString *)separador;
@end
