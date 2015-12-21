sketchToken_vFeat:
1. 在sketchToken_vFeat中load sketchInfos
2. 对每一个sketchInfo先读取图片用所有方向的Gabor对其卷积得到响应图。
3. 分别对每一个sketchInfo的响应图的每一个采样点取出36*36的像素块，计算GALIF特征
4. 即每一个采样点都有一个GALIF特征，存到sketchInfos里面换名字为infosStruct，存到相应目录下。
sketchToken_cluster:
1. 取出所有的草绘图采样点的GALIF特征形成designMatrix聚类形成sketch Token
2. 保存center assignment other
sketchToken_BOFGALIF
1. 读取每一个采样点GALIF特征，计算bof直方图，存入到infosStruct中。
sketchToken_play
1. 用上面的方法生成直方图后玩玩检索看看效果。
sketchToken_vis
1. 根据assignment知道每个采样点的所属类别，
2. 根据类别归类每一个采样点的patch，可视化看看sketch token的聚类效果。
sketchToken_tag
1. 为每一个草图打上所属类的标签。存到infosStruct中。
sketchToken_train
1. 从infosStruct中提取出classifyDesignMatrix和target。
2. 训练svm
