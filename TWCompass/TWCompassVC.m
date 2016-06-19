//
//  TWCompassVC.m
//  TWCompass
//
//  Created by TooWalker on 6/19/16.
//  Copyright © 2016 TooWalker. All rights reserved.
//

#import "TWCompassVC.h"
#import "CoreLocation/CoreLocation.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TWCompassVC () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *CLMgr;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, weak) UIImageView *compassImgV;

@property (nonatomic, weak) UIView *indexV;  /**< 示数 */
@property (nonatomic, weak) UILabel *degreeLbl; /**< 度数 */
@property (nonatomic, weak) UILabel *directionLbl;  /**< 方向 */
@property (nonatomic, weak) UILabel *localityLbl;   /**< 城市 */
@property (nonatomic, weak) UILabel *administrativeAreaLbl; /**< 州、省份 */

@property (nonatomic, weak) UIView *latLonAltV; /**< 经纬度和海拔面板 */
@property (nonatomic, weak) UILabel *latLonLbl; /**< 经纬度 */
@property (nonatomic, weak) UILabel *altLbl;    /**< 海拔 */
@end

@implementation TWCompassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *compassImgV = [self setupImgV];
    self.compassImgV = compassImgV;
    [self.view addSubview:self.compassImgV];
    
    CGFloat topMargin = 20;
    CGFloat indexVY = CGRectGetMaxY(self.compassImgV.frame) + topMargin;
    UIView *indexV = [self setupIndexV:CGRectMake(0, indexVY, kScreenWidth, 70)];
    self.indexV = indexV;
    [self.view addSubview:self.indexV];
    
    UIView *latLonAltV = [self setupLatLonAltV];
    [self.view addSubview:latLonAltV];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    self.CLMgr = [[CLLocationManager alloc] init];
    self.CLMgr.delegate = self;
    self.CLMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"没有开启定位功能，请开启后使用！");
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
    }
    
    [self.CLMgr requestAlwaysAuthorization];
    
    [self.CLMgr startUpdatingLocation];
    [self.CLMgr startUpdatingHeading];
}

- (UIImageView *)setupImgV{
    CGFloat imgVX = 0;
    CGFloat imgVY = 20 + 44;
    CGFloat imgVW = kScreenWidth;
    CGFloat imgVH = kScreenWidth;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(imgVX, imgVY, imgVW, imgVH)];
    
    UIImage *img = [UIImage imageNamed:@"bg_compasspointer"];
    imgV.image = img;
    
    return imgV;
}

- (UIView *)setupIndexV:(CGRect)rect{
    UIView *indexV = [[UIView alloc] initWithFrame:rect];
    self.indexV = indexV;
    
    /** 度数 */
    CGFloat degreeLblX = 0;
    CGFloat degreeLblY = 0;
    CGFloat degreeLblW = 180;
    CGFloat degreeLblH = rect.size.height;
    UILabel *degreeLbl = [[UILabel alloc] initWithFrame:CGRectMake(degreeLblX, degreeLblY, degreeLblW, degreeLblH)];
    degreeLbl.font = [UIFont fontWithName:@"PingFangSC-Thin" size:80];
    degreeLbl.textAlignment = NSTextAlignmentRight;
    self.degreeLbl = degreeLbl;
    [self.indexV addSubview:degreeLbl];
    
    /** 方向 */
    CGFloat directionLblX = CGRectGetMaxX(degreeLbl.frame) + 10;
    CGFloat directionLblY = degreeLblY;
    CGFloat directionLblW = 100;
    CGFloat directionLblH = degreeLblH / 3;
    UILabel *directionLbl = [[UILabel alloc] initWithFrame:CGRectMake(directionLblX, directionLblY, directionLblW, directionLblH)];
    directionLbl.font = [UIFont boldSystemFontOfSize:20];
    self.directionLbl = directionLbl;
    [self.indexV addSubview:directionLbl];
    
    /** 城市 */
    CGFloat localityLblX = directionLblX;
    CGFloat localityLblY = CGRectGetMaxY(directionLbl.frame);
    CGFloat localityLblW = directionLblW;
    CGFloat localityLblH = degreeLblH / 3;
    UILabel *localityLbl = [[UILabel alloc] initWithFrame:CGRectMake(localityLblX, localityLblY, localityLblW, localityLblH)];
    localityLbl.font = [UIFont systemFontOfSize:20];
    self.localityLbl = localityLbl;
    [self.indexV addSubview:localityLbl];
    
    /** 州、省份 */
    CGFloat administrativeAreaLblX = directionLblX;
    CGFloat administrativeAreaLblY = CGRectGetMaxY(localityLbl.frame);
    CGFloat administrativeAreaLblW = directionLblW;
    CGFloat administrativeAreaLblH = degreeLblH / 3;
    UILabel *administrativeAreaLbl = [[UILabel alloc] initWithFrame:CGRectMake(administrativeAreaLblX, administrativeAreaLblY, administrativeAreaLblW, administrativeAreaLblH)];
    administrativeAreaLbl.font = [UIFont systemFontOfSize:20];
    self.administrativeAreaLbl = administrativeAreaLbl;
    [self.indexV addSubview:administrativeAreaLbl];
    return indexV;
}

- (UIView *)setupLatLonAltV{
    
    /** 经纬度和海拔面板 */
    CGFloat latLonAltVW = kScreenWidth;
    CGFloat latLonAltVH = 60;
    CGFloat latLonAltVX = 0;
    CGFloat bottomMargin = 20;
    CGFloat latLonAltVY = kScreenHeight - latLonAltVH - bottomMargin;
    UIView *latLonAltV = [[UIView alloc] initWithFrame:CGRectMake(latLonAltVX, latLonAltVY, latLonAltVW, latLonAltVH)];
    self.latLonAltV = latLonAltV;
    
    /** 经纬度 */
    CGFloat latLonLblX = 0;
    CGFloat latLonLblY = 0;
    CGFloat latLonLblW = latLonAltVW;
    CGFloat latLonLblH = latLonAltVH / 2;
    UILabel *latLonLbl = [[UILabel alloc] initWithFrame:CGRectMake(latLonLblX, latLonLblY, latLonLblW, latLonLblH)];
    latLonLbl.textAlignment = NSTextAlignmentCenter;
    latLonLbl.font = [UIFont systemFontOfSize:20];
    self.latLonLbl = latLonLbl;
    [self.latLonAltV addSubview:self.latLonLbl];
    
    /** 海拔 */
    CGFloat altLblX = 0;
    CGFloat altLblY = CGRectGetMaxY(self.latLonLbl.frame);
    CGFloat altLblW = latLonAltVW;
    CGFloat altLblH = latLonAltVH / 2;
    UILabel *altLbl = [[UILabel alloc] initWithFrame:CGRectMake(altLblX, altLblY, altLblW, altLblH)];
    altLbl.textAlignment = NSTextAlignmentCenter;
    altLbl.font = [UIFont systemFontOfSize:20];
    self.altLbl = altLbl;
    [self.latLonAltV addSubview:self.altLbl];
    
    return latLonAltV;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    CGFloat angle = newHeading.magneticHeading / 180 * M_PI;
    NSUInteger degree = (int)newHeading.magneticHeading;
    self.degreeLbl.text = [NSString stringWithFormat:@"%ldº", degree];
    self.directionLbl.text = [self directionStrWithDegree:degree];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-angle);
    self.compassImgV.transform = transform;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations lastObject];
    [self.geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        self.localityLbl.text = placeMark.locality;
        self.administrativeAreaLbl.text = placeMark.administrativeArea;
    }];
    self.latLonLbl.text = [self transform:loc.coordinate];
    self.altLbl.text = [NSString stringWithFormat:@"%d ft Elevation", (int)(loc.altitude * 3.2808)];
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
