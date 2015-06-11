//
//  MarkerAnotation.m
//  petyful
//
//  Created by Angel  Solsona on 11/07/14.
//  Copyright (c) 2014 Angel Ricardo Solsona Nevero. All rights reserved.
//

#import "AgenciasMarkerAnotation.h"

@implementation AgenciasMarkerAnotation

-(BOOL)isEqual:(id)object{
    AgenciasMarkerAnotation *otherMarker=(AgenciasMarkerAnotation *)object;
    if (self.markerID == otherMarker.markerID) {
        return YES;
    }
    return NO;
}
-(NSUInteger)hash{
    return [self.markerID hash];
}


@end
