# python --pyecharts

- echart 是一个制表制图的模块
- pyecharts python中的echart接口模块

```python
pip3  install pyecharts==0.1.9.4
```

全球国家地图: [echarts-countries-pypkg](https://github.com/pyecharts/echarts-countries-pypkg) (1.9MB): 世界地图和 213 个国家，包括中国地图
中国省级地图: [echarts-china-provinces-pypkg](https://github.com/pyecharts/echarts-china-provinces-pypkg) (730KB)：23 个省，5 个自治区
中国市级地图: [echarts-china-cities-pypkg](https://github.com/pyecharts/echarts-china-cities-pypkg) (3.8MB)：370 个中国城市

```python
# 柱形图
from pyecharts import Line, Bar, Pie, EffectScatter
bar =Bar("我的第一个图表", "这里是副标题")
bar.add("服装", ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"], [5, 20, 36, 10, 75, 90])
bar.show_config()
bar.render()
# 普通折线图
line = Line('折线图')
line.add('商家A', attr, v1, mark_point=['max'])
line.add('商家B', attr, v2, mark_point=['min'], is_smooth=True)
line.show_config()
line.render(path='./data/01-04折线图.html')

# 阶梯折线图
line2 = Line('阶梯折线图')
line2.add('商家A', attr, v1,  is_step=True, is_label_show=True)
line2.show_config()
line2.render(path='./data/01-05阶梯折线图.html')

# 面积折线图
line3 =Line("面积折线图")
line3.add("商家A", attr, v1, is_fill=True, line_opacity=0.2,   area_opacity=0.4, symbol=None, mark_point=['max'])
line3.add("商家B", attr, v2, is_fill=True, area_color='#a3aed5', area_opacity=0.3, is_smooth=True)
line3.show_config()
line3.render(path='./data/01-06面积折线图.html')

# 柱形图-折线图
from pyecharts import Bar, Line, Overlap

att = ['A', 'B', 'C', 'D', 'E', 'F']
v3 = [10, 20, 30, 40, 50, 60]
v4 = [38, 28, 58, 48, 78, 68]

bar = Bar("柱形图-折线图")
bar.add('bar', att, v3)
line = Line()
line.add('line', att, v4)

overlap = Overlap()
overlap.add(bar)
overlap.add(line)
overlap.show_config()
overlap.render(path='./data/01-066柱形图-折线图.html')
# 饼图
pie = Pie('饼图')
pie.add('芝麻饼', attr, v1, is_label_show=True)
pie.show_config()
pie.render(path='./data/01-07饼图.html')

# 玫瑰饼图
pie2 = Pie("饼图-玫瑰图示例", title_pos='center', width=900)
pie2.add("商品A", attr, v1, center=[25, 50], is_random=True, radius=[30, 75], rosetype='radius')
pie2.add("商品B", attr, v2, center=[75, 50], is_random=True, radius=[30, 75], rosetype='area', is_legend_show=False, is_label_show=True)
pie2.show_config()
pie2.render(path='./data/01-08玫瑰饼图.html')
```

```python
# 中国地图
from pyecharts import Map
value = [155, 10, 66, 78]
attr = ["福建", "山东", "北京", "上海"]
map = Map("全国地图示例", width=1200, height=600)
map.add("", attr, value, maptype='china')
map.render()
```

```python
# 词云
from pyecharts import WordCloud

name =['Sam S Club', 'Macys', 'Amy Schumer', 'Jurassic World', 'Charter Communications', 'Chick Fil A', 'Planet Fitness', 'Pitch Perfect', 'Express', 'Home', 'Johnny Depp', 'Lena Dunham', 'Lewis Hamilton', 'KXAN', 'Mary Ellen Mark', 'Farrah Abraham', 'Rita Ora', 'Serena Williams', 'NCAA baseball tournament', 'Point Break']
value =[10000, 6181, 4386, 4055, 2467, 2244, 1898, 1484, 1112, 965, 847, 582, 555, 550, 462, 366, 360, 282, 273, 265]
wordcloud =WordCloud(width=1300, height=620)
wordcloud.add("", name, value, word_size_range=[20, 100])
wordcloud.show_config()
wordcloud.render(path='05-01权重词云.html')

wordcloud2 =WordCloud(width=1300, height=620)
wordcloud2.add("", name, value, word_size_range=[30, 100], shape='diamond')
wordcloud2.show_config()
wordcloud2.render(path='05-02变形词云.html')
```

```python
from pyecharts import Map,Geo
value = [95.1, 23.2, 43.3, 66.4, 88.5]
attr= ["China", "Canada", "Brazil", "Russia", "United States"]

# 省和直辖市
province_distribution = {'河南': 45.23, '北京': 37.56, '河北': 21, '辽宁': 12, '江西': 6, '上海': 20, '安徽': 10, '江苏': 16, '湖南': 9, '浙江': 13, '海南': 2, '广东': 22, '湖北': 8, '黑龙江': 11, '澳门': 1, '陕西': 11, '四川': 7, '内蒙古': 3, '重庆': 3, '云南': 6, '贵州': 2, '吉林': 3, '山西': 12, '山东': 11, '福建': 4, '青海': 1, '舵主科技，质量保证': 1, '天津': 1, '其他': 1}
provice=list(province_distribution.keys())
values=list(province_distribution.values())

# 城市 -- 指定省的城市 xx市
city = ['郑州市', '安阳市', '洛阳市', '濮阳市', '南阳市', '开封市', '商丘市', '信阳市', '新乡市']
values2 = [1.07, 3.85, 6.38, 8.21, 2.53, 4.37, 9.38, 4.29, 6.1]

# 区县 -- 具体城市内的区县  xx县
quxian = ['夏邑县', '民权县', '梁园区', '睢阳区', '柘城县', '宁陵县']
values3 = [3, 5, 7, 8, 2, 4]


map0 = Map("世界地图示例", width=1200, height=600)
map0.add("世界地图", attr, value, maptype="world",  is_visualmap=True, visual_text_color='#000')
map0.render(path="04-00世界地图.html")
```

```python
# 热力分布图
from pyecharts import Geo
data = [
("海门", 9),("鄂尔多斯", 12),("招远", 12),("舟山", 12),("齐齐哈尔", 14),("盐城", 15),
("赤峰", 16),("青岛", 18),("乳山", 18),("金昌", 19),("泉州", 21),("莱西", 21),
("日照", 21),("胶南", 22),("南通", 23),("拉萨", 24),("云浮", 24),("梅州", 25)]

geo = Geo("全国主要城市空气质量热力图", "data from pm2.5", title_color="#fff", title_pos="center", width=1200, height=600, background_color='#404a59')
attr, value = geo.cast(data)
geo.add("空气质量热力图", attr, value, visual_range=[0, 25], type='heatmap',visual_text_color="#fff", symbol_size=15, is_visualmap=True, is_roam=False)
geo.show_config()
geo.render(path="b.html")
```

```python
# 空气质量评分
indexs = ['上海', '北京', '合肥', '哈尔滨', '广州', '成都', '无锡', '杭州', '武汉', '深圳', '西安', '郑州', '重庆', '长沙']
values = [4.07, 1.85, 4.38, 2.21, 3.53, 4.37, 1.38, 4.29, 4.1, 1.31, 3.92, 4.47, 2.40, 3.60]

geo = Geo("全国主要城市空气质量评分", "data from pm2.5", title_color="#fff", title_pos="center", width=1200, height=600, background_color='#404a59')

# type="effectScatter", is_random=True, effect_scale=5  使点具有发散性
geo.add("空气质量评分", indexs, values, type="effectScatter", is_random=True, effect_scale=5, visual_range=[0, 5],visual_text_color="#fff", symbol_size=15, is_visualmap=True, is_roam=False)
geo.show_config()
geo.render(path="04-05空气质量评分.html")
```

