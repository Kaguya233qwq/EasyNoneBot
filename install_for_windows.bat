%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c "^&chr(34)^&"%~0"^&chr(34)^&" ::","%cd%","runas",1)(window.close)&&exit
@echo off
chcp 65001 >nul
setlocal enableDelayedExpansion
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"
cls

echo %ESC%[1;34m
echo " _____                _   _                 ______       _   "
echo "|  ___|              | \ | |                | ___ \     | |  "
echo "| |__  __ _ ___ _   _|  \| | ___  _ __   ___| |_/ / ___ | |_ "
echo "|  __|/ _` / __| | | | . ` |/ _ \| '_ \ / _ \ ___ \/ _ \| __|"
echo "| |__| (_| \__ \ |_| | |\  | (_) | | | |  __/ |_/ / (_) | |_ "
echo "\____/\__,_|___/\__, \_| \_/\___/|_| |_|\___\____/ \___/ \__|"
echo "                 __/ |                                       "
echo "                |___/                                        "
echo %ESC%[0m

REM 判断是否安装了python，若已安装则开始配置虚拟环境并安装nonebot
where python >nul 2>nul
if %errorlevel% equ 0 (
    echo Python 已安装，开始安装虚拟环境工具..
	pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
	pip install virtualenvwrapper-win
	echo 创建虚拟环境..
	mkvirtualenv nb
	echo 启用虚拟环境
	workon nb
	echo 安装nonebot
	pip install nonebot2[fastapi]
	pip install nb-cli
	echo 下载模板项目
	curl https://ghproxy.com/https://github.com/Kaguya233qwq/EasyNoneBot/releases/download/template/nb.zip -o nb.zip
	powershell -Command "Expand-Archive -Path nb.zip -DestinationPath nb"
	del nb.zip
	echo 安装适配器
	cd nb & nb adapter install nonebot-adapter-onebot
	echo 安装完成！请使用项目下的“start.bat”启动nonebot
	pause
) else (
    echo 你还没有安装Python，正在下载安装..
	powershell wget -O Python_setup.exe https://www.python.org/ftp/python/3.11.4/python-3.11.4-amd64.exe
	cmd /c Python_setup.exe /quiet TargetDir=C:/Python311 InstallAllUsers=1 PrependPath=1 Include_test=0
	echo python安装成功，请重新运行脚本
)
pause