//
//  NDViewController.m
//  NDObjectiveGuideDemo
//
//  Created by Mikko Virkkilä on 21.9.2013.
//  Copyright (c) 2013 Mikko Virkkilä. All rights reserved.
//

#import <MapKit/MapKit.h>


#import <CoreLocation/CoreLocation.h>

#import <IndoorGuide/IGGuideManager.h>
#import <IndoorGuide/IGMapViewController.h>
#import "NDController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface NDController ()
{
    IGGuideManager* guide;
}

@end


@implementation NDController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"Reload"];
    /* [self reload]; */
    
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Reload"]) {
        [self reload];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"Reload"];
    }
    
}
- (void) reload
{
    guide = [IGGuideManager sharedManager];
    [guide stopUpdates];
    NSString *mapCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"MapCode"];
    NSString *extension = @".ndd";
    if(!mapCode) {
        mapCode=@"elli_build1";
    } else if([[mapCode pathExtension] isEqualToString:@"ndd"]) {
        extension = @"";
    }
    
        mapCode=@"elli_build1";
    
    NSString *mapDataLocation = [NSString stringWithFormat:@"http://192.168.33.204:8080/%@%@", mapCode, extension];
    NSURL *dataUrl = [NSURL URLWithString:mapDataLocation];
    if(dataUrl) {
        [self.mapView startWithNDDUrl:dataUrl];
        self.mapView.panWithLocation = true;
        
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        guide.useAccelerometer = [settings boolForKey:@"EnableAccelerometer"];
        guide.useCompass = [settings boolForKey:@"EnableCompass"];
        guide.useDeviceMotion = [settings boolForKey:@"EnableGyroscope"];
        
        if([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            guide.useIBeaconUUID = [[NSUUID alloc] initWithUUIDString:@"5EC0AE91-3CF2-D989-E311-192F98DADD45"];
        }
        
        [guide startUpdates];
        NSLog(@"Updates started");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Updates started"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        /* Streaming events will cause the library to send the device sensor output to a server */
        if([[NSUserDefaults standardUserDefaults] stringForKey:@"StreamTarget"] &&
           [[NSUserDefaults standardUserDefaults] boolForKey:@"StreamEvents"])
        {
            NSLog(@"Streaming events!");
            [guide startStreamingTo:[[NSUserDefaults standardUserDefaults] stringForKey:@"StreamTarget"]];
        } else {
            [guide stopStreaming];
        }
    } else {
        NSLog(@"Error: NDD file not found, nothing will work.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) mapView:(IGMapView*)mapView didReceiveAction:(NSURL *)url
{
    [super mapView:mapView didReceiveAction:url];
    NSLog(@"Did receive action %@", url);
}

- (void) mapView:(IGMapView*)mapView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed to load map view %@", error);
}


- (void) mapViewDidFinishLoad:(IGMapView*)mapView
{
    [super mapViewDidFinishLoad:mapView];
    
    NSString *keyword = [[NSUserDefaults standardUserDefaults] stringForKey:@"RouteTarget"];
    if(keyword && ![keyword isEqualToString:@" "] &&  ![keyword isEqualToString:@""] ) {
        [guide startRoutingToName: keyword];
        
    }
    
}

-(void)updateDebugView
{
    /* Used just for debugging */
    uint16_t width, height;
    double lat, lon;
    const uint16_t* d = [guide getDebuggingGridWidth:&width height:&height lat:&lat lon:&lon];
    }

-(void)guideManager:(IGGuideManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    /* Use IGMapViewController's default behaviour for map widget */
    [super guideManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    [self updateDebugView];
}

-(void)guideManager:(IGGuideManager *)manager didEnterZone:(uint32_t)zone_id name:(NSString *)name
{
    /* Use IGMapViewController's default behaviour for map widget */
    [super guideManager:manager didEnterZone:zone_id name:name];
    
    //    ---------------------------------
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.6:8888/enterzone"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"PUT"];
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"Response Code: %ld", (long)[urlResponse statusCode]);
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        NSLog(@"Response: %@", result);
    }
    //    ---------------------------------
    
    NSLog(@"Entered zone %@", name);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Entered zone"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

-(void)guideManager:(IGGuideManager *)manager didExitZone:(uint32_t)zone_id name:(NSString *)name
{
    /* Use IGMapViewController's default behaviour for map widget */
    [super guideManager:manager didExitZone:zone_id name:name];
    
    //    ---------------------------------
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.6:8888/exitzone"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"PUT"];
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"Response Code: %ld", (long)[urlResponse statusCode]);
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        NSLog(@"Response: %@", result);
    }
    //    ---------------------------------
    
    
    NSLog(@"Exited zone %@", name);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Exited zone"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
