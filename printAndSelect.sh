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
#关卡函数，之后会更改draw函数来画出路径
#arr1是x坐标，arr2是y坐标
function Stage1()
{
arr1=(1 5 9 13 17 21 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 29 33 37 41 45 49 53 57)
arr2=(16 16 16 16 16 16 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 2 2 2 2 2 2 2 2) 
Draw
local line3 line4 line5
        line3=$( for (( i=1; i<9; i++)) do $ECHO "| ■ " ;done)
	line4=$( for (( i=1; i<3; i++)) do $ECHO "| ■ " ;done)
	line5=$( for (( i=1; i<11; i++)) do $ECHO "| ■ ";done)
        $ECHO "${ESC}16;1H${line3}"
	$ECHO "${ESC}17;1H${line3}"
$ECHO "${ESC}2;25H${line5}"
$ECHO "${ESC}3;25H${line5}"
	for ((Y=4; Y<16; Y++)) do $ECHO "${ESC}${Y};25H${line4}" ; done

        return $OK

}
function Stage2()
{
arr1=(1 5 9 9 9 9 9 13 17 21 25 29 33 33 33 33 33 33 33 33 33 33 33 37 41 45 49 53 57)
arr2=(16 16 16 15 14 13 12 12 12 12 12 12 12 11 10 9 8 7 6 5 4 3 2 2 2 2 2 2 2)
Draw
local line1 line2 line3
	line1=$( for (( i=1; i<9; i++)) do $ECHO "| ■ " ;done)
	line2=$( for (( i=1; i<3; i++)) do $ECHO "| ■ " ;done)
	line3=$( for (( i=1; i<5; i++)) do $ECHO "| ■ " ;done)
	$ECHO "${ESC}16;1H${line3}"
	$ECHO "${ESC}17;1H${line3}"
	for ((Y=4; Y<12; Y++)) do $ECHO "${ESC}${Y};33H${line2}" ; done
	for ((Y=14; Y<16; Y++)) do $ECHO "${ESC}${Y};9H${line2}" ; done
	for ((Y=2; Y<4; Y++)) do $ECHO "${ESC}${Y};33H${line1}" ; done
	for ((Y=12; Y<14; Y++)) do $ECHO "${ESC}${Y};9H${line1}" ; done
	for ((Y=16; Y<18; Y++)) do $ECHO "${ESC}${Y};1H${line3}" ; done
	return $OK
}
function Stage3()
{
arr1=(1 5 9 13 17 17 17 17 17 17 17 17 17 17 21 25 29 33 37 37 37 37 37 37 37 37 37 41 45 49 53 57 57 57 57 57 57 57 57 57 57 57 57 57 57)
arr2=(16 16 16 16 16 15 14 13 12 11 10 9 8 7 7 7 7 7 7 8 9 10 11 12 13 14 15 1515 15 15 15 14 13 12 11 10 9 8 7 6 5 4 3 2) 

Draw
local line1 line2 line3
line1=$( for (( i=1; i<8; i++)) do $ECHO "| ■ " ;done)
        line2=$( for (( i=1; i<3; i++)) do $ECHO "| ■ " ;done)
        line3=$( for (( i=1; i<7; i++)) do $ECHO "| ■ " ;done)
	for ((Y=9; Y<15; Y++))
	 do 
	$ECHO "${ESC}${Y};17H${line2}" ;
	$ECHO "${ESC}${Y};37H${line2}" ;
 	done
        for ((Y=7; Y<9; Y++)) do $ECHO "${ESC}${Y};17H${line1}" ; done
        for ((Y=15; Y<17; Y++)) do $ECHO "${ESC}${Y};37H${line1}" ; done
        for ((Y=2; Y<16; Y++)) do $ECHO "${ESC}${Y};57H${line2}" ; done
        for ((Y=16; Y<18; Y++)) do $ECHO "${ESC}${Y};1H${line3}" ; done
	$ECHO "${ESC}15;17H${line2}"
        return $OK
}
function Stage4()
{
arr1=(1 5 9 13 17 17 17 17 17 17 17 13 9 5 1 1 1 1 1 1 5 9 13 17 21 25 29 33 33 33 33 33 33 33 33 33 33 33 33 37 41 45 49 53 57 57 57 57 57 57 57 57 57 57 57 57 57 57 57)
arr2=(16 16 16 16 16 15 14 13 12 11 10 10 10 10 10 9 8 7 6 5 5 5 5 5 5 5 5 5 6 7 8 9 10 11 12 13 14 15 16 16 16 16 16 16 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2)
Draw
local line1 line2 line3 line4 line5
        line1=$( for (( i=1; i<9; i++)) do $ECHO "| ■ " ;done)
        line2=$( for (( i=1; i<3; i++)) do $ECHO "| ■ " ;done)
        line3=$( for (( i=1; i<7; i++)) do $ECHO "| ■ " ;done)
        for ((Y=2; Y<18; Y++)) do $ECHO "${ESC}${Y};57H${line2}" ; done
        for ((Y=16; Y<18; Y++)) do $ECHO "${ESC}${Y};33H${line3}" ; done
        for ((Y=5; Y<18; Y++)) do $ECHO "${ESC}${Y};33H${line2}" ; done
        for ((Y=5; Y<7; Y++)) do $ECHO "${ESC}${Y};1H${line1}" ; done
        for ((Y=7; Y<10; Y++)) do $ECHO "${ESC}${Y};1H${line2}" ; done
        for ((Y=12; Y<16; Y++)) do $ECHO "${ESC}${Y};17H${line2}" ; done
        for ((Y=10; Y<12; Y++)) do $ECHO "${ESC}${Y};1H${line3}" ; done
        for ((Y=16; Y<18; Y++)) do $ECHO "${ESC}${Y};1H${line3}" ; done

        return $OK
}
function Stage5()
{
arr1=(1 5 9 9 9 9 9 9 9 5 1 1 1 1 1 1 1 1 1 5 9 13 17 17 17 17 17 21 25 25 25 25 25 25 25 25 25 25 25 29 33 37 41 41 41 41 41 41 45 49 53 57 57 57 57 57 53 49 45 41 41 41 41 41 45 49 53 57)
arr2=(16 16 16 15 14 13 12 11 10 10 10 9 8 7 6 5 4 3 2 2 2 2 2 3 4 5 6 6 6 7 8 9 10 11 12 13 14 15 16 16 16 16 16 15 14 13 12 11 11 11 11 11 10 9 8 7 7 7 7 7 6 5 4 3 2 2 2 2 2)
Draw
local line4 line2 line6 
        line4=$( for (( i=1; i<5; i++)) do $ECHO "| ■ " ;done)
        line2=$( for (( i=1; i<3; i++)) do $ECHO "| ■ " ;done)
        line6=$( for (( i=1; i<7; i++)) do $ECHO "| ■ " ;done)
        for ((Y=2; Y<4; Y++)) do 
	$ECHO "${ESC}${Y};1H${line6}" ;
	$ECHO "${ESC}${Y};41H${line6}" ;
	 done
	for ((Y=4; Y<6; Y++)) do 
        $ECHO "${ESC}${Y};1H${line2}" ;
        $ECHO "${ESC}${Y};17H${line2}" ;
	$ECHO "${ESC}${Y};41H${line2}" ;
         done
for ((Y=8; Y<16; Y++)) do   
        $ECHO "${ESC}${Y};25H${line2}" ;
	done
        for ((Y=7; Y<9; Y++)) do $ECHO "${ESC}${Y};41H${line6}" ; done
for ((Y=10; Y<18; Y++)) do $ECHO "${ESC}${Y};9H${line2}" ; done
for ((Y=11; Y<18; Y++)) do $ECHO "${ESC}${Y};41H${line2}" ; done

        for ((Y=11; Y<13; Y++)) do $ECHO "${ESC}${Y};41H${line6}" ; done
        for ((Y=16; Y<18; Y++)) do
	 $ECHO "${ESC}${Y};1H${line4}" ; 
	$ECHO "${ESC}${Y};25H${line6}" ;
	done
        for ((Y=10; Y<12; Y++)) do $ECHO "${ESC}${Y};1H${line4}" ; done
        for ((Y=6; Y<10; Y++)) do $ECHO "${ESC}${Y};1H${line2}" ; done
        for ((Y=9; Y<11; Y++)) do $ECHO "${ESC}${Y};57H${line2}" ; done
 	$ECHO "${ESC}6;41H${line2}" ;
	for ((Y=6; Y<8; Y++)) do $ECHO "${ESC}${Y};17H${line4}" ; done
        return $OK

}

#选择关卡函数
function StageSelect()
{
clear
cat<<EOF
                        -----------------------------
                        |     请输入1～5选择关卡    |
                        |          (1)第一关        |
                        |          (2)第二关        |
                        |          (3)第三关        |
                        |          (4)第四关        |
                        |          (5)第五关        |
                        -----------------------------

                           
EOF

local key1
while read -sn 1 key1
do
case $key1 in
1)Stage1;; 
2)Stage2;;
3)Stage3;;
4)Stage4;;
5)Stage5;;
*)continue;;
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
StageSelect
#Draw
Main
