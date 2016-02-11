//
//  ViewController.m
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import "searchoutTableViewController.h"

@interface searchoutTableViewController ()

@end

@implementation searchoutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //setup gps location manager
    locm = [CLLocationManager new];
    [locm requestWhenInUseAuthorization];
    locm.delegate = self;
    locm.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locm.distanceFilter = 100;
    
    [locm startUpdatingLocation];
    
    seg = [UISegmentedControl new];
    
    [seg setBackgroundColor:[UIColor whiteColor]];
    
    [seg insertSegmentWithTitle:@"Name" atIndex:0 animated:NO];
    [seg insertSegmentWithTitle:@"Distance" atIndex:1 animated:NO];
    [seg insertSegmentWithTitle:@"Arrival Time" atIndex:2 animated:NO];
    
    [seg addTarget:self action:@selector(sortSelectChanged) forControlEvents:UIControlEventValueChanged];
    
    [seg setSelectedSegmentIndex:0];
    
    client = [APIClient new];
    client.delegate = self;
    
    [self refreshList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sortSelectChanged {
    
    NSLog(@"sort seg index = %ld", seg.selectedSegmentIndex);
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    locs = [locs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        nearLocation *loc1 = obj1;
        nearLocation *loc2 = obj2;
        
        switch (seg.selectedSegmentIndex) {
            case 0:
                return [loc1.Name compare:loc2.Name];
            case 1:
                
                if (currLocation != nil) {
                    if ([loc1.distance intValue] < [loc2.distance intValue])
                        return NSOrderedAscending;
                    
                    if ([loc1.distance intValue] > [loc2.distance intValue])
                        return NSOrderedDescending;
                    
                    return NSOrderedSame;
                } else
                    return [loc1.Name compare:loc2.Name];
                
            case 2:
                return [[loc1 getArriveDate] compare:[loc2 getArriveDate]];
                
            default:
                return NSOrderedSame;
        }
        
        return NSOrderedSame;
    }];
    
    [self.tableView reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
}

-(IBAction)refreshList {
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    [locm startUpdatingLocation];
    [client searchNearLocations];
}

#pragma mark - location manager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    @try {
        [locm stopUpdatingLocation];
        
        CLLocation *loc = [locations objectAtIndex:0];
        
        currLocation = loc;
        
        if (((nearLocation*)[locs objectAtIndex:0]).distance == nil) {
            for (int i = 0; i < locs.count; i++) {
                ((nearLocation*)[locs objectAtIndex:i]).delegate = self;
                [[locs objectAtIndex:i] distanceToLocation:currLocation.coordinate];
            }
        }
        
        if (seg.selectedSegmentIndex == 1 && locs) {
            [self sortSelectChanged];
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location update error");
    
    [self showErrorMessage:@"Current lcation update failed!"];
}

#pragma mark - tablew view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (locs != nil)
        return locs.count;
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (locs == nil)
        return nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    nearLocation *nloc = [locs objectAtIndex:indexPath.row];
    cell.textLabel.text = nloc.Name;
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            cell.detailTextLabel.text = @"";
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance = %d", nloc.distance.intValue];
            break;
        case 2:
            cell.detailTextLabel.text = nloc.arriveTime;
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - table view delegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [seg setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    return seg;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

#pragma mark - API Client

-(void)searchSucceeded:(NSArray *)locations {
    
    locs = [locations copy];
    [self sortSelectChanged];
    
    if (currLocation != nil) {
        for (int i = 0; i < locs.count; i++) {
            ((nearLocation*)[locs objectAtIndex:i]).delegate = self;
            [[locs objectAtIndex:i] distanceToLocation:currLocation.coordinate];
        }
    }
    
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
}

-(void)searchFailed {
    
    NSLog(@"api call failed");
    
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    
    locs = nil;
    [self.tableView reloadData];
    
    [self showErrorMessage:@"API cloud request did not succeed\nPlease try again"];
}

#pragma mark - nearLocation

-(void)distanceUpdated:(nearLocation *)nloc {
    
    NSLog(@"distance value changed");
    
    if (seg.selectedSegmentIndex == 1)
        [self sortSelectChanged];
}

-(void)distanceUpdateFailed:(nearLocation *)nloc {
    [self showErrorMessage:@"distance calc failed!"];
}

#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indx = [self.tableView indexPathForCell:sender];
    
    [(detailsViewController*)segue.destinationViewController setValue:[locs objectAtIndex:indx.row] forKey:@"loc"];
}

#pragma mark - generic methods

-(void)showErrorMessage:(NSString*)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

@end
