#!/bin/bash

# Function to print colored text
printc() {
  local text="$1"
  local color="$2"
  echo -e "\033[${color}m${text}\033[0m"
}

handle_error() {
  local line=$1
  printc "An Error Occurred at line：$line" "31;1;1"
  printc "Sorry,the script will stop and exit soon" "31;1;1"
  exit 1
}

trap 'handle_error ${BASH_LINENO[0]}' ERR

# Main script
clear

printc """
░█▀▀░█▀█░█▀▀░█░█░█▀█░█▀█░█▀█░█▀▀░█▀▄░█▀█░▀█▀
░█▀▀░█▀█░▀▀█░░█░░█░█░█░█░█░█░█▀▀░█▀▄░█░█░░█░
░▀▀▀░▀░▀░▀▀▀░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀░░▀▀▀░░▀░
""" "34;1;1"
# 检查Python是否已安装
printc "Checking python installiton.." "34;1;1"
if command -v python3 &>/dev/null; then
  printc "Python has been installed." "31;1;1"
  printc "Checking pip installiton.." "34;1;1"

  # 检查是否能执行pip命令
  if command -v pip &>/dev/null; then
    printc "pip is installed" "31;1;1"
    pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/
    pip3 install virtualenvwrapper
    # 写入环境变量
    # 要写入的内容
    # shellcheck disable=SC1078
    content="""export WORKON_HOME=~/Envs
export VIRTUALENVWRAPPER=/usr/bin/python3
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/bin/virtualenvwrapper.sh
		"""
    # 检查用户是否有权限修改.bashrc文件
    if [[ -w ~/.bashrc ]]; then
      # 将内容追加到.bashrc文件中
      echo "$content" >>~/.bashrc
      printc "bashrc update successfully" "31;1;1"
    else
      printc "permission denied,try to get root" "32;1;1"

      # 尝试使用sudo获取root权限写入文件
      if sudo sh -c "echo '$content' >> ~/.bashrc"; then
        printc "force bashrc to update successfully" "31;1;1"
      else
        printc "Error: all actions failed" "31;1;1"
        exit 1
      fi
    fi
    # 刷新bashrc文件
    # shellcheck disable=SC1090
    source ~/.bashrc
    # 新建虚拟环境
    mkvirtualenv nb
    # 启用
    workon nb
    printc "virtual environment set completed"
    # 安装nonebot环境
    echo "Now installing Nonebot.."
    # shellcheck disable=SC2102
    pip3 install nonebot2[fastapi]
    pip3 install nb-cli
    echo "Downloading template folder.."
    curl https://ghproxy.com/https://github.com/Kaguya233qwq/EasyNoneBot/releases/download/template/nb.zip -o nb.zip
    if command -v unzip &>/dev/null; then
      unzip nb.zip
      echo "installing adapter.."
      cd nb && nb adapter install nonebot-adapter-onebot
      printc "Everything is ok!Now you can launch Nonebot by :" "32;1;1"
      printc " - using command 'workon nb && nb run'" "32;1;1"
      printc " - using command 'bash ./start.sh'" "32;1;1"
    else
      printc "package 'unzip' is not installed,please try to install it and restart the script" "31;1;1"
    fi
  else
    printc "pip is not installed,trying install.." "33;1;1"
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
    printc "pip is installed successfully,please restart the script" "32;1;1"
  fi
else
  printc "Python is not installed." "31;1;1"
fi
