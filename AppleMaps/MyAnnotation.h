//
//  MyAnnotation.h
//  AppleMaps
//
//  Created by kishore kumar nagalla on 05/09/17.
//  Copyright © 2017 Pyramid SoftSol. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface MyAnnotation : NSObject<MKAnnotation>

// here we can use same name but it will take only property i.e _title

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic)CLLocationCoordinate2D coordinate;
@property(nonatomic)CLLocation* location;

-(id)initWithTitle:(NSString*)title1 subTitle:(NSString*)subTitle withCoordinate:(CLLocationCoordinate2D)coOrdinate;
-(void)upDateSubTitle;

@end
