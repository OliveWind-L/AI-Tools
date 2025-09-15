#!/bin/bash

# 终端AI工具安装脚本 (macOS兼容版)
# 支持一键安装多种流行的终端AI工具

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# AI工具定义
TOOL_KEYS=("codebuddy-code" "github-copilot-cli" "aider-chat" "chatgpt-cli" "shell-gpt" "ai-shell" "fabric")

TOOL_NAMES=(
    "CodeBuddy Code"
    "GitHub Copilot CLI"
    "Aider"
    "ChatGPT CLI"
    "Shell GPT"
    "AI Shell"
    "Fabric"
)

TOOL_DESCS=(
    "腾讯CodeBuddy官方CLI工具"
    "GitHub Copilot命令行工具"
    "AI配对编程工具"
    "ChatGPT命令行接口"
    "Shell中的GPT助手"
    "AI驱动的Shell助手"
    "AI模式框架"
)

TOOL_INSTALLS=(
    "npm install -g @tencent-ai/codebuddy-code"
    "npm install -g @githubnext/github-copilot-cli"
    "pip3 install aider-chat"
    "npm install -g chatgpt-cli"
    "pip3 install shell-gpt"
    "npm install -g @builder.io/ai-shell"
    "pip3 install fabric-ai"
)

TOOL_VERIFIES=(
    "codebuddy --version 2>/dev/null || echo \"codebuddy installed\""
    "github-copilot-cli --version 2>/dev/null || echo \"github-copilot-cli installed\""
    "aider --version 2>/dev/null || echo \"aider installed\""
    "chatgpt --version 2>/dev/null || echo \"chatgpt-cli installed\""
    "sgpt --version 2>/dev/null || echo \"shell-gpt installed\""
    "ai --version 2>/dev/null || echo \"ai-shell installed\""
    "fabric --version 2>/dev/null || echo \"fabric installed\""
)

# 打印带颜色的消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查系统环境
check_prerequisites() {
    print_message "$CYAN" "🔍 检查系统环境..."
    
    # 检查Node.js和npm
    if ! command_exists node || ! command_exists npm; then
        print_message "$RED" "❌ Node.js 或 npm 未安装"
        print_message "$YELLOW" "请先安装 Node.js: https://nodejs.org/"
        print_message "$YELLOW" "或使用 Homebrew: brew install node"
        exit 1
    fi
    
    # 检查Python (macOS通常使用python3)
    PYTHON_CMD="python3"
    PIP_CMD="pip3"
    
    if ! command_exists python3; then
        if command_exists python; then
            PYTHON_CMD="python"
            PIP_CMD="pip"
        else
            print_message "$YELLOW" "⚠️  Python 未安装，部分工具可能无法安装"
            print_message "$YELLOW" "建议安装: brew install python"
            PYTHON_AVAILABLE=false
            return
        fi
    fi
    
    # 检查pip
    if ! command_exists $PIP_CMD; then
        print_message "$YELLOW" "⚠️  $PIP_CMD 未安装，部分Python工具可能无法安装"
        print_message "$YELLOW" "建议安装: curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && $PYTHON_CMD get-pip.py"
    else
        PYTHON_AVAILABLE=true
    fi
    
    print_message "$GREEN" "✅ 系统环境检查完成"
    echo
}

# 获取工具信息的辅助函数
get_tool_name() {
    local index=$1
    echo "${TOOL_NAMES[$index]}"
}

get_tool_desc() {
    local index=$1
    echo "${TOOL_DESCS[$index]}"
}

get_tool_install() {
    local index=$1
    echo "${TOOL_INSTALLS[$index]}"
}

get_tool_verify() {
    local index=$1
    echo "${TOOL_VERIFIES[$index]}"
}

# 显示工具列表
show_tools_menu() {
    echo "可用的AI工具:"
    echo
    
    local i=1
    for ((j=0; j<${#TOOL_KEYS[@]}; j++)); do
        local install_cmd=$(get_tool_install $j)
        local status=""
        
        # 检查是否需要Python
        if [[ $install_cmd == pip* ]] && [ "$PYTHON_AVAILABLE" = false ]; then
            status=" ${YELLOW}(需要Python)${NC}"
        fi
        
        printf "%2d) %s - %s%s\n" "$i" "$(get_tool_name $j)" "$(get_tool_desc $j)" "$status"
        ((i++))
    done
    
    echo
    printf "%2d) 全部安装\n" "$i"
    echo
    print_message "$GRAY" "输入 q 退出程序"
    echo
}

# 获取用户选择
get_user_selection() {
    local total_tools=${#TOOL_KEYS[@]}
    local all_option=$((total_tools + 1))
    
    while true; do
        read -p "请输入要安装的工具编号 (多个用空格分隔，如: 1 3 5，输入 q 退出): " selections_input
        
        # 检查是否要退出
        if [[ "$selections_input" =~ ^[qQ]$ ]] || [[ "$selections_input" =~ ^(exit|quit)$ ]]; then
            print_message "$YELLOW" "已取消安装"
            exit 0
        fi
        
        # 将输入转换为数组
        IFS=' ' read -r -a selections <<< "$selections_input"
        
        # 验证输入
        local valid=true
        SELECTED_INDICES=()
        
        for selection in "${selections[@]}"; do
            if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
                valid=false
                break
            fi
            
            if [ "$selection" -eq "$all_option" ]; then
                SELECTED_INDICES=()
                for ((i=0; i<${#TOOL_KEYS[@]}; i++)); do
                    SELECTED_INDICES+=($i)
                done
                break
            elif [ "$selection" -ge 1 ] && [ "$selection" -le "$total_tools" ]; then
                local index=$((selection - 1))
                SELECTED_INDICES+=($index)
            else
                valid=false
                break
            fi
        done
        
        if [ "$valid" = true ] && [ ${#SELECTED_INDICES[@]} -gt 0 ]; then
            break
        else
            print_message "$RED" "❌ 输入无效，请重新输入 (输入 q 退出)"
        fi
    done
}

# 安装单个工具
install_tool() {
    local index=$1
    local name=$(get_tool_name $index)
    local install_cmd=$(get_tool_install $index)
    local verify_cmd=$(get_tool_verify $index)
    
    print_message "$CYAN" "📦 正在安装 $name..."
    
    # 执行安装命令
    if eval "$install_cmd"; then
        # 验证安装
        if eval "$verify_cmd"; then
            print_message "$GREEN" "✅ $name 安装成功"
            return 0
        else
            print_message "$YELLOW" "⚠️  $name 安装完成但验证失败"
            return 1
        fi
    else
        print_message "$RED" "❌ $name 安装失败"
        return 1
    fi
}

# 安装选中的工具
install_selected_tools() {
    local total=${#SELECTED_INDICES[@]}
    print_message "$GREEN" "准备安装 $total 个工具..."
    echo
    
    local success_count=0
    local failed_tools=()
    
    for index in "${SELECTED_INDICES[@]}"; do
        if install_tool "$index"; then
            ((success_count++))
        else
            failed_tools+=("$(get_tool_name $index)")
        fi
        echo
    done
    
    # 显示安装结果
    print_message "$BLUE" "🎉 安装完成！"
    print_message "$GREEN" "成功安装: $success_count/$total"
    
    if [ ${#failed_tools[@]} -gt 0 ]; then
        print_message "$RED" "安装失败的工具:"
        for tool in "${failed_tools[@]}"; do
            echo "  • $tool"
        done
        echo
        print_message "$YELLOW" "提示: 某些工具可能需要sudo权限，可以尝试:"
        print_message "$YELLOW" "sudo $(get_tool_install ${SELECTED_INDICES[0]})"
    fi
}

# 显示使用说明
show_usage_info() {
    echo
    print_message "$GRAY" "已安装工具的使用说明:"
    
    for index in "${SELECTED_INDICES[@]}"; do
        local name=$(get_tool_name $index)
        local verify_cmd=$(get_tool_verify $index)
        print_message "$CYAN" "• $name: 运行 $(echo $verify_cmd | cut -d' ' -f1)"
    done
    
    echo
    print_message "$YELLOW" "💡 提示:"
    print_message "$GRAY" "1. 某些工具可能需要API密钥配置"
    print_message "$GRAY" "2. 如果安装失败，尝试使用 sudo"
    print_message "$GRAY" "3. 查看各工具官方文档获取详细配置方法"
}

# 主函数
main() {
    print_title
    check_prerequisites
    show_tools_menu
    get_user_selection
    
    echo
    print_message "$BLUE" "您选择了以下工具:"
    for index in "${SELECTED_INDICES[@]}"; do
        echo "  • $(get_tool_name $index)"
    done
    echo
    
    read -p "确认安装? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]([Ee][Ss])?$ ]]; then
        install_selected_tools
        show_usage_info
    else
        print_message "$YELLOW" "安装已取消"
    fi
}

# 打印标题
print_title() {
    echo
    print_message "$BLUE" "🤖 终端AI工具安装器 (macOS)"
    print_message "$GRAY" "选择要安装的AI工具:"
    echo
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
