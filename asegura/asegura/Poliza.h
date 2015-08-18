//
//  Poliza.h
//  asegura
//
//  Created by Angel  Solsona on 04/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poliza.h"
@interface Poliza : NSObject

@property(assign,nonatomic) NSInteger idPoliza;
@property(assign,nonatomic) NSInteger idPolizaM;
@property(strong,nonatomic) NSString *insuranceName;
@property(strong,nonatomic) NSString *insurenceNumber;
@property(strong,nonatomic) NSString *insurenceAlias;
@property(strong,nonatomic) NSString *fechaHasta;
@property(assign,nonatomic) NSInteger ramo;
@property(assign,nonatomic) NSInteger idAseguradora;
@property(strong,nonatomic) NSString *noPlacas;
@property(strong,nonatomic) NSString *ownerName;
@property(strong,nonatomic) NSString *startDate;
@property(strong,nonatomic) NSString *endDate;
@property(strong,nonatomic) NSString *contactMail;
@property(strong,nonatomic) NSString *contactPhoneNumber;
@property(strong,nonatomic) NSString *nombreAseguradora;
@property(strong,nonatomic) NSString *numeroSerie;
@property(strong,nonatomic) NSString *descripcion;
@property(strong,nonatomic) NSMutableArray *coberturas;
@property(strong,nonatomic) NSMutableArray *productDetail;
@property(strong,nonatomic) NSString *formaPago;
@property(strong,nonatomic) NSString *paquete;
@property(assign,nonatomic) NSInteger idSistema;
@property(strong,nonatomic) NSString *contratadoCon;
@property(strong,nonatomic) NSString *telefonoCabina;
@property(assign,nonatomic) NSInteger idPolizaSistema;
@property(assign,nonatomic) BOOL reportarSiniestro;
@property(assign,nonatomic) BOOL esFinanciera;
@property(strong,nonatomic) NSString *numContrato;

@property(strong,nonatomic)NSString *instrumentoPago;
@property(strong,nonatomic)NSString *banco;
@property(strong,nonatomic)NSString *diaPago;
@property(strong,nonatomic)NSString *observacion;
@property(strong,nonatomic)NSString *recordatorioPagoInicio;
@property(strong,nonatomic)NSString *recordatorioPagoFin;
@property(assign,nonatomic)BOOL recordatorioPago;
@property(strong,nonatomic)NSData *foto;
@property(assign,nonatomic)BOOL recordarVigencia;

@property(assign,nonatomic)BOOL tieneMasInformacion;

@property(assign,nonatomic)BOOL tieneVerificacion;
@property(strong,nonatomic)NSString *perido1;
@property(strong,nonatomic)NSString *perido2;
@property(strong,nonatomic)NSString *calcomania;
@property(strong,nonatomic)NSString *fechaInicioPeriodo1;
@property(strong,nonatomic)NSString *fechaFinPeriodo1;
@property(strong,nonatomic)NSString *fechaInicioPeriodo2;
@property(strong,nonatomic)NSString *fechaFinPeriodo2;





















@end
