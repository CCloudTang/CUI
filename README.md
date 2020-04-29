# CUI
### TabHeader
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
