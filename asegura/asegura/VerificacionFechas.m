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
    
    const NSTimeInterval interval=[dateFechaActual timeIntervalSinceReferenceDate];
    BOOL pertenece=([dateFechaInicio timeIntervalSinceReferenceDate]<=interval && [dateFechaFinal timeIntervalSinceReferenceDate]>=interval);
    
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
    return [dateFormat dateFromString:cadena];
}



@end
