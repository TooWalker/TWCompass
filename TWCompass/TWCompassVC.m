//
//  TWCompassVC.m
//  TWCompass
//
//  Created by TooWalker on 6/19/16.
//  Copyright © 2016 TooWalker. All rights reserved.
//

#import "TWCompassVC.h"
#import "TWCompassV.h"
#import "CoreLocation/CoreLocation.h"

@interface TWCompassVC () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *CLMgr;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, weak) TWCompassV *compassV;
@end

@implementation TWCompassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    TWCompassV *compassV = [[TWCompassV alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.compassV = compassV;
    self.compassV.compassImgV.hidden = YES;
    [self.view addSubview:compassV];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    self.CLMgr = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务当前可能尚未打开，请设置打开！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self.CLMgr requestAlwaysAuthorization];
    self.CLMgr.delegate = self;
    self.CLMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [self.CLMgr startUpdatingLocation];
    [self.CLMgr startUpdatingHeading];
    self.compassV.compassImgV.hidden = NO;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    CGFloat angle = newHeading.magneticHeading / 180 * M_PI;
    NSUInteger degree = (int)newHeading.magneticHeading;
    self.compassV.degreeLbl.text = [NSString stringWithFormat:@"%ldº", degree];
    self.compassV.directionLbl.text = [self directionStrWithDegree:degree];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-angle);
    self.compassV.compassImgV.transform = transform;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations lastObject];
    [self.geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        self.compassV.localityLbl.text = placeMark.locality;
        self.compassV.administrativeAreaLbl.text = placeMark.administrativeArea;
    }];
    self.compassV.latLonLbl.text = [self transform:loc.coordinate];
    self.compassV.altLbl.text = [NSString stringWithFormat:@"%d ft Elevation", (int)(loc.altitude * 3.2808)];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied){
        NSLog(@"kCLErrorDenied");
    } else if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"kCLErrorLocationUnknown");
    }
}

- (NSString *)directionStrWithDegree:(NSUInteger)degree{
    NSString *directionStr = nil;
    if (degree <= 22) {
        directionStr = @"N";
    } else if (degree >= 23 && degree <= 66){
        directionStr = @"NE";
    } else if (degree >= 67 && degree <= 112){
        directionStr = @"E";
    } else if (degree >= 113 && degree <= 157){
        directionStr = @"SE";
    } else if (degree >= 158 && degree <= 202){
        directionStr = @"S";
    } else if (degree >= 203 && degree <= 246){
        directionStr = @"SW";
    } else if (degree >= 247 && degree <= 292){
        directionStr = @"W";
    } else if (degree >= 293 && degree <= 337){
        directionStr = @"NW";
    } else if (degree >= 338 && degree <= 359){
        directionStr = @"N";
    }
    return directionStr;
}

- (NSString *)transform:(CLLocationCoordinate2D)coor{
    NSString *str = nil;
    CGFloat lat = coor.latitude;
    CGFloat lon = coor.longitude;
    NSString *latStr = [self transformToDMS:lat];
    NSString *lonStr = [self transformToDMS:lon];
    
    str = [NSString stringWithFormat:@"%@ N  %@ E", latStr, lonStr];
    return str;
}

- (NSString *)transformToDMS:(CGFloat)number{
    /** 度：DMSStr    分：MNumber    秒：SNumber */
    NSString *DMSStr = nil;
    NSUInteger DNumber = (int)number;
    
    CGFloat mNumber = number - DNumber;
    mNumber = mNumber * 60;
    NSUInteger MNumber = (int)mNumber;
    
    CGFloat sNumber = mNumber - MNumber;
    sNumber = sNumber * 60;
    NSUInteger SNumber = (int)sNumber;
    
    DMSStr = [NSString stringWithFormat:@"%luº%lu’%lu”", DNumber, MNumber, SNumber];
    return DMSStr;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.CLMgr stopUpdatingHeading];
    [self.CLMgr startUpdatingLocation];
}

@end
