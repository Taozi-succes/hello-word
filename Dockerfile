# 基础镜像
FROM nginx:alpine

# 复制自定义 nginx 配置（如果没有自定义配置，这行可以删）
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]