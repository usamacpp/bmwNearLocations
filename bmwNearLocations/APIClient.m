//
//  APIClient.m
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

-(void)searchNearLocations {
    
    NSURL *url = [NSURL URLWithString:@"http://localsearch.azurewebsites.net/api/Locations"];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate searchFailed];
            });
        } else {
            
            NSError *err = nil;
            NSMutableArray *locs = [NSMutableArray new];
            NSArray *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            
            for (NSDictionary *locDic in res) {
                
                nearLocation *nloc = [nearLocation new];
                
                nloc.ID = [[locDic valueForKey:@"ID"] integerValue];
                nloc.Name = [locDic valueForKey:@"Name"];
                nloc.Latitude = [[locDic valueForKey:@"Latitude"] doubleValue];
                nloc.Longtiude = [[locDic valueForKey:@"Longitude"] doubleValue];
                nloc.Address = [locDic valueForKey:@"Address"];
                nloc.arriveTime = [locDic valueForKey:@"ArrivalTime"];
                
                [locs addObject:nloc];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate searchSucceeded:[locs copy]];
            });
        }
        
    }] resume];
}

@end
