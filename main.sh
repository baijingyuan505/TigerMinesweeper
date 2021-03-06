#!/bin/bash
ECHO="echo -ne" #不换行输出且处理特殊字符
ESC="\033[" #转义序列，用于颜色设置
#statement: ${ESC}y;xH this sets the cursor's location
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



hide=${ESC}?25l
show=${ESC}?25h

key=0
zeroidx=0
#
iswalk=(0)	#哪些路线为行走路线
export walk_num		#行走区域大小
export unwalk_num	#不可行走区域大小
export j				#行走区域雷数
export k				#非行走区域雷数
export Times
export mines
map=(0)
source bury.sh




tempy=16
tempx=1
LoseFlag=false
 
#--------------函数--------------
#初始化函数（无必要请不要更改）
function Init ()
{
        stty_save=$(stty -g) 
        clear
        trap "GameExit;" 2 15
        stty -echo
        $ECHO "${ESC}?25l" 

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
                1) X=16;Y=16;break
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
                $ECHO "${ESC}$((i+2));1H${line2}|"
        done
        $ECHO "${ESC}$((Y+2));1H♦${line1}♦"
        Help
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
            

function GameWin ()
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


#relocate in the center
function Modify ()
{
$ECHO "${ESC}$((Y+1));1H"
row=$X
col=1
up
Clear
Open
right
Clear
Open
down
Clear
Open
left
Clear
Open
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

#see if this cell is operated
function Calc()
{
a=$1
b=$2
content=${map[((a*Y-Y+b-1))]}
idx=$((a*Y-Y+b-1))
return $OK
}



#open a cell
function Open ()
{
Calc ${row} ${col}
if [ "$content" == "9" ]
then GameOver
     return $OK
fi
$ECHO "${ESC}${ORANGE}m${content} "
$ECHO "${ESC}2D"
if [ $zeroidx -eq 0 ]&&[ "$content" == "0" ]
then Zero
fi
return $OK
}

function ReOpen ()
{
_row=$1
_col=$2
Calc ${_row} ${_col}
$ECHO "${ESC}$((_row+1));$((_col*4-1))H"
$ECHO "${ESC}m${content} "
return $OK
}

function Zero ()
{
if [ $row -eq 16 ]||[ $row -eq 1 ]||[ $col -eq 16 ]||[ $col -eq 1 ]
then
return $OK
fi
zeroidx=1
down
Open
left
Open
up
Open
up
Open
right
Open
right
Open
down
Open
down
Open
left
Open
up
zeroidx=0
return $OK
}


#clear a mine using one opportunities
function Clear ()
{

if [ $Times -eq 0 ]
then return $OK
fi

Calc ${row} ${col}
if [ "$content" == "9" ]
then $ECHO "${ESC}${ORANGE}mX "
     map[$idx]=" "
mines=`expr $mines - 1`
else $ECHO "${ESC}${ORANGE}mNo"
fi
$ECHO "${ESC}2D"
if [ $mines -eq 0 ]
then GameWin
fi
Times=`expr $Times - 1`

return $OK
}


#move functions
function left ()
{
if [ $col -ne 1 ]
then $ECHO "${ESC}$((row+1));$((col*4-4-1))H"
col=`expr $col - 1` 
fi
return $OK
}
function right ()
{
if [ $col -ne $Y ]
then $ECHO "${ESC}$((row+1));$((col*4+4-1))H"
col=`expr $col + 1`
fi
return $OK
}
function up ()
{
if [ $row -ne 1 ]
then $ECHO "${ESC}$((row));$((col*4-1))H"
row=`expr $row - 1`
fi
return $OK
}
function down ()
{
if [ $row -ne $X ]
then $ECHO "${ESC}$((row+2));$((col*4-1))H"
row=`expr $row + 1`
fi
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
X=16 
Y=16
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
X=16
Y=16
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
X=16
Y=16
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
X=16 
Y=16
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
X=16 
Y=16
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
#while 
read -sn 1 key1
#do
case $key1 in
1)Stage1 
;; 
2)Stage2
;;
3)Stage3
;;
4)Stage4 
;;
5)Stage5  
;;
*)exec $(dirname $0)/$(basename $0)
;;
# *)continue;;
esac
# done
burymines $key1
Times=$((j+24))
  Modify
  Main
return $OK
     } 


function Main()
{
for ((i=0 ; i<60 ; i++))
do 
for ((j=10;j>=1;j--))
do
$ECHO "${ESC}$((Y+6));1H"
$ECHO "The clock is ticking: ${j} S        Clear a mine: ${Times} times "
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
Input
done

armymv 
$ECHO "${ESC}$((row+1));$((col*4-1))H"    
Input
done
return $OK

}  


#the function to control army movement
function armymv()
{

RE tempy tempx

local line3
m1y=${arr2[$i]}
m1x=${arr1[$i]}   

line3=$(for((i=0;i<2;i++)) do $ECHO "${ESC}${RED}m| ■ "; done ) 
$ECHO "${ESC}${m1y};${m1x}H${line3}|"
$ECHO "${ESC}$((m1y+1));${m1x}H${line3}|"

#tempy,tempx是军队左下角方块的逻辑坐标
#棋盘左上角为(1,1)
tempy=${m1y}
temp=$((m1x+3))
tempx=$((temp/4))

#触雷逻辑函数
Check $((tempy-1)) ${tempx}
Check $((tempy-1)) $((tempx+1))
Check ${tempy} $((tempx+1))

if [ $LoseFlag == true ]
then GameOver
elif [ $m1y -eq 2 ] && [ $m1x -eq 57 ]
then
  GameWin
fi

return $OK

}

function RE ()
{
y=$1
x=$2
ReOpen ${y} ${x}
ReOpen ${y} $((x+1))
ReOpen $((y-1)) $((x+1))
ReOpen $((y-1)) ${x}
}



function Check()
{
c=$1
d=$2
_content=${map[((c*Y-Y+d-1))]}
if [ "${_content}" == "9" ]
then ReOpen ${c} ${d}
     LoseFlag=true
fi
}



Init
Menu  
StageSelect  


     
  
