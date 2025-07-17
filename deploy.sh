#!/bin/bash

# Hello World 项目部署脚本
# 适用于 Linux 服务器

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_NAME="hello-world"
CONTAINER_NAME="hello-world-app"
PORT="80"
IMAGE="nginx:alpine"

# 函数：打印带颜色的消息
print_message() {
    echo -e "${2}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

print_success() {
    print_message "✅ $1" "$GREEN"
}

print_error() {
    print_message "❌ $1" "$RED"
}

print_warning() {
    print_message "⚠️  $1" "$YELLOW"
}

print_info() {
    print_message "ℹ️  $1" "$BLUE"
}

# 函数：检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 命令未找到，请先安装 $1"
        exit 1
    fi
}

# 函数：检查 Docker 是否运行
check_docker() {
    if ! docker info &> /dev/null; then
        print_error "Docker 未运行，请启动 Docker 服务"
        exit 1
    fi
}

# 函数：停止并删除现有容器
stop_existing_container() {
    if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        print_info "停止现有容器: $CONTAINER_NAME"
        docker stop $CONTAINER_NAME || true
        docker rm $CONTAINER_NAME || true
        print_success "已清理现有容器"
    fi
}

# 函数：部署应用
deploy_app() {
    print_info "开始部署 $PROJECT_NAME..."
    
    # 获取当前目录的绝对路径
    CURRENT_DIR=$(pwd)
    
    # 启动新容器
    print_info "启动新容器..."
    docker run -d \
        --name $CONTAINER_NAME \
        --restart unless-stopped \
        -p $PORT:80 \
        -v "$CURRENT_DIR:/usr/share/nginx/html:ro" \
        -v "$CURRENT_DIR/nginx.conf:/etc/nginx/nginx.conf:ro" \
        $IMAGE
    
    print_success "容器启动成功！"
}

# 函数：检查部署状态
check_deployment() {
    print_info "检查部署状态..."
    
    # 等待容器启动
    sleep 3
    
    # 检查容器是否运行
    if docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        print_success "容器运行正常"
        
        # 获取服务器IP
        SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || echo "localhost")
        
        print_success "部署完成！"
        echo -e "${GREEN}🌐 访问地址: http://$SERVER_IP:$PORT${NC}"
        echo -e "${GREEN}📱 本地访问: http://localhost:$PORT${NC}"
        
        # 显示容器信息
        echo -e "\n${BLUE}📊 容器信息:${NC}"
        docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        
    else
        print_error "容器启动失败"
        print_info "查看容器日志:"
        docker logs $CONTAINER_NAME
        exit 1
    fi
}

# 函数：显示管理命令
show_management_commands() {
    echo -e "\n${YELLOW}📋 管理命令:${NC}"
    echo "  查看日志: docker logs $CONTAINER_NAME"
    echo "  停止服务: docker stop $CONTAINER_NAME"
    echo "  启动服务: docker start $CONTAINER_NAME"
    echo "  重启服务: docker restart $CONTAINER_NAME"
    echo "  删除容器: docker rm -f $CONTAINER_NAME"
    echo "  进入容器: docker exec -it $CONTAINER_NAME sh"
    echo "  查看状态: docker ps | grep $CONTAINER_NAME"
}

# 函数：使用 docker-compose 部署
deploy_with_compose() {
    if [ -f "docker-compose.yml" ]; then
        print_info "发现 docker-compose.yml，使用 Docker Compose 部署..."
        
        # 停止现有服务
        docker-compose down 2>/dev/null || true
        
        # 启动服务
        docker-compose up -d
        
        print_success "Docker Compose 部署完成！"
        
        # 显示服务状态
        echo -e "\n${BLUE}📊 服务状态:${NC}"
        docker-compose ps
        
        return 0
    fi
    return 1
}

# 主函数
main() {
    echo -e "${BLUE}"
    echo "================================================"
    echo "🚀 Hello World 项目部署脚本"
    echo "================================================"
    echo -e "${NC}"
    
    # 检查依赖
    print_info "检查系统依赖..."
    check_command "docker"
    check_docker
    
    # 检查项目文件
    if [ ! -f "index.html" ]; then
        print_error "未找到 index.html 文件，请确保在项目根目录运行此脚本"
        exit 1
    fi
    
    print_success "项目文件检查通过"
    
    # 尝试使用 docker-compose 部署
    if ! deploy_with_compose; then
        # 使用 docker run 部署
        stop_existing_container
        deploy_app
    fi
    
    # 检查部署状态
    check_deployment
    
    # 显示管理命令
    show_management_commands
    
    echo -e "\n${GREEN}🎉 部署完成！享受你的 Hello World 网站吧！${NC}"
}

# 处理命令行参数
case "${1:-}" in
    "stop")
        print_info "停止服务..."
        docker stop $CONTAINER_NAME 2>/dev/null || print_warning "容器未运行"
        docker-compose down 2>/dev/null || true
        print_success "服务已停止"
        ;;
    "restart")
        print_info "重启服务..."
        docker restart $CONTAINER_NAME 2>/dev/null || {
            print_warning "容器未运行，开始重新部署..."
            main
        }
        print_success "服务已重启"
        ;;
    "logs")
        print_info "显示日志..."
        docker logs -f $CONTAINER_NAME
        ;;
    "status")
        print_info "服务状态:"
        docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        docker-compose ps 2>/dev/null || true
        ;;
    "clean")
        print_info "清理资源..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        docker-compose down 2>/dev/null || true
        print_success "清理完成"
        ;;
    "help")
        echo "用法: $0 [命令]"
        echo "命令:"
        echo "  (无参数)  - 部署应用"
        echo "  stop      - 停止服务"
        echo "  restart   - 重启服务"
        echo "  logs      - 查看日志"
        echo "  status    - 查看状态"
        echo "  clean     - 清理资源"
        echo "  help      - 显示帮助"
        ;;
    "")
        main
        ;;
    *)
        print_error "未知命令: $1"
        echo "使用 '$0 help' 查看帮助"
        exit 1
        ;;
esac