// 全局变量
let visitCount = 1;
let isDarkTheme = false;

// DOM 加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

// 初始化应用
function initializeApp() {
    updateTime();
    loadVisitCount();
    setupEventListeners();
    showWelcomeMessage();
    
    // 每秒更新时间
    setInterval(updateTime, 1000);
}

// 更新时间显示
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        weekday: 'long'
    });
    
    const timeElement = document.getElementById('current-time');
    if (timeElement) {
        timeElement.textContent = timeString;
    }
}

// 加载访问次数
function loadVisitCount() {
    // 从 localStorage 获取访问次数
    const stored = localStorage.getItem('visitCount');
    if (stored) {
        visitCount = parseInt(stored) + 1;
    } else {
        visitCount = 1;
    }
    
    // 更新显示
    updateVisitCount();
    
    // 保存到 localStorage
    localStorage.setItem('visitCount', visitCount.toString());
}

// 更新访问次数显示
function updateVisitCount() {
    const countElement = document.getElementById('visit-count');
    if (countElement) {
        countElement.textContent = visitCount;
        
        // 添加动画效果
        countElement.style.transform = 'scale(1.2)';
        setTimeout(() => {
            countElement.style.transform = 'scale(1)';
        }, 200);
    }
}

// 设置事件监听器
function setupEventListeners() {
    // 主题切换按钮
    const themeBtn = document.getElementById('change-theme');
    if (themeBtn) {
        themeBtn.addEventListener('click', toggleTheme);
    }
    
    // 系统信息按钮
    const infoBtn = document.getElementById('show-info');
    if (infoBtn) {
        infoBtn.addEventListener('click', showSystemInfo);
    }
    
    // 模态框关闭
    const modal = document.getElementById('info-modal');
    const closeBtn = document.querySelector('.close');
    
    if (closeBtn) {
        closeBtn.addEventListener('click', closeModal);
    }
    
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeModal();
            }
        });
    }
    
    // 键盘事件
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
        }
        if (e.key === 't' || e.key === 'T') {
            toggleTheme();
        }
    });
    
    // 页面可见性变化
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            updateTime();
        }
    });
}

// 切换主题
function toggleTheme() {
    isDarkTheme = !isDarkTheme;
    const body = document.body;
    const themeBtn = document.getElementById('change-theme');
    
    if (isDarkTheme) {
        body.classList.add('dark-theme');
        if (themeBtn) {
            themeBtn.innerHTML = '☀️ 切换主题';
        }
    } else {
        body.classList.remove('dark-theme');
        if (themeBtn) {
            themeBtn.innerHTML = '🌙 切换主题';
        }
    }
    
    // 保存主题偏好
    localStorage.setItem('darkTheme', isDarkTheme.toString());
    
    // 添加切换动画
    body.style.transition = 'all 0.3s ease';
}

// 显示系统信息
function showSystemInfo() {
    const modal = document.getElementById('info-modal');
    const systemInfo = document.getElementById('system-info');
    
    if (modal && systemInfo) {
        // 收集系统信息
        const info = {
            '浏览器': navigator.userAgent.split(' ').pop(),
            '语言': navigator.language,
            '平台': navigator.platform,
            '屏幕分辨率': `${screen.width} x ${screen.height}`,
            '窗口大小': `${window.innerWidth} x ${window.innerHeight}`,
            '时区': Intl.DateTimeFormat().resolvedOptions().timeZone,
            '在线状态': navigator.onLine ? '在线' : '离线',
            '访问时间': new Date().toLocaleString('zh-CN'),
            'Cookie 启用': navigator.cookieEnabled ? '是' : '否',
            'Java 启用': navigator.javaEnabled() ? '是' : '否'
        };
        
        // 生成信息HTML
        let infoHTML = '';
        for (const [key, value] of Object.entries(info)) {
            infoHTML += `<p><strong>${key}:</strong> ${value}</p>`;
        }
        
        systemInfo.innerHTML = infoHTML;
        modal.style.display = 'block';
        
        // 添加显示动画
        setTimeout(() => {
            modal.style.opacity = '1';
        }, 10);
    }
}

// 关闭模态框
function closeModal() {
    const modal = document.getElementById('info-modal');
    if (modal) {
        modal.style.opacity = '0';
        setTimeout(() => {
            modal.style.display = 'none';
        }, 300);
    }
}

// 显示欢迎消息
function showWelcomeMessage() {
    // 检查是否是首次访问
    const isFirstVisit = !localStorage.getItem('hasVisited');
    
    if (isFirstVisit) {
        setTimeout(() => {
            alert('🎉 欢迎访问我的第一个网站！\n\n💡 小贴士：\n- 按 T 键快速切换主题\n- 按 ESC 键关闭弹窗\n- 点击"系统信息"查看详细信息');
            localStorage.setItem('hasVisited', 'true');
        }, 1000);
    }
}

// 页面加载时恢复主题设置
window.addEventListener('load', function() {
    const savedTheme = localStorage.getItem('darkTheme');
    if (savedTheme === 'true') {
        isDarkTheme = true;
        document.body.classList.add('dark-theme');
        const themeBtn = document.getElementById('change-theme');
        if (themeBtn) {
            themeBtn.innerHTML = '☀️ 切换主题';
        }
    }
});

// 添加一些有趣的交互效果
document.addEventListener('mousemove', function(e) {
    // 鼠标跟随效果（可选）
    const cursor = document.querySelector('.cursor');
    if (cursor) {
        cursor.style.left = e.clientX + 'px';
        cursor.style.top = e.clientY + 'px';
    }
});

// 页面滚动效果
window.addEventListener('scroll', function() {
    const scrolled = window.pageYOffset;
    const parallax = document.querySelector('.header');
    if (parallax) {
        const speed = scrolled * 0.5;
        parallax.style.transform = `translateY(${speed}px)`;
    }
});

// 错误处理
window.addEventListener('error', function(e) {
    console.error('页面错误:', e.error);
});

// 性能监控
window.addEventListener('load', function() {
    const loadTime = performance.now();
    console.log(`页面加载时间: ${loadTime.toFixed(2)}ms`);
});

// 导出函数供其他脚本使用
window.HelloWorld = {
    updateTime,
    toggleTheme,
    showSystemInfo,
    closeModal
};