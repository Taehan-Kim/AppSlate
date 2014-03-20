//
//  CSMapView.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSMapView.h"

@implementation CSMapView

-(id) object
{
    return ((MKMapView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setMapType:(NSNumber*)typeValue
{
    NSUInteger value;
    
    if( [typeValue isKindOfClass:[NSString class]] )
        value = [(NSString*)typeValue integerValue];
    else if( [typeValue isKindOfClass:[NSNumber class]] )
        value = [typeValue integerValue];
    else
        return;

    [((MKMapView*)csView) setMapType:value];
}

-(NSNumber*) getMapType
{
    return @( (((MKMapView*)csView).mapType) );
}

-(void) setShowUserLocation:(NSNumber*)BoolValue
{
    BOOL value;
    
    if( [BoolValue isKindOfClass:[NSString class]] )
        value = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue boolValue];
    else
        return;

    [((MKMapView*)csView) setShowsUserLocation:value];
}

-(NSNumber*) getShowUserLocation
{
    return @( ((MKMapView*)csView).showsUserLocation );
}

-(void) setLatitude:(NSNumber*)degree
{
    if( [degree isKindOfClass:[NSString class]] )
        latitude = [(NSString*)degree doubleValue];
    else if( [degree isKindOfClass:[NSNumber class]] )
        latitude = [degree doubleValue];
    else
        return;

    if( 0 != latitude && 0 != longitude ){
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
        [(MKMapView*)csView setCenterCoordinate:coord animated:YES];
    }
}

-(NSNumber*) getLatitude
{
    return @( latitude );
}

-(void) setLongitude:(NSNumber*)degree
{
    if( [degree isKindOfClass:[NSString class]] )
        longitude = [(NSString*)degree doubleValue];
    else if( [degree isKindOfClass:[NSNumber class]] )
        longitude = [degree doubleValue];
    else
        return;

    if( 0 != latitude && 0 != longitude ){
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
        [(MKMapView*)csView setCenterCoordinate:coord animated:YES];
    }
}

-(NSNumber*) getLongitude
{
    return @( longitude );
}

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [csView setBackgroundColor:[UIColor whiteColor]];
    [(MKMapView*)csView setDelegate:self];
    [(MKMapView*)csView setMapType:MKMapTypeStandard];
    [(MKMapView*)csView setUserTrackingMode:MKUserTrackingModeFollow];
    [(MKMapView*)csView setShowsUserLocation:YES];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_MAPVIEW;
    isUIObj = YES;

    latitude = 0.0;
    longitude = 0.0;

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Map Type (0,1,2)", P_NUM, @selector(setMapType:),@selector(getMapType));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Show User Location", P_BOOL, @selector(setShowUserLocation:),@selector(getShowUserLocation));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Latitude", P_NUM, @selector(setLatitude:),@selector(getLatitude));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Longitude", P_NUM, @selector(setLongitude:),@selector(getLongitude));
    pListArray = @[xc,yc,d0,d1,d2,d3,d4];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        latitude = [decoder decodeDoubleForKey:@"latitude"];
        longitude = [decoder decodeDoubleForKey:@"longitude"];

        if( 0 != latitude && 0 != longitude ){
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
            [(MKMapView*)csView setCenterCoordinate:coord animated:YES];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeDouble:latitude forKey:@"latitude"];
    [encoder encodeDouble:longitude forKey:@"longitude"];
}

#pragma mark - Delegate

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSArray*) importLinesCode
{
    return @[@"<MapKit/MKMapView.h>",@"<MapKit/MKAnnotation.h>"];
}

-(NSString*) customClass
{
    return @" ";
}

-(NSString*) sdkClassName
{
    return @"MKMapView";
}

-(NSString*) delegateName
{
    return @"MKMapViewDelegate";
}

-(NSArray*) delegateCodes
{
    return nil;
}

@end
