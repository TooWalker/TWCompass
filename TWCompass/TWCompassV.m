//
//  TWCompassV.m
//  TWCompass
//
//  Created by TooWalker on 6/19/16.
//  Copyright © 2016 TooWalker. All rights reserved.
//

#import "TWCompassV.h"

@implementation TWCompassV

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.000];
        
        UIImageView *compassImgV = [self setupImgV];
        self.compassImgV = compassImgV;
        [self addSubview:self.compassImgV];
        
        CGFloat topMargin = 20;
        CGFloat indexVY = CGRectGetMaxY(self.compassImgV.frame) + topMargin;
        UIView *indexV = [self setupIndexV:CGRectMake(0, indexVY, kScreenWidth, 70)];
        self.indexV = indexV;
        [self addSubview:self.indexV];
        
        UIView *latLonAltV = [self setupLatLonAltV];
        [self addSubview:latLonAltV];
    }
    return self;
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

@end
