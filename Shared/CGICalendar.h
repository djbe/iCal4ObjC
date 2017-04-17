//
//  CGICalendar.h
//
//  Created by Satoshi Konno on 11/01/28.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CGICalendarObject.h"
#import "NSDate+CGICalendar.h"
#import "CGICalendarComponent.h"
#import "CGICalendarProperty.h"

extern NSString * const CGICalendarHeaderContentline;
extern NSString * const CGICalendarFooterContentline;

@interface CGICalendar : NSObject

@property (nonatomic, strong) NSMutableArray *objects;

+ (NSString *)UUID;

- (id)init;
- (id)initWithString:(NSString *)string;
- (id)initWithPath:(NSString *)path;

- (BOOL)parseWithString:(NSString *)string  error:(NSError **)error;
- (BOOL)parseWithPath:(NSString *)path  error:(NSError **)error;

- (void)addObject:(CGICalendarObject *)object;
- (CGICalendarObject *)objectAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSString *description;
+ (NSString *)unescape:(NSString *)aValue;

- (BOOL)writeToFile:(NSString *)path;

@end
