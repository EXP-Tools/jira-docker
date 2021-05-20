# JIRA-Docker

此破解版的 JIRA 为 7.5.3。


## 初始化 JIRA 开发环境

- 在当前目录执行 `docker-compose.yml up -d` 启动 JIRA 开发环境
- 启动后，访问 [`http://localhost:8080`](http://localhost:8080) 打开 JIRA
- 初次运行会跳转到 Setup 界面，选择 `I'll set it up myself`，然后点击 `Next`
- 此时会要求配置数据库，选择 `My Own Database`，根据 `docker-compose.yml` 的配置填写数据库配置：
  - Database Type:  Mysql
  - Hostname:       172.168.88.2
  - Port:           3306
  - Database:       jira
  - Username:       jira
  - Password:       123456
- 点击 `Test Connection`，没有异常则点击 `Next`，等待数据库初始化
- 然后会要求填写应用属性：
  - Application Title:  Anyone JIRA
  - Mode:               Private
  - Base URL:           http://127.0.0.1:8080
- 点击 `Next`，此时会提供 Server ID，并要求填写 Your License Key。由于这是破解版（破解原理见下文），这里只需要随便填一个符合格式的 License 即可（此处会做前端的格式校验），例如这个试用版的 License（申请方式见下文，但若没必要就不需要申请了）：

```
AAAB2g0ODAoPeNp9kttum0AQhu95CqTetKpAHHyoLa1UAhsFAtgF6iqWb9YwNqQY8AJOePtysuwGx
3c72jl88//zxQtL1iIVKwmsIM+lybx+qJpXx5LI/IVqBTSP0gSJE0GYCj9kWWT2FCAJ0ywDypuRD
0kOOIiKJgvbHnaWju5ixi4PW6CL3e+87oA4kVHTpCB+YZMDIFGSpyNJkIWfxyPvpwfmNaKEH5QsS
+qHJAeNFIAaIk4Yc5LA9FO9KoO2nbqwLOyoumKev/B7FtHqqm7CibMzArZIFA8ZXKAnoLqGHtauw
q0N+Yl79OQHznRfVh1gRtOg9Au+Cbg83RVvhAJfd4xOgApawr20GoaokBRAu9S4I30ieYgs9U19x
M6rc8RbZXbapyvjebwdGd7uu6qT5xcldCrRpkt3/acM4mD5S1XWEyM4ONm4DJUN2iDGLbe5T6Os9
eHC8rlBN2y8JWitVc2ckMT/RNQ7Kw8M7efUGpu65mKbM8WpOB2PZkLX5qNGdQq6kXZ7mlsQ2lTuS
JwDs6B7kkQ5adceeK1SaH8+XlZvyvnqpf9UasEyGuW92RpcFDdqFNbtUdivzSJst8m3zZzFJxKX7
cBugcHJ3DHgmuC67tKzi/8BJN5ISjAsAhRZIHEuQbkGoHCRSit5W4n8GSiYNQIUK0cCnanxR3KFT
lht2tUwCQi3GkE=X02mi
```

- 点击 `Next`，此时会要求填写 JIRA 管理员信息（不建议修改，后面恢复数据时会覆盖所有用户信息）：
  - Full name:         Administrator
  - Email Address:     admin@xyz.com
  - Username:          admin
  - Password:          admin
  - Confirm Password:  admin
- 点击 `Next`，然后在 Configure Email Notifications 选择 `later`（因为邮箱是假的），点击 `Finish`
- 最后配置语言、头像等，则完成 JIRA 初始化


## 可选：数据迁移

前面创建的 JIRA 完全是空的，可以从其他 JIRA 迁移数据，例如从其他 JIRA 备份了 `jira-backup-20210520.zip` ，迁移步骤如下：

- 执行命令：`cp backup/jira-backup-20210520.zip atlassian/import`
- 访问 [http://localhost:8080/secure/admin/XmlRestore!default.jspa](http://localhost:8080/secure/admin/XmlRestore!default.jspa)
- 在 File name 填入 `jira-backup-20210520.zip`，然后点击 `Restore`
- 恢复数据完成后重新登陆即可

> 注：数据迁移是全库迁移，所以范围包括用户数据，故前面创建的管理员账号在迁移后已经不存在了。另外 License 也会受到迁移影响，慎用此功能。



## 附一：破解原理

破解步骤可参考 [https://github.com/ealebed/jira](https://github.com/ealebed/jira) 。

大概原理是反编译 `atlassian-extras-3.2.jar` 和 `atlassian-universal-plugin-manager-plugin-2.22.4.jar` 这两个 jar 文件，找到其中的 `loadLicenseConfiguration` 函数，把 License 信息硬编码，然后重新编译并覆盖同名 jar 文件即可。

此破解方法不依赖用户填写的 License 内容是什么，所以前面是随便填了一个。

但是因为 JIRA 前端会对 License 格式做校验，因此还是形式上填了一个试用版 License 。


## 附二：90 天试用 License 申请方式

- 在 [Atlassian](https://www.atlassian.com/) 官网注册一个账号（不要用公司邮箱）
- 在 [个人面板](https://my.atlassian.com/product) 中点击 [`New Trial License`](https://my.atlassian.com/license/evaluation)，填写 License 信息：
  - Product:           Jira Software
  - License type:      Jira Software (Data Center)
  - Organization:      [你的注册邮箱]
  - Your instance is:  up and running
  - Server ID:         [在初始化 JIRA 时填写 License 的步骤会得到]
- 点击 `Generate License` 后，可得到 90 天试用的 License Key
