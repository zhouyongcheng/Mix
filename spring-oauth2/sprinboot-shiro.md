## 系统的安全

### ![](C:\data\github\Mix\pic\shiro-frame.webp)

## Shiro架构

## ![](C:\data\github\Mix\pic\shiro架构.webp)

### Subject

```tex
系统中参与安全相关的主要对象，应用系统主要使用该对象来操作安全相关内容。通过subject来进行认证和授权操作。
```

### SecurityManager

```
安全相关的各种配置，应用基本不和securityManager交换，只要配置完成，就完成了使命。提供Subject需要使用的所有基础设施。
```

### Realms

```
Security和系统的安全数据之间的桥梁。是系统数据的对外开发的通道，同时是SecurityManager访问的接口。
```

## 架构详细

## ![](C:\data\github\Mix\pic\shiro架构详细.webp)