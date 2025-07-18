# 🌟 Hello World 项目

一个简单而美观的"你好世界"网站，适合初学者学习和部署。

## 📋 项目简介

这是一个现代化的 Hello World 网站，具有以下特点：
- 🎨 美观的渐变背景和毛玻璃效果
- 📱 响应式设计，支持手机和电脑
- 🌙 深色/浅色主题切换
- ⏰ 实时时间显示
- 📊 访问次数统计
- 🖥️ 系统信息查看
- ✨ 流畅的动画效果

## 📁 项目结构

```
hello-word/
├── index.html          # 主页面
├── style.css           # 样式文件
├── script.js           # JavaScript 功能
├── README.md           # 项目说明
├── docker-compose.yml  # Docker 配置
└── .gitignore          # Git 忽略文件
```

## 🚀 快速开始

### 方法1：直接打开
直接用浏览器打开 `index.html` 文件即可预览。

### 方法2：本地服务器
```bash
# 使用 Python 启动本地服务器
python -m http.server 8000

# 或使用 Node.js
npx serve .

# 然后访问 http://localhost:8000
```

### 方法3：Docker 部署
```bash
# 使用 Docker 部署
docker run -d --name hello-world -p 80:80 -v $(pwd):/usr/share/nginx/html nginx:alpine

# 或使用 docker-compose
docker-compose up -d
```

## 🌐 云服务器部署

### 1. 上传文件到服务器
```bash
# 使用 SCP 上传
scp -r hello-word/ root@your-server-ip:/root/

# 或使用 Git
git clone https://github.com/your-username/hello-world.git
```

### 2. 部署网站
```bash
# 进入项目目录
cd /root/hello-word

# 启动 Docker 容器
docker run -d --name hello-world -p 80:80 -v $(pwd):/usr/share/nginx/html nginx:alpine

# 检查状态
docker ps
```

### 3. 访问网站
在浏览器中输入你的服务器IP地址即可访问。

## 🎮 功能说明

### 主要功能
- **实时时间**：显示当前日期和时间，每秒更新
- **访问统计**：记录页面访问次数（使用 localStorage）
- **主题切换**：支持深色和浅色主题切换
- **系统信息**：显示浏览器和系统相关信息
- **响应式设计**：自适应不同屏幕尺寸

### 快捷键
- `T` 键：快速切换主题
- `ESC` 键：关闭弹窗

### 动画效果
- 页面加载动画
- 按钮悬停效果
- 主题切换过渡
- 模态框弹出动画

## 🛠️ 技术栈

- **HTML5**：语义化标签，SEO 友好
- **CSS3**：Flexbox、Grid、动画、毛玻璃效果
- **JavaScript ES6+**：模块化、本地存储、事件处理
- **Docker**：容器化部署
- **Nginx**：Web 服务器

## 📱 浏览器支持

- ✅ Chrome 60+
- ✅ Firefox 55+
- ✅ Safari 12+
- ✅ Edge 79+
- ✅ 移动端浏览器

## 🔧 自定义配置

### 修改主题颜色
在 `style.css` 中修改 CSS 变量：
```css
body {
    background: linear-gradient(135deg, #your-color1 0%, #your-color2 100%);
}
```

### 添加新功能
在 `script.js` 中添加新的 JavaScript 功能。

### 修改内容
在 `index.html` 中修改页面内容和结构。

## 📊 性能优化

- 使用 CSS3 硬件加速
- 图片懒加载（如需要）
- 代码压缩和合并
- CDN 加速（可选）

## 🐛 故障排除

### 常见问题

1. **页面无法访问**
   - 检查服务器防火墙设置
   - 确认 Docker 容器正在运行
   - 验证端口映射是否正确

2. **样式不显示**
   - 检查文件路径是否正确
   - 确认 CSS 文件是否存在
   - 查看浏览器控制台错误

3. **JavaScript 功能异常**
   - 打开浏览器开发者工具
   - 查看控制台错误信息
   - 检查文件引用路径

## 📈 后续改进

- [ ] 添加更多主题选项
- [ ] 集成天气 API
- [ ] 添加音乐播放器
- [ ] 实现用户留言功能
- [ ] 添加访问统计图表
- [ ] 支持多语言切换

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 👨‍💻 作者

- 你的名字
- 邮箱：your-email@example.com
- GitHub：[@your-username](https://github.com/your-username)

## 🙏 致谢

感谢所有为这个项目提供帮助的朋友们！

---

⭐ 如果这个项目对你有帮助，请给个 Star！



docker脚本：
            docker build -t nginx-custom . && \
            docker stop my-nginx || true && \
            docker rm my-nginx || true && \
            docker run -d -p 80:80 -v /root/hello-world/hello-word/dist:/usr/share/nginx/html:ro --name my-nginx nginx-custom