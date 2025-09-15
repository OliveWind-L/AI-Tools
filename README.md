# 终端AI工具安装器

一键安装各种流行的终端AI工具的Shell脚本。

## 功能特性

- 🤖 支持多种主流终端AI工具
- 📋 交互式选择安装
- ✅ 自动验证安装结果
- 🎨 美观的命令行界面
- 🔍 系统环境检查

## 支持的AI工具

| 工具名称 | 描述 | 安装方式 |
|---------|------|---------|
| CodeBuddy Code | 腾讯CodeBuddy官方CLI工具 | npm |
| GitHub Copilot CLI | GitHub Copilot命令行工具 | npm |
| Aider | AI配对编程工具 | pip |
| ChatGPT CLI | ChatGPT命令行接口 | npm |
| Shell GPT | Shell中的GPT助手 | pip |
| AI Shell | AI驱动的Shell助手 | npm |
| Fabric | AI模式框架 | pip |

## 安装使用

### 方式一：Shell脚本 (推荐)

1. 下载脚本：
```bash
curl -O https://raw.githubusercontent.com/your-repo/install-ai-tools.sh
# 或者
wget https://raw.githubusercontent.com/your-repo/install-ai-tools.sh
```

2. 添加执行权限并运行：
```bash
chmod +x install-ai-tools.sh
./install-ai-tools.sh
```

### 方式二：Node.js脚本

1. 克隆项目：
```bash
git clone <repository-url>
cd terminal-ai-installer
```

2. 安装依赖并运行：
```bash
npm install
npm run install-ai-tools
```

## 系统要求

### Shell脚本版本
- Bash shell
- Node.js 和 npm (用于npm工具)
- Python 和 pip (可选，用于Python工具)

### Node.js脚本版本
- Node.js (>= 12.0.0)
- npm
- Python (可选，用于安装基于Python的工具)
- pip (可选，用于安装基于Python的工具)

## 使用说明

### Shell脚本版本
1. 运行脚本后，会显示可用的AI工具列表
2. 输入要安装的工具编号 (多个用空格分隔，如: 1 3 5)
3. 选择最后一个编号可以安装所有工具
4. 确认后开始安装
5. 脚本会自动安装并验证每个工具

### Node.js脚本版本
1. 运行脚本后，会显示可用的AI工具列表
2. 使用空格键选择/取消选择工具
3. 选择"全部安装"可以安装所有工具
4. 按回车键开始安装
5. 脚本会自动安装并验证每个工具

## 注意事项

- 某些工具需要额外的API密钥配置
- Python工具需要系统安装Python和pip
- 部分工具可能需要特定的系统权限
- 建议在安装前检查各工具的官方文档

## 故障排除

### 安装失败
- 检查网络连接
- 确保有足够的系统权限
- 检查Node.js和Python版本

### 验证失败
- 某些工具可能需要重启终端
- 检查PATH环境变量
- 查看工具的官方安装文档

## 贡献

欢迎提交Issue和Pull Request来添加更多AI工具或改进脚本功能。

## 许可证

MIT License
