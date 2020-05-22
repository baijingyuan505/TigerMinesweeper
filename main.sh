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

#the array related to the map
#ao cheng Zhang can create a function to change the content of this array
#to control the action of function armymv()
arr_mv1[0]=1  
arr_mv2[0]=1  


#line4=$( $ECHO "The clock is ticking: 4 S")
#line5=$( $ECHO "The clock is ticking: 3 s")
#line6=$( $ECHO "The clock is ticking: 2 s")
#line7=$( $ECHO "The clock is ticking: 1 S") 
   
# 1->right move 2->up move 3->left move 4->down move 0->stay still(the end)

hide=${ESC}?25l
show=${ESC}?25h

key=0

#
iswalk=(0)	#哪些路线为行走路线
export walk_num		#行走区域大小
export unwalk_num	#不可行走区域大小
export j				#行走区域雷数
export k				#非行走区域雷数
export mines
export Times
map=(0)
source bury.sh
#generate map in function Init

 
#--------------函数--------------
#初始化函数（无必要请不要更改）
function Init ()
{
        stty_save=$(stty -g) 
        clear
        trap "GameExit;" 2 15
        stty -echo
        $ECHO "${ESC}?25l" 
#generate map in function Init
        burymines 2
        Times=$((mines+2))
#
#
        touch null.txt
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
#
        rm null.txt
#
        exit $OK
}

#游戏帮助
function Help ()
{

        msg="移动: W,A,S,D 挖雷: -J-open a cell,-K-clear a cell 新游戏: N 退出: X "
        $ECHO "${ESC}${REV};${RED}m${ESC}$((Y+4));1H${msg}${ESC}${NULL}m"
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
        $ECHO "${ESC}1;1H♦${line1}♦"
        for (( i=0; i<Y; i++ ))
        do
                $ECHO "${ESC}$((i+2));1H${line2} |"
        done
        $ECHO "${ESC}$((Y+2));1H♦${line1}♦"
        Help
        return $OK
}

#游戏结束界面函数
function GameOver ()
{
        local key msgtitle=$1
        PMsg "$msgtitle" "Congratulation on winning the game!是否重新开始?<y/n>" "Thank You"
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
            

function GameWin ()
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


#relocate in the center
function Modify ()
{
$ECHO "${ESC}$((Y+1));1H"
row=$X
col=1
for((i=1;i<=((X/2));i++))
do
right
done
for((i=1;i<=$((Y/2+1));i++))
do
up
done
return $OK
}


#open a cell
function Open ()
{
if Operated
then return $OK
fi
if [ $content = 9 ]
then GameOver
     return $OK
fi
$ECHO "${ESC}${ORANGE}m${content} "
$ECHO "${ESC}2D"
num=$content
content="Y${num}"
return $OK
}


#clear a mine using one opportunities
function Clear ()
{
if Operated
then return $OK
fi
if [ $content = 9 ]
then $ECHO "${ESC}${ORANGE}mX "
mines=`expr $mines - 1`
else $ECHO "${ESC}${ORANGE}mNo"
fi
$ECHO "${ESC}2D"
#the game s winning logic
if [ $mines -eq 0 ]
then GameWin
fi
#
Times=`expr $Times - 1`
if [ $Times -eq 0 ]
then GameOver
fi
num=$content
content="Y${num}"
return $OK
}


#move functions
function left ()
{
if [ $col -ne 1 ]
then $ECHO "${ESC}$((row+1));$((col*4-4-1))H"
col=`expr $col - 1` 
export row
export col
fi
return $OK
}
function right ()
{
if [ $col -ne $Y ]
then $ECHO "${ESC}$((row+1));$((col*4+4-1))H"
col=`expr $col + 1`
export row
export col
fi
return $OK
}
function up ()
{
if [ $row -ne 1 ]
then $ECHO "${ESC}$((row));$((col*4-1))H"
row=`expr $row - 1`
export row
export col
fi
return $OK
}
function down ()
{
if [ $row -ne $X ]
then $ECHO "${ESC}$((row+2));$((col*4-1))H"
row=`expr $row + 1`
export row
export col
fi
return $OK
}


#see if this cell is operated
function Operated ()
{
local flag
num=$((row*Y-Y+col))
idx=`expr $num - 1`
content=${map[$idx]}
case $content in
Y*) flag=0
;;
*) flag=1
;;
esac
return $flag
}


#statement: ${ESC}y;xH this sets the cursor's location
#Init of army square:
function armyInit() 
{ 
local line3
line3=$(for((i=0 ; i<2  ; i++)) do $ECHO "|${ESC}${RED}m ■ ${ESC}${NULL}m"  ; done ) 
for ((i=14; i<Y; i++))
do
  $ECHO " ${ESC}$((i+2));1H${line3}|"   
done

return $OK

}


function Timer ()
{
sleep 1
}


function Input ()
{
        Index=0
        Timer &
        $ECHO $show
        while ([ $Index != 1 ])
        do
                read -s -n 1 -t 0.1 key
#another choice:                read -s -n 1 key
                case $key in

                [nN])        exec $(dirname $0)/$(basename $0)
                             mvarg=0 ;;  
                [xX])        GameExit
                             mvarg=0  ;;  
                [aA])    left;;
                [dD])    right;;
                [wW])    up;;
                [sS])    down;;
                [jJ])    Open;;
                [kK])    Clear;;
                esac
                kill -0 $! 2> null.txt
                Index=$?
        done
        return $OK
}



function Main()
{
for ((i=0 ; i<60 ; i++))
do
for ((j=4;j>=1;j--))
do
$ECHO "${ESC}$((Y+6));1H"
$ECHO "The clock is ticking: ${j} S        Clear a mine: ${Times} times"
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
Input
done
#no need of mvarg
#m1y= ${arr_mv1[$i]}
#m1x= ${arr_mv2[$i]} 
#m1y=1
#m1x=1
line=$(for((i=0 ; i<2  ; i++)) do $ECHO "|${ESC}${RED}m ■ ${ESC}${NULL}m"  ; done ) 
$ECHO "${ESC}${m1y};${m1x}H${line}" 
$ECHO "${ESC}$((m1y+1));${m1x}H${line}"
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
Input
done
return $OK

}  



Init
Menu  
Draw
Modify
#armyInit
Main
     
  
