# 使用 Ubuntu 作为基础镜像（与服务器环境一致）
FROM ubuntu:22.04

# 安装 nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# 复制网站文件到 nginx 默认目录
COPY index.html /var/www/html/
COPY style.css /var/www/html/
COPY script.js /var/www/html/

# 复制自定义 nginx 配置（可选）
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]