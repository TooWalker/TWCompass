//
//  TWCompassV.h
//  TWCompass
//
//  Created by TooWalker on 6/19/16.
//  Copyright © 2016 TooWalker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TWCompassV : UIView
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
