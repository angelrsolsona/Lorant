//
//  VerificacionFechas.m
//  asegura
//
//  Created by Angel  Solsona on 26/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "VerificacionFechas.h"

@implementation VerificacionFechas

+(BOOL)VerificaPerteneciaRangoFecha:(NSString *)fechaActual fechaInicial:(NSString *)fechaInicial fechaFinal:(NSString *)fechaFinal formatoFecha:(NSString *)formato{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formato];
    NSDate *dateFechaActual=[[NSDate alloc] init];
    NSDate *dateFechaInicio=[[NSDate alloc] init];
    NSDate *dateFechaFinal=[[NSDate alloc] init];
    dateFechaActual=[dateFormat dateFromString:fechaActual];
    dateFechaInicio=[dateFormat dateFromString:fechaInicial];
    dateFechaFinal=[dateFormat dateFromString:fechaFinal];
    
    BOOL pertenece= (([dateFechaActual compare:dateFechaInicio] != NSOrderedAscending) && ([dateFechaActual compare:dateFechaFinal] != NSOrderedDescending));

    
    
    return pertenece;
    
}

+(BOOL)VerificaFechaesMenor:(NSString *)fechaMenor fechaMayor:(NSString *)fechaMayor  formatoFecha:(NSString *)formato{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formato];
    NSDate *dateFechaMenor=[[NSDate alloc] init];
    NSDate *dateFechaMayor=[[NSDate alloc] init];
    dateFechaMenor=[dateFormat dateFromString:fechaMenor];
    dateFechaMayor=[dateFormat dateFromString:fechaMayor];
    NSComparisonResult result=[dateFechaMenor compare:dateFechaMayor];
     BOOL pertenece;
    switch (result) {
        case NSOrderedAscending:
        {
            pertenece=YES;
        }break;
        case NSOrderedDescending:
        {
            pertenece=NO;
        }break;
        case NSOrderedSame:
        {
            pertenece=NO;
            
        }break;
        default:
            break;
    }
   
    
    
    
    return pertenece;
    
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
+(NSDate *)convierteNSStringToNSDate:(NSString*)cadena Formato:(NSString *)formato{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formato];
    NSDate *nsdate=[[NSDate alloc] init];
     nsdate=[dateFormat dateFromString:cadena];
    return nsdate;
}

+(NSString *)transformaNSDatetoString:(NSDate *)date formato:(NSString *)formato{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formato];
    return [dateFormat stringFromDate:date];
}

+(NSString *)obtenerFechaTipo:(TipoFecha)tipoFecha cadena:(NSString *)fecha separador:(NSString *)separador{
    NSArray *split=[fecha componentsSeparatedByString:separador];
    NSString *cadena=@"";
    if ([split count]>0) {
        switch (tipoFecha) {
            case DIA_MES:
            {
                cadena=[NSString stringWithFormat:@"%@%@%@",[split objectAtIndex:0],separador,[split objectAtIndex:1]];
            }break;
            case DIA_ANIO:
            {
                cadena=[NSString stringWithFormat:@"%@%@%@",[split objectAtIndex:0],separador,[split objectAtIndex:2]];
            }break;
            case MES_ANIO:
            {
                cadena=[NSString stringWithFormat:@"%@%@%@",[split objectAtIndex:1],separador,[split objectAtIndex:2]];
            }break;
            case DIA_MES_ANIO:
            {
                cadena=[NSString stringWithFormat:@"%@%@%@%@%@",[split objectAtIndex:0],separador,[split objectAtIndex:1],separador,[VerificacionFechas transformaNSDatetoString:[NSDate date] formato:@"yyyy"]];
            }
            default:
                break;
        }

    }
    
    return cadena;
    
}



@end
