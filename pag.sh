#!/bin/bash
# @drstth 开发编写，目前版本：1.0.0
CONFIG_FILE="$HOME/.pag_restart_config"
LOG_FILE="$HOME/.pag_restart.log"
PID_FILE="$HOME/.pag_restart.pid"

DEFAULT_PATH="/var/lib/pagermaid"
DEFAULT_INTERVAL=24

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

show_help() {
    echo "用法: $0 [命令]"
    echo "命令:"
    echo "  start    - 启动 PagerMaid 自动重启服务"
    echo "  stop     - 停止 PagerMaid 自动重启服务"
    echo "  restart  - 重启 PagerMaid 自动重启服务"
    echo "  status   - 查看服务运行状态"
    echo "  help     - 显示此帮助信息"
}

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        return 0
    fi
    return 1
}

save_config() {
    echo "INSTALL_PATH=\"$INSTALL_PATH\"" > "$CONFIG_FILE"
    echo "RESTART_INTERVAL=$RESTART_INTERVAL" >> "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
}

get_user_input() {
    echo "未找到配置文件，请进行首次配置："
    
    read -p "请输入 PagerMaid 安装路径 (直接回车使用默认值 $DEFAULT_PATH): " input_path
    INSTALL_PATH=${input_path:-$DEFAULT_PATH}
    
    while true; do
        read -p "请输入重启间隔小时数 (直接回车使用默认值 $DEFAULT_INTERVAL): " input_interval
        input_interval=${input_interval:-$DEFAULT_INTERVAL}
        if [[ "$input_interval" =~ ^[0-9]+$ ]]; then
            RESTART_INTERVAL=$input_interval
            break
        else
            echo "错误：请输入有效的数字"
        fi
    done
    
    save_config
}

check_dependencies() {
    command -v python3 >/dev/null 2>&1 || { echo "错误：未安装 python3"; exit 1; }
}

verify_path() {
    if [ ! -d "$INSTALL_PATH" ]; then
        log "错误：安装路径 $INSTALL_PATH 不存在"
        exit 1
    fi
}

get_service_pid() {
    if [ -f "$PID_FILE" ]; then
        local pid
        pid=$(cat "$PID_FILE")
        if ps -p "$pid" | grep -q "pag_daemon.sh"; then
            echo "$pid"
            return 0
        fi
    fi
    pgrep -f "pag_daemon.sh"
    return $?
}

stop_pagermaid() {
    log "正在停止 PagerMaid..."
    pkill -f "python3 -m pagermaid"
    sleep 2
    if ! pgrep -f "python3 -m pagermaid" > /dev/null; then
        log "PagerMaid 已停止"
        return 0
    else
        log "PagerMaid 停止失败"
        return 1
    fi
}

restart_pagermaid() {
    cd "$INSTALL_PATH" || exit 1
    log "正在重启 PagerMaid..."
    stop_pagermaid
    sleep 2
    nohup python3 -m pagermaid > /dev/null 2>&1 &
    log "PagerMaid 已重启"
}

check_status() {
    local service_pid
    service_pid=$(get_service_pid)
    
    if [ -n "$service_pid" ]; then
        echo "PagerMaid 自动重启服务正在运行 (PID: $service_pid)"
        if pgrep -f "python3 -m pagermaid" > /dev/null; then
            echo "PagerMaid 进程正在运行"
        else
            echo "警告：PagerMaid 进程未运行"
        fi
        return 0
    else
        echo "PagerMaid 自动重启服务未运行"
        if pgrep -f "python3 -m pagermaid" > /dev/null; then
            echo "注意：PagerMaid 进程正在运行，但自动重启服务未运行"
        fi
        return 1
    fi
}

stop_service() {
    local service_pid
    service_pid=$(get_service_pid)
    
    if [ -n "$service_pid" ]; then
        log "正在停止服务 (PID: $service_pid)..."
        kill -9 "$service_pid" 2>/dev/null
        pkill -f "pag_daemon.sh"
        stop_pagermaid
        rm -f "$PID_FILE"
        rm -f "/tmp/pag_daemon.sh"
        log "服务已停止"
        echo "PagerMaid 自动重启服务已停止"
        return 0
    else
        if pgrep -f "python3 -m pagermaid" > /dev/null; then
            echo "自动重启服务未运行，但发现 PagerMaid 进程"
            read -p "是否停止 PagerMaid 进程？(y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                stop_pagermaid
            fi
        else
            echo "服务未运行"
        fi
        return 1
    fi
}

daemon_loop() {
    while true; do
        restart_pagermaid
        sleep $((RESTART_INTERVAL * 3600))
    done
}

start_service() {
    check_dependencies
    
    local service_pid
    service_pid=$(get_service_pid)
    
    if [ -n "$service_pid" ]; then
        echo "服务已在运行中 (PID: $service_pid)"
        exit 1
    fi
    
    if ! load_config; then
        get_user_input
    fi
    
    verify_path

    cat > "/tmp/pag_daemon.sh" << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$HOME/.pag_restart.pid"
LOG_FILE="$HOME/.pag_restart.log"

echo $$ > "$PID_FILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

source "$HOME/.pag_restart_config"

start_pagermaid() {
    if ! pgrep -f "python3 -m pagermaid" > /dev/null; then
        log "启动 PagerMaid..."
        cd "$INSTALL_PATH" || exit 1
        nohup python3 -m pagermaid > /dev/null 2>&1 &
        sleep 5
        if pgrep -f "python3 -m pagermaid" > /dev/null; then
            log "PagerMaid 启动成功"
            return 0
        else
            log "PagerMaid 启动失败"
            return 1
        fi
    else
        log "PagerMaid 已经在运行"
        return 0
    fi
}

stop_pagermaid() {
    log "停止 PagerMaid..."
    pkill -f "python3 -m pagermaid"
    sleep 2
    if ! pgrep -f "python3 -m pagermaid" > /dev/null; then
        log "PagerMaid 已停止"
        return 0
    else
        log "PagerMaid 停止失败，尝试强制终止"
        pkill -9 -f "python3 -m pagermaid"
        sleep 1
        return 0
    fi
}

cleanup() {
    log "守护进程正在退出..."
    stop_pagermaid
    rm -f "$PID_FILE"
    exit 0
}

trap cleanup EXIT INT TERM
cd "$INSTALL_PATH" || exit 1

log "守护进程已启动，间隔时间：$RESTART_INTERVAL 小时"
start_pagermaid
while true; do
    if ! pgrep -f "python3 -m pagermaid" > /dev/null; then
        log "检测到 PagerMaid 未运行，正在重新启动..."
        start_pagermaid
    fi

    log "等待 $RESTART_INTERVAL 小时后重启..."
    sleep $((RESTART_INTERVAL * 3600))
    log "执行定时重启..."
    stop_pagermaid
    sleep 2
    start_pagermaid
done
EOF
    
    chmod +x "/tmp/pag_daemon.sh"
    
    nohup "/tmp/pag_daemon.sh" > /dev/null 2>&1 &
    
    sleep 2
    
    if get_service_pid > /dev/null; then
        log "PagerMaid 自动重启服务已启动"
        log "重启间隔：$RESTART_INTERVAL 小时"
        log "安装路径：$INSTALL_PATH"
        
        echo "PagerMaid 自动重启服务已在后台启动"
        echo "重启间隔：$RESTART_INTERVAL 小时"
        echo "安装路径：$INSTALL_PATH"
        echo "日志文件：$LOG_FILE"
        echo "PID文件：$PID_FILE"
    else
        echo "服务启动失败"
        rm -f "$PID_FILE"
        rm -f "/tmp/pag_daemon.sh"
        exit 1
    fi
}

cleanup() {
    rm -f "$PID_FILE"
    log "服务已停止"
    exit 0
}

trap cleanup EXIT
trap 'cleanup' INT TERM

case "${1:-help}" in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    restart)
        stop_service
        sleep 2
        start_service
        ;;
    status)
        check_status
        ;;
    help)
        show_help
        ;;
    _daemon)
        daemon_loop
        ;;
    *)
        show_help
        exit 1
        ;;
esac
