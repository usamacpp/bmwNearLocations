//
//  APIClient.h
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nearLocation.h"

@protocol APIClientDelegate <NSObject>

-(void)searchSucceeded:(NSArray*)locations;
-(void)searchFailed;

@end

@interface APIClient : NSObject

@property (weak, nonatomic) id<APIClientDelegate> delegate;

-(void)searchNearLocations;

@end
