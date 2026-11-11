# 云吞插件：Zigbee2MQTT

开发流程见[插件开发指南](https://github.com/wontonapp/wonton-docs/blob/main/develop.md)。

云吞（Wonton）的 Zigbee2MQTT 插件：用 USB Zigbee 棒（协调器）接入各厂商的 Zigbee 传感器、开关和灯，不依赖小米、涂鸦的网关。设备状态和控制经 MQTT 收发，网页里可以看设备、改名和控制。

这个插件使用上游官方镜像 `ghcr.io/koenkk/zigbee2mqtt`（GPL-3.0），按清单摘要固定；配置经上游的 `ZIGBEE2MQTT_CONFIG_*` 环境变量注入，优先级高于 `configuration.yaml`。

## 使用前提

- **MQTT**：需要安装一个提供 `x-wonton.mqtt` 能力的插件（同批的 mosquitto）。装本插件时云吞会列出可用的提供方，选中即接上；MQTT 地址由云吞注入，不用手填。
- **协调器**：安装时按提示选择插在服务器上的 Zigbee 棒（优先用 `/dev/serial/by-id/` 路径，拔插后编号不变）。支持的硬件和适配器类型见[上游适配器文档](https://www.zigbee2mqtt.io/guide/configuration/adapter-settings.html)；适配器类型不填时上游自动探测。

## 网页和令牌

网页经云吞网关访问（`sso: none`，应用自己的令牌认证）。前端 WebSocket 用一个由云吞生成的访问令牌（清单 `secrets.frontend_token`）保护，装好即生效，不用手动填；主人可以在插件详情页查看。

## 已知限制

- **串口设备授权未接入**：清单需要按 [ADR 的设备授权写法](https://github.com/wontonapp/wonton)声明 `devices.serial`（target `/dev/zigbee`），云吞核心尚未支持该权限，装上的版本连不到协调器（启动即报错退出）。核心支持后补上声明，本插件不用 privileged 或宿主网络绕过。
- **MQTT 提供方地址**：清单按规范引用 `WONTON_X_WONTON_MQTT_URL`，核心尚未为第三方能力（`x-` 前缀）注入这个变量，装的时候会报变量未定义。核心支持后即可安装。
- 运行期不出网；只有设备 OTA 固件更新按需从厂商服务器下载，本插件未申请出网权限，OTA 不可用。
- Agent 控制：上游只有 MQTT 主题接口（`zigbee2mqtt/bridge/request/*`），没有 HTTP API 和 MCP，Agent 经 MQTT 使用。

## 图标来源与许可

`icon.svg` 使用 Zigbee2MQTT 官方标志；来源、处理方式、许可证全文和商标说明见 [NOTICE](NOTICE)。

## 先跑起来

```bash
scripts/dev.sh up
scripts/dev.sh install
```

`up` 在本机起一套云吞，打印它的地址。`install` 先列出插件要的权限和 MQTT 提供方，确认后装上。开发机通常没有 Zigbee 棒，应用会在健康检查处如实失败，日志里是上游的协调器连接错误——这是没有硬件时的预期行为，不是插件坏了。

## 仓库里有什么

| 路径 | 内容 |
| --- | --- |
| `docker-compose.yml` | 插件本身：Compose 加上 `x-wonton` 清单 |
| `icon.svg`、`config/` | 清单和 Compose 引用的文件：官方图标、首次启动种下的最小配置 |
| `scripts/check.sh` | 检查插件包，规则和安装时一样 |
| `scripts/dev.sh` | 开发环境：起一套云吞，装、重装、卸载插件，看日志 |
| `scripts/smoke-probes.sh` | `scripts/dev.sh smoke` 对这个插件逐项的探测 |
| `scripts/publish.sh` | 发布一个版本：打 tag、推送 |
| `AGENTS.md` | 给人和 AI 编程代理的规则 |
| `LICENSE`、`NOTICE` | 插件包许可证（MIT）、上游许可证和商标声明 |
| `.wonton/` | 开发环境的设置、密钥和数据，不提交 |
