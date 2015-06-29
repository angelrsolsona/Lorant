//
//  ARSNManagerCalendar.h
//  asegura
//
//  Created by Angel  Solsona on 28/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ARSNManagerCalendar : NSObject

@property(strong,nonatomic)EKEventStore *eventStore;
@property(strong,nonatomic)EKCalendar *calendar;
@property(strong,nonatomic)NSMutableArray *arrayEventos;

- (void)requestAccess:(void (^)(BOOL granted, NSError *error))success;
- (BOOL)addEventAt:(NSDate*)eventDate withTitle:(NSString*)title inLocation:(NSString*)location;
-(BOOL)addEventAt:(NSDate *)startDate endDate:(NSDate *)endDate withTitle:(NSString *)title allDay:(BOOL)allDay recordatorio:(EKRecurrenceRule *)recurrentRules informacionEvento:(NSDictionary *)informacionEvento;
-(BOOL)addEventAt:(NSDate *)startDate endDate:(NSDate *)endDate withTitle:(NSString *)title allDay:(BOOL)allDay recordatorio:(EKRecurrenceRule *)recurrentRules informacionEvento:(NSMutableDictionary *)informacionEvento withIntervalAlarm:(NSTimeInterval)intervalTimer;
-(BOOL)removeEventWithIdentifier:(NSString *)idEvent removeFutureEvents:(BOOL)removeFutureEvents;
-(BOOL)duplicateEvent:(EKEvent *)event;
-(BOOL)getCalendar;
@end
