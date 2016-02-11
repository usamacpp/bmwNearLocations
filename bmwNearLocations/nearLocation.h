//
//  nearLocation.h
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class nearLocation;

@protocol nearLocationDelegate <NSObject>

-(void)distanceUpdated:(nearLocation*)nloc;
-(void)distanceUpdateFailed:(nearLocation*)nloc;

@end

@interface nearLocation : NSObject

@property (assign) NSInteger ID;
@property (nonatomic, strong) NSString *Name;
@property (assign) double Latitude;
@property (assign) double Longtiude;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *arriveTime;

@property (assign) NSNumber *distance;
@property (weak, nonatomic) id<nearLocationDelegate> delegate;

-(NSDate*)getArriveDate;
-(void)distanceToLocation:(CLLocationCoordinate2D)loc;

@end
