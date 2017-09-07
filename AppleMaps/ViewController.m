//
//  ViewController.m
//  AppleMaps
//
//  Created by kishore kumar nagalla on 04/09/17.
//  Copyright © 2017 Pyramid SoftSol. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotation.h"

@import MapKit;
@import CoreLocation;

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>{
    CLLocationCoordinate2D currentLocation;
    CLLocationManager *manager;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    //errors:
    //'NSInvalidUnarchiveOperationException', reason: 'Could not instantiate class named MKMapView'
    // ans: link the mapkit framwork otherwise it will not load maps
    
    // Core location could not work as request for authorizarion and put in plist privacy policy
    
    // rightcalloutaccessary view is not show   MKPinAnnotationView *view = nil; if you put button type custom, frame is also not need
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    
    
    manager = [[CLLocationManager alloc]init];
    [manager requestAlwaysAuthorization];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = kCLLocationAccuracyKilometer;
    manager.delegate = self;
    
    [manager startUpdatingLocation];
    
    
    
    CLLocationCoordinate2D coOrdinate =  CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
    
    [self upDateMapRegion:coOrdinate];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - mapView delegates

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    MKPinAnnotationView *view = nil;
    
    if ([annotation isKindOfClass:[MyAnnotation class]]) {

        view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"id"];
        if (view == nil) {
            view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"id"];
            view.animatesDrop = YES;
            view.canShowCallout = YES;

           UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
          //  button.frame = CGRectMake(0, 0, 30, 30);
            [button addTarget:self action:@selector(getDirections) forControlEvents:UIControlEventTouchUpInside];
            view.rightCalloutAccessoryView = button;
            
        }
 }
    return view;
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self getDirections];

}

#pragma mark  location manager delegates

-(void)locationManager:(CLLocationManager *)manager1 didUpdateLocations:(NSArray<CLLocation *> *)locations{
    currentLocation = locations.lastObject.coordinate;
    [self upDateMapRegion:currentLocation];
    
   // [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}


-(void)upDateMapRegion:(CLLocationCoordinate2D)coOrdinate{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coOrdinate, span);
    
    [_mapView setRegion:region];
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    MyAnnotation *annotation = [[MyAnnotation alloc]initWithTitle:@"Location1" subTitle:@"" withCoordinate:currentLocation ];
    [_mapView addAnnotation:annotation];
    [annotation upDateSubTitle];
    
    
}


#pragma mark - Directions to place


-(void)getDirections{
    
    //(31.472889, -100.464478)
    MKPlacemark *sourcePM = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(17.496712, -100.464478)];

    //(35.455636, -97.547607)
    MKPlacemark *destiPM = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(35.455636, -97.547607)];

    MKMapItem *sourceMI = [[MKMapItem alloc]initWithPlacemark:sourcePM];
    MKMapItem *destiMI = [[MKMapItem alloc]initWithPlacemark:destiPM];
    
    MyAnnotation *ann1 = [[MyAnnotation alloc]initWithTitle:@"Location1" subTitle:nil withCoordinate:CLLocationCoordinate2DMake(17.496712, -100.464478)];
    [ann1 upDateSubTitle];
    MyAnnotation *ann2 = [[MyAnnotation alloc]initWithTitle:@"Location2" subTitle:nil withCoordinate:CLLocationCoordinate2DMake(35.455636, -97.547607)];
    [ann2 upDateSubTitle];

    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:@[ann1,ann2]];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.source = sourceMI;
    request.destination = destiMI;
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        [_mapView removeOverlays:_mapView.overlays];
        if (error == nil) {
            
            MKRoute *route = response.routes.firstObject;

            NSLog(@"%@",route.name);
            NSLog(@"%f",route.expectedTravelTime);
            NSLog(@"%f",route.distance);
            
            [_mapView addOverlay:route.polyline];
            
            MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
            
            MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(17.496712, -100.464478), span);
            
            [_mapView setRegion:region];
            

        }
        
    }];
    
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    renderer.strokeColor = [UIColor greenColor];
    renderer.lineWidth = 1;
    
    return renderer;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
