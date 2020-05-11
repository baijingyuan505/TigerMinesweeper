#!/bin/bash
ECHO="echo -ne" #不换行输出且处理特殊字符
ESC="\033[" #转义序列，用于颜色设置
#变量
OK=0
FALSE=1
FLASH=5
REV=7
#颜色
NULL=0
BLACK=30
RED=31
GREEN=32
ORANGE=33
BLUE=34
PURPLE=35
SBLUE=36
GREY=37
#背景颜色
BBLACK=40
BRED=41
BGREEN=42
BORANGE=43
BBLUE=44
BPURPLE=45
BSBLUE=46
BGREY=47
#--------------函数--------------
#初始化函数（无必要请不要更改）
function Init ()
{
        stty_save=$(stty -g) 
        clear
        trap "GameExit;" 2 15
        stty -echo
        $ECHO "${ESC}?25l" 
        return $OK
}
#游戏结束函数（无必要请不要更改）
function GameExit ()
{
        stty $stty_save
        stty echo
        clear
        trap 2 15
        $ECHO "${ESC}?25h${ESC}0;0H${ESC}0m"
        exit $OK
}

#游戏帮助：负责输入选择的同学请在这修改相关的指令
function Help ()
{
        msg="移动: 挖雷: 新游戏: 退出:"
        $ECHO "${ESC}${REV};${RED}m${ESC}24;1H${msg}${ESC}${NULL}m"
        return $OK
}

#打印对话窗口
function PMsg ()
{
        local title="$1" content="$2" greeting="$3"
        $ECHO "${ESC}${GREEN}m"
        $ECHO "${ESC}11;20H ------------------------------------------- "
        $ECHO "${ESC}12;20H|         ======>$title<======           |"
        $ECHO "${ESC}13;20H|         $content          |"
        $ECHO "${ESC}14;20H|         ======>$greeting<======           |"
        $ECHO "${ESC}15;20H ------------------------------------------- "
        $ECHO "${ESC}${NULL}m"
        return $OK
}

#显示菜单
function Menu ()
{
        local key
        $ECHO "${ESC}6;1H${ESC}${RED}m"
cat<<MENUEND
                       ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
                       ■        (1) Start          ■
                       ■        (2) Exit           ■
                       ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
MENUEND
        $ECHO "${ESC}${NULL}m"
        while read -s -n 1 key
        do
                case $key in
                1) X=16;Y=16;MCount=50;break
                ;;
                2) GameExit
                ;;
                esac
        done
        return $OK
}       

#棋盘函数
function Draw ()
{
        local line1 line2
        line1=$( for (( i=1; i<$((X*4)); i++ )) do $ECHO '★';done )
        line2=$( for (( i=0; i<X; i++ )) do $ECHO "|${ESC}${SBLUE}m ■ ${ESC}${NULL}m";done )
        clear
        Help
            
        $ECHO "${ESC}1;1H♦${line1}♥"
        for (( i=0; i<Y; i++ ))
        do
                $ECHO "${ESC}$((i+2));1H${line2} |"
        done
        $ECHO "${ESC}$((Y+2));1H♣${line1}♠"
        return $OK
}

#游戏结束界面函数
function GameOver ()
{
        local key msgtitle=$1
        PMsg "$msgtitle" "是否重新开始?<y/n>" "Thank You"
        while read -s -n 1 key
        do
                case $key in
                [yY])        exec $(dirname $0)/$(basename $0);;
                [nN])        GameExit;;
                *)        continue;;
                esac
        done
        return $OK       
}
            
#Main函数
function Main ()
{
        local key
        #按键设置 
        while read -s -n 1 key
        do
                case $key in
                [nN])        exec $(dirname $0)/$(basename $0);;
                [xX])        GameExit;;
                esac
        done
        return $OK
}
Init
Menu
Draw
Main