//
//  MarkerAnotation.h
//  petyful
//
//  Created by Angel  Solsona on 11/07/14.
//  Copyright (c) 2014 Angel Ricardo Solsona Nevero. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface AgenciasMarkerAnotation : GMSMarker

@property(nonatomic,copy)NSString *markerID;
@property(strong,nonatomic)NSString *nombreAgencia;
@property(strong,nonatomic)NSString *telefono;
@property(assign,nonatomic)CGFloat latitud;
@property(assign,nonatomic)CGFloat longitud;
@property(strong,nonatomic)NSString *correo;
@property(strong,nonatomic)NSString *distancia;
@property(strong,nonatomic)NSString *domicilio;
@property(strong,nonatomic)NSString *cp;
@property(strong,nonatomic)NSString *correo1;
@end
