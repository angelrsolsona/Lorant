//
//  ARSNManagerCalendar.m
//  asegura
//
//  Created by Angel  Solsona on 28/06/15.
//  Copyright (c) 2015 Kelevrads. All rights reserved.
//

#import "ARSNManagerCalendar.h"

@implementation ARSNManagerCalendar

//static EKEventStore *eventStore = nil;

-(void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;
{
    if (_eventStore == nil) {
        _eventStore = [[EKEventStore alloc] init];
        _arrayEventos=[[NSMutableArray alloc] init];
    }
    // request permissions
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
}
-(BOOL)getCalendar{
    BOOL exito;
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"my_calendar_identifier"];
    
    // when identifier exists, my calendar probably already exists
    // note that user can delete my calendar. In that case I have to create it again.
    if (calendarIdentifier) {
        _calendar = [_eventStore calendarWithIdentifier:calendarIdentifier];
    }
    
    // calendar doesn't exist, create it and save it's identifier
    if (!_calendar) {
        // http://stackoverflow.com/questions/7945537/add-a-new-calendar-to-an-ekeventstore-with-eventkit
        _calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_eventStore];
        
        // set calendar name. This is what users will see in their Calendar app
        [_calendar setTitle:@"Lorantmms"];
        
        // find appropriate source type. I'm interested only in local calendars but
        // there are also calendars in iCloud, MS Exchange, ...
        // look for EKSourceType in manual for more options
        for (EKSource *s in _eventStore.sources) {
            if (s.sourceType == EKSourceTypeLocal) {
                _calendar.source = s;
                break;
            }
        }
        
        // save this in NSUserDefaults data for retrieval later
        NSString *calendarIdentifier = [_calendar calendarIdentifier];
        
        NSError *error = nil;
        BOOL saved = [_eventStore saveCalendar:_calendar commit:YES error:&error];
        if (saved) {
            // http://stackoverflow.com/questions/1731530/whats-the-easiest-way-to-persist-data-in-an-iphone-app
            // saved successfuly, store it's identifier in NSUserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:@"my_calendar_identifier"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            exito= YES;
        } else {
            // unable to save calendar
            exito= NO;
        }
    }
    return exito;
}

- (BOOL)addEventAt:(NSDate*)eventDate withTitle:(NSString*)title inLocation:(NSString*)location
{
    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
   
    
    // this shouldn't happen
    if (!_calendar) {
        return NO;
    }
    
    // assign basic information to the event; location is optional
    event.calendar = _calendar;
    event.location = location;
    event.title = title;
    
    // set the start date to the current date/time and the event duration to two hours
    NSDate *startDate = eventDate;
    event.startDate = startDate;
    event.endDate = [startDate dateByAddingTimeInterval:3600 * 2];
    
    NSError *error = nil;
    // save event to the callendar
    BOOL result = [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    if (result) {
        return YES;
    } else {
        // NSLog(@"Error saving event: %@", error);
        // unable to save event to the calendar
        return NO;
    }
}

-(BOOL)addEventAt:(NSDate *)startDate endDate:(NSDate *)endDate withTitle:(NSString *)title allDay:(BOOL)allDay recordatorio:(EKRecurrenceRule *)recurrentRules informacionEvento:(NSMutableDictionary *)informacionEvento{
    
    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
    
    // this shouldn't happen
    if (!_calendar) {
        return NO;
    }
    
    // assign basic information to the event; location is optional
    
    event.calendar = _calendar;
    event.title = title;
    
    // set the start date to the current date/time and the event duration to two hours
    event.startDate = startDate;
    EKAlarm *alarma=[[EKAlarm alloc] init];
    if (!allDay) {
       event.endDate = endDate;
        [alarma setAbsoluteDate:endDate];
    }else{
        [alarma setAbsoluteDate:startDate];
        event.endDate = startDate;
    }
    [event addAlarm:alarma];
    event.allDay=allDay;
    if (recurrentRules!=nil) {
        event.recurrenceRules=@[recurrentRules];
    }
    
    NSError *error = nil;
    // save event to the callendar
    BOOL exito;
    if (![self duplicateEvent:event]) {
        
        BOOL result = [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (result) {
            if (informacionEvento!=nil) {
                NSLog(@"guardar informacion del evento");
                [informacionEvento setObject:event.eventIdentifier forKey:@"idEvento"];
                [_arrayEventos addObject:informacionEvento];
            }
            exito= YES;
        } else {
            NSLog(@"Error saving event: %@ %@", error,[error localizedDescription]);
            // unable to save event to the calendar
            exito = NO;
        }
    }
    
    return exito;
    
}

-(BOOL)addEventAt:(NSDate *)startDate endDate:(NSDate *)endDate withTitle:(NSString *)title allDay:(BOOL)allDay recordatorio:(EKRecurrenceRule *)recurrentRules informacionEvento:(NSMutableDictionary *)informacionEvento withIntervalAlarm:(NSTimeInterval)intervalTimer{
    
    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
    
    // this shouldn't happen
    if (!_calendar) {
        return NO;
    }
    
    // assign basic information to the event; location is optional
    
    event.calendar = _calendar;
    event.title = title;
    
    // set the start date to the current date/time and the event duration to two hours
    event.startDate = startDate;
    EKAlarm *alarma=[[EKAlarm alloc] init];
    if (!allDay) {
        event.endDate = endDate;
        [alarma setRelativeOffset:intervalTimer];
    }else{
        [alarma setRelativeOffset:intervalTimer];
        event.endDate = startDate;
    }
    [event addAlarm:alarma];
    event.allDay=allDay;
    if (recurrentRules!=nil) {
        event.recurrenceRules=@[recurrentRules];
    }
    
    NSError *error = nil;
    // save event to the callendar
    BOOL exito;
    if (![self duplicateEvent:event]) {
        
        BOOL result = [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (result) {
            if (informacionEvento!=nil) {
                NSLog(@"guardar informacion del evento");
                [informacionEvento setObject:event.eventIdentifier forKey:@"idEvento"];
                [_arrayEventos addObject:informacionEvento];
            }
            exito= YES;
        } else {
            NSLog(@"Error saving event: %@ %@", error,[error localizedDescription]);
            // unable to save event to the calendar
            exito = NO;
        }
    }
    
    return exito;
    
}

-(BOOL)removeEventWithIdentifier:(NSString *)idEvent removeFutureEvents:(BOOL)removeFutureEvents{
    BOOL exito=YES;
    EKEvent *event=[_eventStore eventWithIdentifier:idEvent];
    if (event!=nil) {
        NSError *error;
        if (removeFutureEvents) {
            exito=[_eventStore removeEvent:event span:EKSpanFutureEvents commit:YES error:&error];
            NSLog(@"Detalle evento %@ error %@",event.title, [error localizedDescription]);
        }else{
            exito=[_eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
            NSLog(@"detalle evento %@ error %@",event.title, [error localizedDescription]);
        }
        
    }else{
        exito=NO;
    }
    
    return exito;
}

-(BOOL)duplicateEvent:(EKEvent *)event{
    
    NSPredicate *predicate=[_eventStore predicateForEventsWithStartDate:event.startDate endDate:event.endDate calendars:nil];
    NSArray *arrayEventsFound=[_eventStore eventsMatchingPredicate:predicate];
    BOOL existe = NO;
    
    for (EKEvent *eventFond in arrayEventsFound) {
     
        if ([eventFond.title isEqualToString:event.title]) {
            existe=YES;
        }
    }
    
    return existe;
}

@end
