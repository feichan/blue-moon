BLUE-MOON The Image Server For PixPlus.ME
============================================

Concepts
--------------------

介于图片存储(本地或者远程存储)与其他的App, Web等服务器之间, 其他服务器不能直接与存储交互, 必须通过blue-moon.

Blue-moon需要时间的功能和机制:

- 自适应. 可以针对不同的设备所要求的大小动态压缩图片,生成缓存图片并返回该需求图片.
- 错误处理. 针对不同的错误(not found, I/O error, forbidden等)返回不同的提示图片.
- 认证.需与lamancha交互,暂缓...
- 日志.需与lamancha交互,暂缓...
- 控制上传下载速度. 如对集中大量上传者, 动态限制其上传速度.
- 横向扩展. 使用远程存储时, 可以通过动态增加服务器数量的方式实现负载均衡(使用nginx).实现弹性增加服务器(如使用AWS Beanstalk)或者一套配合自动化配置脚本在短时间(如1小时以内)手动增加服务器的方案(procedure).
- (可选)为图片增加水印等.
- (可选)使用GPU提升效率.

Implementation Details
----------------------------

### 图片处理

Blue-moon目标: 1.保障对访问程序的控制; 2. 尽可能提高速度.

- Mini_Magick + sinatra的stream方式上传和读取.
- 未来可使用nginx基于C的module实现.

### 认证和日志

- 与之交互必须通过lamancha的认证机制, 使用HTTP的Authorization Header认证.
- 对于浏览器, 除一般的防盗链措施外, 访问private图片时需要在URL中加载access token：

    http://img.pixplus.me/iower23la034ekljfdsz.jpg?at=elrd8ovfr234lru0d9f87234elrfd9f8a9342hl3kerjwdf98sv

  `at`(access token)含来自于LaMancha服务器的session_id, 可用于认证用户并推算有效期.
  `at`中并内置验证码可以在不与LaMancha服务器交互的情况下验证session_id的合法性.
- 认证同时, lamancha记录access的log.(暂未定)

### 错误处理

在图片不存在, 未通过认证和服务器端error时跳转到特定图片, 用图片显示错误内容.

### 负载均衡

使用Nginx动态分配的方式. 如何测试负载均衡是否有效、以及如何监控各服务器的performance(以方便决定何时增加或减少服务器)是一个课题.

### 存储

设置一个对存储的抽象层完成读写操作。支持以下API：

- set(image, image_origin_path, image_cache_path=nil)
  设置要读取的图片的名字image(只是图片的id和type,不包含路径),原始图片存放的路径(image_origin_path)和cache存放的路径(image_cache_path).
  如果image_cache_path为nil,则cache路径与原始路径一致


- send(size)
  在该函数中使用MiniMagick库读取图片
    1.接收图片尺寸(size).
    2.调用exists?(size)函数检测缓存是否存在,直读取缓存.
    3.调用resize(size)函数生成缓存,并调用save(image)保存图片,同时直接返回图片blob,不从HDD再次读取.
    4.读取HDD上的cache,返回blob.

- resize(size, image)
  在该函数中使用MiniMagick库处理图片
    1.接收图片尺寸和图片对象.
    2.使用MiniMagick对图片进行压缩.
    3.返回MiniMagick对象.

- exists?(size=nil)
  判断对应文件是否存在
    1.若size为nil则是检测原图片是否存在.
    2.若size为具体数字,则检测对应尺寸的图片是否存在.
    3.存在返回true,不存在返回false.

- save(image, image_path)
  保存压缩后的图片为缓存
    1.接收MiniMagick对象和图片存储路径.
    2.保存图片至指定路径.
    3.成功返回true,失败返回false.

并需支持API层的stream读取。

### 动态控制上传速度

在API层的stream处理中通过在trunk之间加入sleep的方式延缓上传。

### 测试

使用cucumber（webrat），参考：[https://github.com/cucumber/cucumber/wiki/PHP]

API and Test Strategy
-----------------------

### GET "/image/#{:image_id}_#{:size}.#{:ext}"

如 /image/3d98fq934rqdfasdfae23r4_960.jpg

表示获取宽度为960像素的图片.

### POST "/upload"

接收参数params[:image]和params[:auth_str]认证字符串
上传图片并动态压缩thumbnail, 返回压缩后的图片.

**CUCUMBER TEST**

- 获取已存在的图片
- 获取图片的不同尺寸版本
- 获取图片不同尺寸的缓存，确认hit（改写原始图片，然后验证缓存的finger print）
- 认证和认证错误（需要mock la-mancha）
- 各种runtime error获得相应图片及status code
- 正确写入日志（需要mock la-mancha）


**CUCUMBER TEST**

- 上传新图片并获取
- 上传后即可获得thumbnail缓存
- 认证和认证错误（需要mock la-mancha）
- 其它上传错误处理（存储I/O error等）
- 正确写入日志（需要mock la-mancha）
- 确认上传速度延迟（需要mock la-mancha）
