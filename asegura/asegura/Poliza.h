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
@property(strong,nonatomic) NSString *insuranceName;
@property(strong,nonatomic) NSString *insurenceNumber;
@property(strong,nonatomic) NSString *fechaHasta;
@property(assign,nonatomic) NSInteger ramo;
@property(assign,nonatomic) NSInteger idAseguradora;
@property(assign,nonatomic) NSString *noPlacas;
@property(assign,nonatomic) NSString *ownerName;
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

















@end
