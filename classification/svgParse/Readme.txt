流程思路：
1.load F:\HowdoHumansSketchObject\sketches 为D二维cell数组
2.[ filed ] = parseAllSvgToImage( D ) 传入D给改方法可以保存所有的Bezier草图到指定路径。
3.如果不想保存全部可以单独抽取BezierContour，[ totalStroke ] = parseOneSvgToPts( D{1,3} )
4.得到BezierContour可以重画出Bezier草图，[ outImage ] = drawSvgImage( totalStroke )
工具：
1.formatLine是将.svg中的，d元素的值归一化一下作批处理。
2.DrawLineImage连线画图用。