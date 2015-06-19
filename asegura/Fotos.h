//
//  Fotos.h
//  asegura
//
//  Created by Angel  Solsona on 18/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Fotos : NSManagedObject

@property (nonatomic, retain) NSString * noPoliza;
@property (nonatomic, retain) NSData * foto;

@end
