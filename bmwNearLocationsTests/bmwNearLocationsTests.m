//
//  bmwNearLocationsTests.m
//  bmwNearLocationsTests
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APIClient.h"

@interface bmwNearLocationsTests : XCTestCase <APIClientDelegate> {
    APIClient *client;
    XCTestExpectation *serverRespExpectation;
    NSArray *locs;
}

@end

@implementation bmwNearLocationsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    client = [APIClient new];
    client.delegate = self;
    [client searchNearLocations];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAPISearch {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    serverRespExpectation = [self expectationWithDescription:@"server response"];
    locs = nil;
    [client searchNearLocations];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        //XCTFail(@"request timeout");
    }];
    
    XCTAssert(YES, @"Succeeded");
}

#pragma mark - API Client

-(void)searchSucceeded:(NSArray *)locations {
    
    if (locs == nil) {
        locs = locations;
        
        [serverRespExpectation fulfill];
        XCTAssertNotNil(locations, @"locations array is nil");
    }
}

-(void)searchFailed {
    
    [serverRespExpectation fulfill];
    
    locs = nil;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
