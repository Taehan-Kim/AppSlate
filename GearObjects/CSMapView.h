//
//  CSMapView.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKAnnotation.h>
#import "CSGearObject.h"

@interface CSMapView : CSGearObject <MKMapViewDelegate>
{
    CLLocationDegrees   latitude;
    CLLocationDegrees   longitude;
}

-(id) initGear;

-(void) setMapType:(NSNumber*)typeValue;
-(NSNumber*) getMapType;

-(void) setShowUserLocation:(NSNumber*)BoolValue;
-(NSNumber*) getShowUserLocation;

-(void) setLatitude:(NSNumber*)degree;
-(NSNumber*) getLatitude;

-(void) setLongitude:(NSNumber*)degree;
-(NSNumber*) getLongitude;

@end
