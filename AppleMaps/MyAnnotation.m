//
//  MyAnnotation.m
//  AppleMaps
//
//  Created by kishore kumar nagalla on 05/09/17.
//  Copyright © 2017 Pyramid SoftSol. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation


-(id)initWithTitle:(NSString*)title1 subTitle:(NSString*)subTitle withCoordinate:(CLLocationCoordinate2D)coOrdinate{
    self = [super init];
    
    
    if (self != nil) {
        self.title = title1;
        self.coordinate = coOrdinate;
        self.subtitle = subTitle;

    }
    
    return self;
}

-(NSString *)title{
    
    return _title;
}

-(NSString *)subtitle{
    return _subtitle;
}

-(CLLocationCoordinate2D)coordinate{
    return _coordinate;
}


- (NSString *)stringForPlacemark:(CLPlacemark *)placemark {
    
    NSMutableString *string = [[NSMutableString alloc] init];
    
    
    if (placemark.name) {
        [string appendString:placemark.name];
    }
    if (placemark.locality) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendString:placemark.locality];
    }
    
    if (placemark.administrativeArea) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendString:placemark.administrativeArea];
    }
    
    if (string.length == 0 && placemark.name)
        [string appendString:placemark.name];
    
    return string;
}

-(void)upDateSubTitle{
    // for the subtitle, we reverse geocode the lat/long for a proper location string name
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"%@",placemarks.firstObject);
        if (placemarks.count>0) {
            CLPlacemark *placeMark = placemarks[0];
            self.subtitle = [NSString stringWithFormat:@"Near %@", [self stringForPlacemark:placeMark]];

            
        }
        
        
    }];
    
}


@end
