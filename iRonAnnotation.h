//
//  iRonAnnotation.h
//  CoreLocation
//
//  Created by IDSBG-00 on 2017/3/22.
//  Copyright © 2017年 iRonCheng. All rights reserved.
//

/*
 *     大头针
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface iRonAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;

@end
