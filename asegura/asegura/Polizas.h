//
//  Polizas.h
//  asegura
//
//  Created by Angel  Solsona on 26/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Polizas : NSManagedObject

@property (nonatomic, retain) NSString * banco;
@property (nonatomic, retain) NSString * diaPago;
@property (nonatomic, retain) NSData * foto;
@property (nonatomic, retain) NSString * intrumentoPago;
@property (nonatomic, retain) NSString * noPoliza;
@property (nonatomic, retain) NSString * observaciones;
@property (nonatomic, retain) NSString * recordadDiaPago;
@property (nonatomic, retain) NSString * recordatorioFin;
@property (nonatomic, retain) NSString * recordatorioInicio;
@property (nonatomic, retain) NSNumber * recordarVigencia;
@property (nonatomic, retain) NSString * fechaInicioVigencia;
@property (nonatomic, retain) NSString * fechaFinVigencia;

@end
