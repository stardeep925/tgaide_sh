# tgaide_sh

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000)
![License: GPL-3.0](https://img.shields.io/badge/License-GPL%203.0-blue.svg)
[![Telegram Group](https://img.shields.io/badge/Telegram-Group-blue.svg)](https://t.me/tgaide)
[![Author](https://img.shields.io/badge/Author-@drstth-blue.svg)](https://t.me/drstth)

### 🚀 PagerMaid 自动重启管理脚本
*一个强大的 PagerMaid 进程管理和自动重启解决方案*

[简体中文](README.md) | [English](README_en.md) | [联系作者](https://t.me/drstth) | [交流群](https://t.me/tgaide)

</div>

---

## 📖 项目介绍

`tgaide_sh` 是一个专门为 PagerMaid-Modify 设计的进程管理脚本，提供了全面的进程监控、自动重启和状态管理功能。无论您是个人用户还是服务器管理员，这个脚本都能帮助您轻松管理 PagerMaid 进程。

### ✨ 主要特性

<table>
<tr>
    <td>🔄 定时重启</td>
    <td>⚡ 快速部署</td>
    <td>📊 状态监控</td>
</tr>
<tr>
    <td>🛡️ 进程保护</td>
    <td>📝 日志记录</td>
    <td>🚀 后台运行</td>
</tr>
</table>

## 🎯 功能亮点

- **智能进程管理**
  - 自动检测进程状态
  - 异常退出自动恢复
  - 定时重启确保稳定

- **灵活配置选项**
  - 自定义安装路径
  - 可调节重启间隔
  - 配置持久化存储

- **完善的日志系统**
  - 详细的操作记录
  - 时间戳标记
  - 错误追踪

- **用户友好设计**
  - 简单的命令体系
  - 清晰的状态展示
  - 人性化的配置流程

## 💻 安装指南

### 系统要求

- Python 3.6 或更高版本
- Linux/Unix 系统
- root 权限或适当的执行权限

### 快速安装

1. **下载脚本**
   ```bash
   wget https://raw.githubusercontent.com/stardeep925/tgaide_sh/main/pag.sh
   ```

2. **设置权限**
   ```bash
   chmod +x pag.sh
   ```

3. **验证安装**
   ```bash
   ./pag.sh help
   ```

## 🎮 使用指南

### 基础命令

| 命令 | 说明 |
|------|------|
| `./pag.sh start` | 启动服务 |
| `./pag.sh stop` | 停止服务 |
| `./pag.sh restart` | 重启服务 |
| `./pag.sh status` | 查看状态 |
| `./pag.sh help` | 显示帮助 |

### 首次配置流程

1. **运行脚本**
   ```bash
   ./pag.sh start
   ```

2. **配置选项**
   - 设置安装路径（默认：/var/lib/pagermaid）
   - 设置重启间隔（默认：24小时）

3. **确认运行**
   ```bash
   ./pag.sh status
   ```

### 配置文件说明

| 文件 | 路径 | 用途 |
|------|------|------|
| 配置文件 | `~/.pag_restart_config` | 存储基本配置 |
| 日志文件 | `~/.pag_restart.log` | 记录运行日志 |
| PID文件 | `~/.pag_restart.pid` | 进程ID管理 |

## 📝 日志管理

### 查看实时日志
```bash
tail -f ~/.pag_restart.log
```

### 日志内容包括
- 服务启动/停止记录
- 重启操作记录
- 错误警告信息
- 状态变更记录

## ⚠️ 注意事项

### 安装前准备
1. 确认 Python 3 环境
2. 检查系统权限
3. 确保网络连接

### 运行时注意
1. 避免重复启动
2. 定期检查日志
3. 合理设置重启间隔

### 故障排除
1. 检查进程状态
2. 查看错误日志
3. 确认配置正确

## 🔧 高级配置

### 自定义配置
- 修改配置文件参数
- 调整日志记录级别
- 设置进程优先级

### 性能优化
- 合理设置重启间隔
- 监控资源占用
- 优化启动参数

## 📚 常见问题

<details>
<summary><b>服务无法启动？</b></summary>

1. 检查 Python 版本
2. 确认权限设置
3. 查看错误日志
</details>

<details>
<summary><b>进程异常退出？</b></summary>

1. 检查系统资源
2. 查看 PagerMaid 日志
3. 确认网络状态
</details>

<details>
<summary><b>配置文件错误？</b></summary>

1. 删除现有配置
2. 重新运行配置
3. 检查文件权限
</details>

## 🔄 版本历史

### v1.0.0 (2024-01)
- 🎉 首次发布
- ✨ 基础功能实现
- 📝 完善文档支持

## 👥 参与贡献

欢迎参与项目开发，您可以：

- 提交 [Issue](https://github.com/stardeep925/tgaide_sh/issues)
- 提出新功能建议
- 改进现有代码
- 完善项目文档

## 📄 开源协议

本项目采用 [GPL-3.0](LICENSE) 许可证。

## 🤝 联系方式

- 作者：[@drstth](https://t.me/drstth)
- 交流群：[@tgaide](https://t.me/tgaide)
- 问题反馈：[GitHub Issues](https://github.com/stardeep925/tgaide_sh/issues)

---

<div align="center">

**如果这个项目对您有帮助，请考虑给它一个 Star ⭐️**

</div>
