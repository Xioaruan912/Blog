对 selenium的丰富 更值得的是 可以绕过 cf 5s盾

# 安装

```
uv init porject
conda 操作
pip install seleniumbase
```

# 反爬虫

```python
        self.get_new_driver(
            proxy="127.0.0.1:7897",  # 设置代理
            agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36",  # 设置 UA
            disable_features="AutomationControlled"  # 绕过自动化检测
        )
```

```python
    def test_login(self):  //这里需要设定为test_开头这样 pytest才会识别
        self.open("testurl")
        self.wait_for_element_visible('//*[@id="root"]/div/header/button', timeout=10)# 这里根据样式自动识别 xpath
        self.click('//*[@id="root"]/div/header/button')
```

通过命令展示流程

```
pytest main.py --demo_mode
```

# 绕过CF

```
https://seleniumbase.io/examples/cdp_mode/ReadMe/#cdp-mode-usage
```

```python
from seleniumbase import SB

with SB(uc=True, test=True) as sb:
    url = "www.planetminecraft.com/account/sign_in/"
    sb.activate_cdp_mode(url)
    sb.sleep(2)
    sb.cdp.gui_click_element("#turnstile-widget div")
    sb.sleep(2)
```

```
'''
作者: Xioaruan912 xioaruan@gmail.com
最后编辑人员: Xioaruan912 xioaruan@gmail.com
文件作用介绍: 使用 SeleniumBase (SB) 执行自动登录与操作流程
'''

import time
from seleniumbase import SB
from loguru import logger

cookies = []

with SB(uc=True, test=True, locale="en") as sb:
    URL= "testurl"
    sb.activate_cdp_mode(URL)

    for cookie in cookies:
        sb.add_cookie(cookie)

    sb.open(URL)


    sb.wait_for_element_visible('/html/body/div/div/div[3]/a[1]/div/div', timeout=10)
    sb.click('/html/body/div/div/div[3]/a[1]/div/div')
    sb.sleep(2) #断开driver
    # 绕过
    sb.cdp.gui_click_element('/html/body/div/div/div[2]/div[3]')
```

