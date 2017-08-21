# GitBook CUAV Theme

CUAV 主题，fork [gitbook-plugin-theme-default](https://github.com/GitbookIO/theme-default)

### 使用方法

---

添加下面的内容到 `book.json` 文件的对应位置，之后执行 `gitbook install`:

``` json
{
  "plugins": ["theme-cuav"]
}
```

### 配置

---

整体配置

``` json
{
  "pluginsConfig": {
    "theme-cuav": {
      "useGitbookIcon": "true",
      "iconPath": "/www.cuav.net/ico",
      "showGitBookLink": true,
      "navbar": {
        "brand": {
            "url": "http://www.cuav.net",
            "logo": {
                "alt": "图片信息",
                "url": "http://www.cuav.net/logo",
                "path": "/cuav_logo.png"
            }
        },
        "nav": {
            "items": [
                {
                    "name": "无二级标题菜单标题",
                    "url": "http://www.cuav.net"
                },
                {
                    "name": "有二级标题菜单",
                    "links": [
                        {
                            "name": "二级标题菜单1",
                            "url": "http://www.cuav.net"
                        },
                        {
                            "name": "二级标题菜单2",
                            "url": "http://www.cuav.net"
                        }
                    ]
                }
            ]
        },
        "navAjaxUrl": "/xxx.json",
        "footer": "<a href='http://www.cuav.net'>http://www.cuav.net<a>"
      }
    }
  }
}
```

#### useGitbookIcon

`true` 使用 GitBook 默认的 icon，`false` 使用 `iconPath` 指定的 icon。

#### iconPath

icon 的地址，如果 `useGitbookIcon` 为 `false` 和 `iconPath` 不指定的话，使用 cuav 的 icon。

#### showGitBookLink

是否显示 summary 底部默认的 GitBook 链接。

#### navbar

##### brand

顶部导航栏左上角 logo 设置

* url：点击后跳转的链接，不设置点击后不发生任何跳转。
* logo：logo 图片设置。
    * alt：图片失效时显示的文件。
    * url：图片的网络地址，不能与 `path` 一起设置，如果也设置 `path`，`url` 设置失效。
    * path：图片的本地地址，如果 `url` 有设置，将覆盖 `url`。

##### nav.items

* name：菜单名。
* url：菜单点击后跳转的地址。
* links：二级菜单，如果没设置则表示没有二级菜单。

#### navAjaxUrl

动态菜单地址，如果有设置将开启动态加载菜单；

格式如下，各项与 `navbar.nav.items` 一致：

``` json
[
  {
    "name": "一级目录名，没有二级目录",
    "url": "跳转的 url；如果不想跳转，请设置为'javascript:;'"
  },
  {
    "name": "一级目录名，拥有二级目录",
    "links": [
      {
        "name": "二级目录",
        "url": "跳转的 url；如果不想跳转，请设置为'javascript:;'"
      }
    ]
  }
]
```

#### footer

页面底部显示，可以纯文本，也可以是 html 文本；可以用于版权声明，如果设置将在每个页面的底部显示

### 更新内容

---

#### 1.1.3

* Change: cuav-nav.js 中 const 替换成 var，增强兼容性

#### 1.1.2

* Fix: 修复页脚中错误的 div 结束标签

#### 1.1.1

* Fix: 顶部导航栏没有菜单时，小屏依旧显示菜单按钮。
* Add: 不缓存 `navAjaxUrl` 获取的 json 文件。
