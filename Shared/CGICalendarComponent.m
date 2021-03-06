//
//  CGICalendarComponent.m
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "CGICalendar.h"
#import "CGICalendarComponent.h"
#import "CGICalendarContentLine.h"
#import "NSDate+CGICalendar.h"

NSString * const CGICalendarComponentTypeEvent = @"VEVENT";
NSString * const CGICalendarComponentTypeTodo = @"VTODO";
NSString * const CGICalendarComponentTypeJournal = @"VJOURNAL";
NSString * const CGICalendarComponentTypeFreebusy = @"VFREEBUSY";
NSString * const CGICalendarComponentTypeTimezone = @"VTIMEZONE";
NSString * const CGICalendarComponentTypeAlarm = @"VALARM";

NSUInteger const CGICalendarComponentSequenceDefault = 0;

@implementation CGICalendarComponent

#pragma mark -
#pragma mark Global methods

+ (id)componentWithType:(NSString *)aType {
	return [[CGICalendarComponent alloc] initWithType: aType];
}

+ (id)event {
	CGICalendarComponent *icalComp = [CGICalendarComponent componentWithType: CGICalendarComponentTypeEvent];
	icalComp.UID = CGICalendar.UUID;
	icalComp.dateTimeStamp = NSDate.date;
	icalComp.sequenceNumber = CGICalendarComponentSequenceDefault;
	return icalComp;
}

+ (id)todo {
	CGICalendarComponent *icalComp = [CGICalendarComponent componentWithType: CGICalendarComponentTypeTodo];
	icalComp.UID = CGICalendar.UUID;
	icalComp.dateTimeStamp = NSDate.date;
	icalComp.sequenceNumber = CGICalendarComponentSequenceDefault;
	icalComp.created = NSDate.date;
	return icalComp;
}

+ (id)journal {
	CGICalendarComponent *icalComp = [CGICalendarComponent componentWithType: CGICalendarComponentTypeJournal];
	icalComp.UID = CGICalendar.UUID;
	icalComp.dateTimeStamp = NSDate.date;
	icalComp.sequenceNumber = CGICalendarComponentSequenceDefault;
	return icalComp;
}

+ (id)freebusy {
	CGICalendarComponent *icalComp = [CGICalendarComponent componentWithType: CGICalendarComponentTypeFreebusy];
	icalComp.UID = CGICalendar.UUID;
	icalComp.dateTimeStamp = NSDate.date;
	return icalComp;
}

+ (id)timezone {
	CGICalendarComponent *icalComp = [CGICalendarComponent componentWithType: CGICalendarComponentTypeTimezone];
	return icalComp;
}

+ (id)alarm {
	CGICalendarComponent *icalComp = [CGICalendarComponent componentWithType: CGICalendarComponentTypeAlarm];
	return icalComp;
}

#pragma mark -
#pragma mark init

- (id)init {
	if ((self = [super init])) {
		self.components = [NSMutableArray array];
		self.properties = [NSMutableArray array];
	}
	return self;
}

- (id)initWithType:(NSString *)aType {
	if ((self = [self init])) {
		self.type = aType;
	}
	return self;
}

#pragma mark -
#pragma mark Component

- (void)addComponent:(CGICalendarComponent *)component {
	[self.components addObject: component];
}

- (void)insertComponent:(CGICalendarComponent *)component atIndex:(NSUInteger)index {
	[self.components insertObject: component atIndex: index];
}

- (CGICalendarComponent *)componentAtIndex:(NSUInteger)index {
	return self.components[index];
}

- (NSUInteger)indexOfComponent:(CGICalendarComponent *)component {
	return [self.components indexOfObject: component];
}

- (void)removeComponent:(CGICalendarComponent *)component {
	[self.components removeObject: component];
}

- (void)removeComponentAtIndex:(NSUInteger)index {
	[self.components removeObjectAtIndex: index];
}

#pragma mark -
#pragma mark Property

- (BOOL)hasPropertyForName:(NSString *)name {
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: name])
			return YES;

	return NO;
}

- (void)addProperty:(CGICalendarProperty *)property {
	[self.properties addObject: property];
}

- (void)removePropertyForName:(NSString *)name {
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: name]) {
			[self.properties removeObject: icalProp];
			return;
		}
}

- (void)setPropertyValue:(NSString *)value forName:(NSString *)name {
	[self setPropertyValue: value forName: name parameterValues: @[] parameterNames: @[]];
}

- (void)setPropertyValue:(NSString *)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	CGICalendarProperty *icalProp = [self propertyForName: name];
	if (!icalProp) {
		icalProp = [CGICalendarProperty new];
		icalProp.name = name;
		[self addProperty: icalProp];
	}
	icalProp.value = value;
	if (parameterValues.count != parameterNames.count)
		return;
	for (NSUInteger n = 0; n < parameterNames.count; n++) {
		NSString *name = parameterNames[n];
		id value = parameterNames[n];
		[icalProp setParameterObject: value forName: name];
	}
}

- (void)setPropertyObject:(id)object forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setPropertyValue: [object description] forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (void)setPropertyObject:(id)object forName:(NSString *)name {
	[self setPropertyValue: [object description] forName: name];
}

- (void)setPropertyDate:(NSDate *)object forName:(NSString *)name {
	[self setPropertyValue: object.descriptionICalendar forName: name];
}

- (void)setPropertyDate:(NSDate *)object forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setPropertyValue: object.descriptionICalendar forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (void)setPropertyInteger:(NSInteger)value forName:(NSString *)name {
	[self setPropertyValue: @(value).stringValue forName: name];
}

- (void)setPropertyInteger:(NSInteger)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setPropertyValue: @(value).stringValue forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (void)setPropertyFloat:(float)value forName:(NSString *)name {
	[self setPropertyValue: @(value).stringValue forName: name];
}

- (void)setPropertyFloat:(float)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setPropertyValue: @(value).stringValue forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (id)propertyAtIndex:(NSUInteger)index {
	return self.properties[index];
}

- (CGICalendarProperty *)propertyForName:(NSString *)name {
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: name])
			return icalProp;

	return nil;
}

- (NSArray *)allPropertyKeys {
	NSMutableArray *keys = [NSMutableArray array];
	for (CGICalendarProperty *icalProp in self.properties)
		[keys addObject: icalProp.name];

	return keys;
}

- (NSString *)propertyValueForName:(NSString *)name {
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: name])
			return icalProp.value;

	return nil;
}

- (NSDate *)propertyDateForName:(NSString *)name {
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: name])
			return icalProp.dateValue;

	return nil;
}

- (NSInteger)propertyIntegerForName:(NSString *)name {
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: name])
			return icalProp.integerValue;

	return 0;
}

- (float)propertyFloatForName:(NSString *)name {
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: name])
			return icalProp.floatValue;

	return 0;
}

#pragma mark -
#pragma mark String

- (BOOL)isType:(NSString *)aType {
	return [aType isEqualToString: self.type];
}

- (BOOL)isEvent {
	return [self isType: CGICalendarComponentTypeEvent];
}

- (BOOL)isTodo {
	return [self isType: CGICalendarComponentTypeTodo];
}

- (BOOL)isJournal {
	return [self isType: CGICalendarComponentTypeJournal];
}

- (BOOL)isFreebusy {
	return [self isType: CGICalendarComponentTypeFreebusy];
}

- (BOOL)isTimezone {
	return [self isType: CGICalendarComponentTypeTimezone];
}

- (BOOL)isAlarm {
	return [self isType: CGICalendarComponentTypeAlarm];
}

-(BOOL)isFullDay {
	// CG_ICALENDAR_PROERTY_DTSTART
	for (CGICalendarProperty *icalProp in self.properties)
		if ([icalProp isName: CGICalendarPropertyDtstart])
			if (icalProp.parameters.count > 0) {
				CGICalendarParameter * param = icalProp.parameters.lastObject;
				return (param.hasName && param.hasValue &&
						([param.name compare: @"VALUE"] == NSOrderedSame) &&
						([param.value compare: @"DATE"] == NSOrderedSame));
			}

	return NO;
}

#pragma mark -
#pragma mark String

NSString * const CGICalendarContentlineNameBegin = @"BEGIN";
NSString * const CGICalendarContentlineNameEnd = @"END";

- (NSString *)description {
	NSMutableString *objectsString = [NSMutableString string];
	[objectsString appendFormat: @"%@:%@%@", CGICalendarContentlineNameBegin, self.type, CGICalendarContentlineTerm];
	for (CGICalendarProperty *icalProp in self.properties)
		[objectsString appendString: icalProp.description];
	for (CGICalendarComponent *icalComp in self.components)
		[objectsString appendString: icalComp.description];
	[objectsString appendFormat:@"%@:%@%@", CGICalendarContentlineNameEnd, self.type, CGICalendarContentlineTerm];
	return objectsString;
}

#pragma mark -
#pragma mark 4.2.12 Participation Status

- (void)setParticipationStatus:(NSInteger)status {
	[self setPropertyInteger: status forName: CGICalendarPropertyPartstat];
}

- (NSInteger)participationStatus {
	CGICalendarProperty *icalProp = [self propertyForName: CGICalendarPropertyPartstat];
	if (!icalProp)
		return CGICalendarParticipationStatusUnkown;

	return icalProp.participationStatus;
}

#pragma mark -
#pragma mark 4.8.1.5 Description

- (void)setNotes:(NSString *)value {
	[self setPropertyValue: value forName: CGICalendarPropertyDescription];
}

- (NSString *)notes {
	return [self propertyValueForName: CGICalendarPropertyDescription];
}

#pragma mark -
#pragma mark 4.8.1.7 Location

- (void)setLocation:(NSString *)value {
	[self setPropertyValue: value forName: CGICalendarPropertyLocation];
}

- (NSString *)location {
	return [self propertyValueForName: CGICalendarPropertyLocation];
}

#pragma mark -
#pragma mark 4.8.1.9 Priority

- (void)setPriority:(NSUInteger)value {
	[self setPropertyInteger: (NSInteger)value forName: CGICalendarPropertyPriority];
}

- (NSUInteger)priority {
	return [self propertyIntegerForName: CGICalendarPropertyPriority];
}

#pragma mark -
#pragma mark 4.8.1.12 Summary

- (void)setSummary:(NSString *)value {
	[self setPropertyValue: value forName: CGICalendarPropertySummary];
}

- (NSString *)summary {
	return [self propertyValueForName: CGICalendarPropertySummary];
}

#pragma mark -
#pragma mark 4.8.2.1 Date/Time Completed

- (void)setCompleted:(NSDate *)value {
	[self setPropertyDate: value forName: CGICalendarPropertyCompleted];
}

- (NSDate *)completed {
	return [self propertyDateForName: CGICalendarPropertyCompleted];
}

#pragma mark -
#pragma mark 4.8.2.2 Date/Time End

- (void)setDateTimeEnd:(NSDate *)value {
	[self setPropertyDate: value forName: CGICalendarPropertyDtend];
}

- (NSDate *)dateTimeEnd {
	return [self propertyDateForName: CGICalendarPropertyDtend];
}

#pragma mark -
#pragma mark 4.8.2.3 Date/Time Due

- (void)setDue:(NSDate *)value {
	[self setPropertyDate: value forName: CGICalendarPropertyDue];
}

- (NSDate *)due {
	return [self propertyDateForName: CGICalendarPropertyDue];
}

#pragma mark -
#pragma mark 4.8.2.4 Date/Time Start

- (void)setDateTimeStart:(NSDate *)value {
	[self setPropertyDate: value forName: CGICalendarPropertyDtstart];
}

- (NSDate *)dateTimeStart {
	return [self propertyDateForName: CGICalendarPropertyDtstart];
}

#pragma mark -
#pragma mark 4.8.4.7 Unique Identifier

- (void)setUID:(NSString *)value {
	[self setPropertyValue: value forName: CGICalendarPropertyUid];
}

- (NSString *)UID {
	return [self propertyValueForName: CGICalendarPropertyUid];
}

#pragma mark -
#pragma mark 4.8.7.1 Date/Time Created

- (void)setCreated:(NSDate *)value {
	[self setPropertyDate: value forName: CGICalendarPropertyCreated];
}

- (NSDate *)created {
	return [self propertyDateForName: CGICalendarPropertyCreated];
}

#pragma mark -
#pragma mark 4.8.7.2 Date/Time Stamp

- (void)setDateTimeStamp:(NSDate *)value {
	[self setPropertyDate: value forName: CGICalendarPropertyDtstamp];
}

- (NSDate *)dateTimeStamp {
	return [self propertyDateForName: CGICalendarPropertyDtstamp];
}

#pragma mark -
#pragma mark 4.8.7.3 Last Modified

- (void)setLastModified:(NSDate *)value {
	[self setPropertyDate: value forName: CGICalendarPropertyLastModified];
}

- (NSDate *)lastModified {
	return [self propertyDateForName: CGICalendarPropertyLastModified];
}

#pragma mark -
#pragma mark 4.8.7.4 Sequence Number

- (void)setSequenceNumber:(NSUInteger)value {
	[self setPropertyInteger: value forName: CGICalendarPropertySequence];
}

- (NSUInteger)sequenceNumber {
	return [self propertyIntegerForName: CGICalendarPropertySequence];
}

- (void)incrementSequenceNumber {
	self.sequenceNumber++;
}

@end
