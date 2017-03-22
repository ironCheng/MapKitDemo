//
//  ViewController.m
//  CoreLocation
//
//  Created by IDSBG-00 on 2017/3/22.
//  Copyright © 2017年 iRonCheng. All rights reserved.
//


/*
 *              定位  加  地图
 *
 *  CLLocationManager + MapKit
 */

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "iRonAnnotation.h"


@interface ViewController () <CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationM;
@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGUI];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-70, 50, 50)];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

/* 返回用户位置 */
- (void)btnPress
{
    MKUserLocation *location = _mapView.userLocation;
    
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
}

//    在对应的代理方法中获取位置信息
- (void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
//    NSLog(@"每当请求到位置信息时, 都会调用此方法");
    [self showTheArray:locations];
}

#pragma mark 添加地图控件
-(void)initGUI{

    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    /* 
     *   定位服务
     */
    self.locationM = [[CLLocationManager alloc] init];
    self.locationM.delegate = self;
    //  当距离与上次对比大于此值时，才触发代理方法
    self.locationM.distanceFilter = 1;
    //  设置精度
    self.locationM.desiredAccuracy = kCLLocationAccuracyBest;
    //  请求前台定位授权, 并在Info.Plist文件中配置Key ( Nslocationwheninuseusagedescription )
    [self.locationM requestWhenInUseAuthorization];
    //  后台定位
    [self.locationM requestAlwaysAuthorization];
    //  调用方法,开始更新用户位置信息
//    [self.locationM startUpdatingLocation];
    
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    //添加大头针
    [self addAnnotation];
}

#pragma mark 添加大头针
-(void)addAnnotation{

    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(39.95, 116.35);
    /* 北京 */
    iRonAnnotation *annotation1=[[iRonAnnotation alloc] init];
    annotation1.title=@"this is title";
    annotation1.subtitle=@"subtitle";
    annotation1.coordinate=location1;
    annotation1.image = [UIImage imageNamed:@"missile1.png"];
    // mapView 添加 大头针
    [_mapView addAnnotation:annotation1];
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(39.87, 116.35);
    iRonAnnotation *annotation2=[[iRonAnnotation alloc] init];
    annotation2.title=@"Kenshin&Kaoru";
    annotation2.subtitle=@"Kenshin Cui's Home";
    annotation2.coordinate=location2;
    annotation2.image = [UIImage imageNamed:@"missile1.png"];
    [_mapView addAnnotation:annotation2];
}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"userLocation = %@",userLocation);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [_mapView setRegion:region animated:true];
}

#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注(蓝色圆圈)也是一个大头针，所以此时需要判断，返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[iRonAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snow10.png"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((iRonAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
}



- (void)showTheArray:(NSArray *)arr
{
    if (arr.count == 0) {
        return;
    }
    
    for (NSString *str in arr) {
        NSLog(@"==%@",str);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
