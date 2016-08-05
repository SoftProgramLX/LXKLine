# LXKLine
###使用CoreGraphics框架实现了k线行情图的基本功能，只有日、周、月k线图，手势包括拖动、缩放、长按。
提示：<br>1.这是项目前期为了实现功能写的demo，里面很多不规范的代码和设计模式。仅供参看。<br>
2.我开发的k线最新案例请下载App“牛仔网”前往查看。当然设计模式完全不一样，有时间再整理完整的k线开发demo。<br>

###画连接线的代码如下：<br>

```objective-c
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();// 获取绘图上下文
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetShouldAntialias(context, YES);
    LXColorModel *colormodel = [UIColor RGBWithHexString:self.color withAlpha:self.alpha]; // 设置颜色
    CGContextSetRGBStrokeColor(context, (CGFloat)colormodel.R/255.0f, (CGFloat)colormodel.G/255.0f, (CGFloat)colormodel.B/255.0f, self.alpha);
    if (self.startPoint.x==self.endPoint.x && self.endPoint.y==self.startPoint.y) {
        // 定义多个个点 画多点连线
        for (id item in self.points) {
            CGPoint currentPoint = CGPointFromString(item);
            if ((int)currentPoint.y<(int)self.frame.size.height && currentPoint.y>0) {
                if ([self.points indexOfObject:item]==0) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                    continue;
                }
                CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
                CGContextStrokePath(context); //开始画线
                if ([self.points indexOfObject:item]<self.points.count) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                }
                
            }
        }
    }else{
        // 定义两个点 画两点连线
        const CGPoint points[] = {self.startPoint,self.endPoint};
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
}
```

<br>
* 此demo的效果图如下<br>
![image1](https://github.com/SoftProgramLX/LXKLine/blob/master/LXKLine/File/screen1.png)<br><br>
![image2](https://github.com/SoftProgramLX/LXKLine/blob/master/LXKLine/File/screen2.png)<br><br>
![image3](https://github.com/SoftProgramLX/LXKLine/blob/master/LXKLine/File/screen3.png)<br><br>
<br>

* 牛仔网App的效果如下<br>
![image4](https://github.com/SoftProgramLX/LXKLine/blob/master/LXKLine/File/image1.png)<br><br>
---
<br>
![image5](https://github.com/SoftProgramLX/LXKLine/blob/master/LXKLine/File/image2.png)<br><br>
---
<br>
![image6](https://github.com/SoftProgramLX/LXKLine/blob/master/LXKLine/File/image3.png)<br>

<br>
###`QQ:2239344645`    [我的github](https://github.com/SoftProgramLX?tab=repositories)
