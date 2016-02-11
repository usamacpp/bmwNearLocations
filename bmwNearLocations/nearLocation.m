//
//  nearLocation.m
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import "nearLocation.h"

@implementation nearLocation

-(NSString*)description {
    NSMutableString *string = [NSMutableString new];
    
    [string appendFormat:@"{\n\tID = %ld\n", _ID];
    [string appendFormat:@"\tName = %@\n", _Name];
    [string appendFormat:@"\tName = %@\n", _Address];
    [string appendFormat:@"\tName = %f\n", _Latitude];
    [string appendFormat:@"\tName = %f\n", _Longtiude];
    [string appendFormat:@"\tarriveTime = %@\n}", _arriveTime];
    
    return string;
}

-(NSDate*)getArriveDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
    return [dateFormatter dateFromString:_arriveTime];
}

-(void)distanceToLocation:(CLLocationCoordinate2D)loc {
    
    NSString *strRequest = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving",_Latitude, _Longtiude, loc.latitude, loc.longitude];
    NSURL *url = [NSURL URLWithString:strRequest];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data == nil || error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate distanceUpdated:self];
            });
        }
        
        NSError *err = nil;
        
        @try {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            
            if (err != nil)
                return;
            
            int dist = [[[[[[[json valueForKey:@"rows"] objectAtIndex:0] valueForKey:@"elements"] objectAtIndex:0] valueForKey:@"distance"] valueForKey:@"value"] intValue];
            
            _distance = [NSNumber numberWithInt:dist];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate distanceUpdated:self];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate distanceUpdateFailed:self];
            });
        }
    }] resume];
}

@end
