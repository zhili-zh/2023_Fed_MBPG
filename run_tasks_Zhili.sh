#!/bin/bash

python Fed_HAPG.py --global-iteration 2 --env Walker --beta 1.0 --num-agent 2 > ./outerr/Fed_HAPG_Walker_1p0_gi200_a2_eta050.out 2> ./outerr/Fed_HAPG_Walker_1p0_gi200_a2_eta050.err
pid1=$!

# 休息18小时
sleep 60

python Fed_HAPG.py --global-iteration 2 --env Walker --beta 0.0 --num-agent 2 > ./outerr/Fed_HAPG_Walker_0p0_gi200_a2_eta050.out 2> ./outerr/Fed_HAPG_Walker_0p0_gi200_a2_eta050.err
pid2=$!

# 休息18小时
sleep 60

python Fed_HAPG.py --global-iteration 2 --env Walker --beta 0.2 --num-agent 2 > ./outerr/Fed_HAPG_Walker_0p2_gi200_a2_eta050.out 2> ./outerr/Fed_HAPG_Walker_0p2_gi200_a2_eta050.err
pid3=$!


# 打印进程ID
echo "PID of the first command: $pid1"
echo "PID of the second command: $pid2"
echo "PID of the third command: $pid3"
#echo "PID of the fourth command: $pid4"
#echo "PID of the first command: $pid5"
#echo "PID of the second command: $pid6"
#echo "PID of the third command: $pid7"

# 等待所有命令完成
wait $pid1
wait $pid2
wait $pid3
#wait $pid4
#wait $pid5
#wait $pid6
#wait $pid7

echo "All commands have finished."
