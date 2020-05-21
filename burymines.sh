#!/bin/bash

#地雷分布算法(调用时需要给1个参数“地图号”！！)
function burymines()
{

#1.根据关卡号($1)生成以下参数：
local iswalk=(0)	#哪些路线为行走路线
local walk_num		#行走区域大小
local unwalk_num	#不可行走区域大小
local j				#行走区域雷数
local k				#非行走区域雷数
danger=(0)			#存储并导出最终结果（整合时可以考虑改为在main函数定义）
case $1 in
1)
	walk_num=60
	unwalk_num=196
	iswalk=(0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0)
	j=10
	k=30
;;
2)
	walk_num=60
	unwalk_num=196
	iswalk=(0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0)
	j=10
	k=30
;;
3)
	walk_num=92
	unwalk_num=164
	iswaik=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0)
	j=15
	k=25
;;
4)
	walk_num=124
	unwalk_num=132
	iswalk=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 0 0 1 1 0 0 0 0 1 1 1 1 0 0 0 0 0 0 1 1 0 0 0 0 1 1 1 1 0 0 0 0 0 0 1 1 0 0 0 0 1 1 1 1 0 0 0 0 0 0 1 1 0 0 0 0 1 1 1 1 1 1 1 1 0 0 1 1 0 0 0 0 1 1 1 1 1 1 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1)
	j=20
	k=20
;;
5)
	walk_num=140
	unwalk_num=116
	iswalk=(1 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 1 1 1 1 0 0 1 1 0 0 0 0 1 1 0 0 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 0 0 1 1 0 0 1 1 1 1 1 1 1 1 0 0 0 0 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0 0 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0 0 1 1 0 0 1 1 1 1 1 1 0 0 1 1 0 0 1 1 0 0 1 1 1 1 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 0 0 0 0 1 1 1 1 0 0 1 1 1 1 1 1 0 0 0 0 1 1 1 1 0 0 1 1 1 1 1 1 0 0 0 0)
	j=22
	k=18
;;
esac

#2.产生地雷
#行走区域
local walk=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
#非行走区域
local unwalk=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
local i	#计数器0
for((i=0;i<$j;++i))
do
	walk[$i]=9
done
for((i=0;i<$k;++i))
do
	unwalk[$i]=9
done

#3.随机布雷（洗牌算法）
local ran		#随机数
local temp		#临时存储
for((i=$walk_num;i>0;--i))
do
ran=$(($RANDOM%$i))
temp=${walk[$i]}
walk[$i]=${walk[$ran]}
walk[$ran]=$temp
done

for((i=$unwalk_num;i>0;--i))
do
ran=$(($RANDOM%$i))
temp=${unwalk[$i]}
unwalk[$i]=${unwalk[$ran]}
unwalk[$ran]=$temp
done

#4.将两个区域拼接	
j=0		#计数器1（已定义的local变量）
k=0		#计数器2（已定义的local变量）
for((i=0;i<256;++i))
do
	if [[ "${iswalk[$i]}" == "1" ]]
	then
		danger[$i]=${walk[$j]}			#将路线逻辑位置j是否有雷填入数组	
		j=` expr $j + 1 `
	else
		danger[$i]=${unwalk[$k]}		#否则将非路线逻辑位置k是否有雷填入
		k=` expr $k + 1 `
	fi
done

#5.计算无地雷区域周围的雷数（又臭又长）
j=0		#行（已定义的local变量）
k=0		#列（已定义的local变量）

for((i=0;i<256;++i))
do
if [[ "${danger[$i]}" == "0" ]]		#对于每个无地雷的格子
then
	j=` expr $i / 16 `				#计算行
	k=` expr $i % 16 `				#计算列
	if [[ "$j" == "0" ]]			#若在第0行
	then
		if [[ "$k" == "0" ]]		#可能为左上角
		then
			temp=` expr $i + 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 16 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 17 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
		elif [[ "$k" == "15" ]]		#也可能为右上角
		then
			temp=` expr $i - 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 15 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 16 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
		else						#不然就是上边界
			temp=` expr $i - 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 15 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 16 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 17 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
		fi
	elif [[ "$j" == "15" ]]			#若为第15行
	then
		if [[ "$k" == "0" ]]		#要么左下角
		then
			temp=` expr $i - 16 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i - 15 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
		elif [[ "$k" == "15" ]]		#要么右下角
		then
			temp=` expr $i - 17 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i - 16 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i - 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
		else						#不然就是下边界
			temp=` expr $i - 17 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i - 16 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i - 15 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i - 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
			temp=` expr $i + 1 `
			if [[ "${danger[$temp]}" == "9" ]]
			then 
				danger[$i]=` expr ${danger[$i]} + 1 `
			fi
		fi
	elif [[ "$k" == "0" ]]		#这两行去掉，剩下的要么左边界
	then
		temp=` expr $i - 16 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i - 15 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 1 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 16 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 17 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
	elif [[ "$k" == "15" ]]		#要么右边界
	then
		temp=` expr $i - 17 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i - 16 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i - 1 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 15 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 16 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
	else						#应该就剩中间那片了
		temp=` expr $i - 17 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i - 16 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i - 15 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i - 1 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 1 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 15 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 16 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
		temp=` expr $i + 17 `
		if [[ "${danger[$temp]}" == "9" ]]
		then 
			danger[$i]=` expr ${danger[$i]} + 1 `
		fi
	fi
fi
done

return $OK
}


