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
#new variables below
#Index shows if this cell contains a mine
#COUNT shows the mine number in 3*3 area
#Times means how many times you can clear a cell
Index=0
COUNT=2
Times=5 
#the judgement of the move of army
mvarg=1

#the array related to the map
#ao cheng Zhang can create a function to change the content of this array
#to control the action of function armymv()
arr_mv1[0]=1  
arr_mv2[0]=1  
   
# 1->right move 2->up move 3->left move 4->down move 0->stay still(the end)

hide=${ESC}?25l
show=${ESC}?25h
 
#temporary var,please delete it after finished function Mine
counter=1
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

#游戏帮助
function Help ()
{

        msg="移动: W,A,S,D 挖雷: -J-open a cell,-K-clear a cell 新游戏:  N 退出: X "
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
        $ECHO $show
        while read -s -n 1 key
        do
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
Count $row $col
if [ $Index = X ]
then GameOver
     return $OK
fi
$ECHO "${ESC}${ORANGE}m${COUNT} "
#please use var Index and COUNT
#in the function Count
$ECHO "${ESC}2D"
return $OK
}


#clear a mine using one opportunities
function Clear ()
{
if Operated
then return $OK
fi
Times=`expr $Times - 1`
if [ $Times -eq 0 ]
then GameOver
     return $OK
fi
if Mine
then $ECHO "${ESC}${ORANGE}mY "
else $ECHO "${ESC}${ORANGE}mN "
fi
$ECHO "${ESC}2D"
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


#count the mines in 3*3 areas
function Count ()
{
return $OK
}


#see if this cell has a mine
function Mine ()
{
counter=`expr $counter + 1`
#counter is temporary variable
if ((counter%2==0))
then return 0
else return 1
fi
}


#see if this cell is operated
function Operated ()
{
return 1
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

#movement of the army
#the Timer of army
function moveTimer()
{
local line4
local line5
local line6 line7

line4=$( $ECHO "The clock is ticking: 4 S")
line5=$( $ECHO "The clock is ticking: 3 s")
line6=$( $ECHO "The clock is ticking: 2 s")
line7=$( $ECHO "The clock is ticking: 1 S")   

sleep 1s
#$ECHO " ${ESC}$((Y+2));1H${line4}"
#$ECHO $hide
$ECHO "${ESC}$((Y+2));1H"
$ECHO "${line4}"
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
#$ECHO $show
sleep 1s
#$ECHO $hide
#$ECHO " ${ESC}$((Y+2));1H${line5}"
$ECHO "${ESC}$((Y+2));1H"
$ECHO "${line5}"
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
#$ECHO $show
sleep 1s
#$ECHO $hide
#$ECHO " ${ESC}$((Y+2));1H${line6}"
$ECHO "${ESC}$((Y+2));1H"
$ECHO "${line6}"
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
#$ECHO $show
sleep 1s
#$ECHO $hide
#$ECHO " ${ESC}$((Y+2));1H${line7}" 
$ECHO "${ESC}$((Y+2));1H"
$ECHO "${line7}"
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
#$ECHO $show

return $OK
}

#the function to control army movement
function armymv()
{
moveTimer   
m1y= ${arr_mv1[$i]}
m1x= ${arr_mv2[$i]} 
m1y=1
m1x=1  
line=$(for((i=0 ; i<2  ; i++)) do $ECHO "|${ESC}${RED}m ■ ${ESC}${NULL}m"  ; done ) 
$ECHO $hide
check   
$ECHO "${ESC}${m1y};${m1x}H${line}" 
$ECHO "${ESC}$((m1y+1));${m1x}H${line}"
$ECHO "${ESC}$((row+1));$((col*4-1))H" 
$ECHO $show
return $OK

}  

function check()
{
for ((i=0 ; i<256 ; i++))
do
local x1 y1
  for ((k=0 ; k<16 ; k++))
   do
   if [ $i -gt $((k*16 - 1)) ] && [ $i -le $((k*16 + 15)) ]
   then
   x1=`expr $k + 1`
   y2=`expr $i - $((i-k*16+1))`
   else
   continue
   fi
  done 
 case ${danger[$i]} in
    Y*) $ECHO "${ESC}${x1};$((y1*3))H${danger[$i]:1}"
;;
    *)  case ${iswalk[$i]} in
          0)    
          $ECHO "${ESC}${x1};$((y1*3))H${$ECHO "${ESC}${SBLUE}m■ "}";;       
          1)
          $ECHO "${ESC}${X1};$((y1*3))H${$ECHO "${ESC}${GREY}m■ "}";;
        esac    
;;
 esac
done
}

Init
Menu  
Draw
Modify
#armyInit
armymv &   
Main
     
  
