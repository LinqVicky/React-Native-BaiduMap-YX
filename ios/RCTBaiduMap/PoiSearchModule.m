//
//  PoiSearchModule.m
//  RCTBaiduMap
//
//  Created by yaxonzhang on 2019/1/7.
//  Copyright © 2019 lovebing.org. All rights reserved.
//

#import "PoiSearchModule.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface PoiSearchModule()<BMKPoiSearchDelegate>{
    RCTResponseSenderBlock callBack;
}
@end

@implementation PoiSearchModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(searchNearbyProcess:(NSString* )keyword lon:(CGFloat)lon lat:(CGFloat)lat radius:(int)radius loadIndex:(int)loadIndex back:(RCTResponseSenderBlock)callback){
    BMKPoiSearch *search = [[BMKPoiSearch alloc] init];
    search.delegate = self;
    BMKNearbySearchOption *option = [BMKNearbySearchOption new];
    CLLocationCoordinate2D cll =  (CLLocationCoordinate2D){lat, lon};
    option.location = cll;
    option.radius = radius;
    option.keyword = keyword;
    option.pageCapacity = 50;
    option.sortType=BMK_POI_SORT_BY_DISTANCE;
    [search poiSearchNearBy:option];
    callBack = callback;
}
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
//    天涯海角,吕岭路1740之7号,118.183712,24.488940;心仪餐厅,何厝顶何,118.185321,24.489598;'
    NSArray *arrPoiInfo = poiResult.poiInfoList;
    NSString *result = @"";
    for (BMKPoiInfo *info in arrPoiInfo) {
        if (result.length == 0) {
            result = [result stringByAppendingFormat:@"%@,%@,%F,%f",info.name,info.address,info.pt.longitude,info.pt.latitude];
        }else{
            result = [result stringByAppendingFormat:@";%@,%@,%F,%f",info.name,info.address,info.pt.longitude,info.pt.latitude];
        }
    }
    callBack(@[result]);
}
@end
