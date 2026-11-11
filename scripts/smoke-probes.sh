# shellcheck shell=bash
# scripts/smoke.sh 的一项一项探测，跟着插件走。没写的项会 FAIL 并给出写法，不会默认放行。
#
# Zigbee2MQTT 没有用户体系：网页经云吞网关登录，前端自己只认清单 secrets 里生成的访问令牌，
# 没有“当前用户”接口，身份项记 N/A。没有 mcp，工具项由套件按清单记 N/A。
#
# 用户数据（configuration.yaml 的修改、database.db 的配对记录）的“重装保留”核对写在开发栈验证里：
# 探针要应用可写才能写数据，冒烟机没有协调器，应用起不到可写状态（上游行为：协调器打不开就退出）。

web_assert() { grep -q '<title>Zigbee2MQTT</title>'; }

export IDENTITY_NA=1
export SMOKE_NOTE="应用没有用户体系：网页认证靠云吞网关加前端访问令牌"
export DATA_NA=1
