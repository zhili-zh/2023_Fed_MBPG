#!/bin/bash

# 第一个命令
nohup python Fed_MBPG.py --global-iteration 150 --num-agent 2 --env HalfCheetah --beta 0.2 > Fed_MBPG_HalfCheetah_0p2_gi150_a2.out 2> Fed_MBPG_HalfCheetah_0p2_gi150_a2.err &
pid1=$!

# 休息2小时
sleep 7200

# 第二个命令
nohup python Fed_MBPG.py --global-iteration 150 --num-agent 2 --env HalfCheetah --beta 0.5 > Fed_MBPG_HalfCheetah_0p5_gi150_a2.out 2> Fed_MBPG_HalfCheetah_0p5_gi150_a2.err &
pid2=$!

# 休息2小时
sleep 7200

# 第三个命令
nohup python Fed_MBPG.py --global-iteration 150 --num-agent 2 --env HalfCheetah --beta 0.8 > Fed_MBPG_HalfCheetah_0p8_gi150_a2.out 2> Fed_MBPG_HalfCheetah_0p8_gi150_a2.err &
pid3=$!

# 休息2小时
sleep 7200

# 第四个命令
nohup python Fed_MBPG.py --global-iteration 150 --num-agent 2 --env HalfCheetah --beta 1.0 > Fed_MBPG_HalfCheetah_1p0_gi150_a2.out 2> Fed_MBPG_HalfCheetah_1p0_gi150_a2.err &
pid4=$!

# 休息2小时
sleep 7200

nohup python Fed_MBPG.py --global-iteration 150 --env Walker --beta 1.0 --num-agent 2 > Fed_MBPG_Walker_1p0_gi150_a2.out 2> Fed_MBPG_Walker_1p0_gi150_a2.err &
pid5=$!

# 休息18小时
sleep 64800

nohup python Fed_MBPG.py --global-iteration 150 --env Walker --beta 0.2 --num-agent 2 > Fed_MBPG_Walker_0p2_gi150_a2.out 2> Fed_MBPG_Walker_0p2_gi150_a2.err &
pid6=$!

# 休息18小时
sleep 64800

nohup python Fed_MBPG.py --global-iteration 150 --env Walker --beta 0.5 --num-agent 2 > Fed_MBPG_Walker_0p5_gi150_a2.out 2> Fed_MBPG_Walker_0p5_gi150_a2.err &
pid7=$!


# 打印进程ID
echo "PID of the first command: $pid1"
echo "PID of the second command: $pid2"
echo "PID of the third command: $pid3"
echo "PID of the fourth command: $pid4"
echo "PID of the first command: $pid5"
echo "PID of the second command: $pid6"
echo "PID of the third command: $pid7"

# 等待所有命令完成
wait $pid1
wait $pid2
wait $pid3
wait $pid4
wait $pid5
wait $pid6
wait $pid7

echo "All commands have finished."
