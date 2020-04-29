# CUI
### [TabHeader](https://github.com/CCloudTang/CUI/blob/master/CUI/CUI/TabHeader.swift)
tab选择器，支持自动布局，修改样式
```
let header1 = TabHeader(with: ["新闻","电影","纪录片"])
view.addSubview(header1)
```

* TabHeaderStyle
自定义需要的属性
```
var style = TabHeaderStyle()
style.type = TabHeaderStyle.StyleType.scrollable //可固定，可滑动
style.defaultSelectIndex = 2
```
