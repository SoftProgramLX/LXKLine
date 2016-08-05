//
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import "LXGetData.h"
#import "LXCommond.h"

@interface LXGetData ()
@property(nonatomic, strong) NSArray *lines;

@end


@implementation LXGetData

-(id)init{
    self = [super init];
    if (self){
        self.isFinish = NO;
        self.maxValue = 0;
        self.minValue = CGFLOAT_MAX;
        self.volMaxValue = 0;
        self.volMinValue = CGFLOAT_MAX;
    }
    return  self;
}

-(id)initWithUrl:(NSString*)url{
    if (self){
        // 取缓存的每天数据
        NSArray *tempArray = (NSArray*)[LXCommond getUserDefaults:@"daydatas"];
//        NSLog(@"%@", tempArray);
        if (tempArray.count>0) {
            self.dayDatas = tempArray;
        }
        _lines = [NSArray arrayWithArray:(NSArray*)[LXCommond getUserDefaults:[LXCommond md5HexDigest:url]]];
        if (_lines.count>0) {
            [self changeData:_lines];
        }else{
            AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
            mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
            mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/csv",@"application/json",@"text/json", @"text/plain", @"text/html", nil];
            NSLog(@"%@", url);
            [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSData *data = [];
                NSString *content = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
                NSLog(@"%@", content);
                self.status.text = @"";
//                NSString *content = [request responseString];
                NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                if ([self.req_type isEqualToString:@"d"]) {
                    self.dayDatas = lines;
                    [LXCommond setUserDefaults:lines forKey:@"daydatas"];
                }
                [LXCommond setUserDefaults:lines forKey:[LXCommond md5HexDigest:[[NSString alloc] initWithFormat:@"%@",url]]];
                [self changeData:lines];
                self.isFinish = YES;
                

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        }
	}
    return self;
}

-(void)changeData:(NSArray*)lines{
    NSMutableArray *data =[[NSMutableArray alloc] init];
	NSMutableArray *category =[[NSMutableArray alloc] init];
    NSArray *newArray = lines;
    
#if 0
    newArray = [newArray objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:
                                           NSMakeRange(0, self.kCount>=newArray.count?newArray.count:self.kCount)]]; // 只要前面指定的数据
#else
    LXSingleton *singleton = [LXSingleton sharedLXSingleton];
    if (singleton.kCount > lines.count) {
        singleton.kCount = lines.count;
    }
//    NSLog(@"---:%d %d %d %d", singleton.lastPointIndex, self.kCount, newArray.count, lines.count);

    NSInteger arrCount = self.kCount <= newArray.count ? self.kCount : newArray.count;
    if (singleton.lastPointIndex + arrCount > lines.count) {
        singleton.lastPointIndex = lines.count - arrCount;
    }
    newArray = [newArray objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:
                                           NSMakeRange(singleton.lastPointIndex, arrCount)]]; // 只要前面指定的数据
//    NSLog(@"newArray.count:%d", newArray.count);
#endif
    
    //NSLog(@"lines:%@",newArray);
    NSInteger idx;
    int MA5=5,MA10=10,MA20=20; // 均线统计
    for (idx = newArray.count-1; idx >= 0; idx--) {
        NSString *line = [newArray objectAtIndex:idx];
        if([line isEqualToString:@""]){
            continue;
        }
        
        NSArray   *arr = [NSArray arrayWithArray:[line componentsSeparatedByString:@","]];
        // 收盘价的最小值和最大值
        if ([[arr objectAtIndex:2] floatValue]>self.maxValue) {
            self.maxValue = [[arr objectAtIndex:2] floatValue];
        }
        if ([[arr objectAtIndex:3] floatValue]<self.minValue) {
            self.minValue = [[arr objectAtIndex:3] floatValue];
        }
        // 成交量的最大值最小值
        if ([[arr objectAtIndex:5] floatValue]>self.volMaxValue) {
            self.volMaxValue = [[arr objectAtIndex:5] floatValue];
        }
        if ([[arr objectAtIndex:5] floatValue]<self.volMinValue) {
            self.volMinValue = [[arr objectAtIndex:5] floatValue];
        }
        NSMutableArray *item =[[NSMutableArray alloc] init];
        [item addObject:[arr objectAtIndex:1]]; // open
        [item addObject:[arr objectAtIndex:2]]; // high
        [item addObject:[arr objectAtIndex:3]]; // low
        [item addObject:[arr objectAtIndex:4]]; // close
        [item addObject:[arr objectAtIndex:5]]; // volume 成交量
        CGFloat idxLocation = [lines indexOfObject:line];
        // MA5
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA5)]]]; // 前五日收盘价平均值
        // MA10
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA10)]]]; // 前十日收盘价平均值
        // MA20
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA20)]]]; // 前二十日收盘价平均值
        // 前面二十个数据不要了，因为只是用来画均线的
        [category addObject:[arr objectAtIndex:0]]; // date
        [data addObject:item];
    }
	if(data.count==0){
		self.status.text = @"Error!";
	    return;
	}
    
    self.data = data; // Open,High,Low,Close,Adj Close,Volume
    self.category = category; // Date
    //NSLog(@"%@",data);
}


-(CGFloat)sumArrayWithData:(NSArray*)data andRange:(NSRange)range{
    CGFloat value = 0;
    if (data.count - range.location>range.length) {
        NSArray *newArray = [data objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:range]];
        for (NSString *item in newArray) {
            NSArray *arr = [NSArray arrayWithArray:[item componentsSeparatedByString:@","]];
            value += [[arr objectAtIndex:4] floatValue];
        }
        if (value>0) {
            value = value / newArray.count;
        }
    }
    return value;
}

-(void)dealloc{

}
@end
