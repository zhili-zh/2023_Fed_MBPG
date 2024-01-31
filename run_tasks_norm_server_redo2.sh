#!/bin/bash

# # finish eta = 0.050
# nohup python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 1 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a1_eta050_redo.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a1_eta050_redo.err &
# pid0=$!
# nohup python -u Fed_HAPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 1 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p8_gi250_a1_eta050_redo.out 2> ./outerr/Fed_HAPG_CartPole_0p8_gi250_a1_eta050_redo.err &
# pid0=$!


# # 休息30mins
sleep 20
# PID 10813
nohup python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 2 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a2_eta050_redo.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a2_eta050_redo.err &
pid1=$!

#PID 11271
nohup python -u Fed_HAPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p8_gi250_a2_eta050_redo.out 2> ./outerr/Fed_HAPG_CartPole_0p8_gi250_a2_eta050_redo.err &
pid1=$!
# # 休息30mins
sleep 20

#PID: 9543
nohup python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 4 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a4_eta050_redo.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a4_eta050_redo.err &
pid2=$!
# PID: 9830
nohup python -u Fed_HAPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 4 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p8_gi250_a4_eta050_redo.out 2> ./outerr/Fed_HAPG_CartPole_0p8_gi250_a4_eta050_redo.err &
pid2=$!
# 休息30mins
sleep 20

nohup python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 8 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a8_eta050_redo.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a8_eta050_redo.err &
pid3=$!
nohup python -u Fed_HAPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 8 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p8_gi250_a8_eta050_redo.out 2> ./outerr/Fed_HAPG_CartPole_0p8_gi250_a8_eta050_redo.err &
pid3=$!


# 打印进程ID
echo "PID of the 1 command: $pid0"
echo "PID of the 2 command: $pid1"
echo "PID of the 3 command: $pid2"
echo "PID of the 4 command: $pid3"

# 等待所有命令完成
wait $pid0
wait $pid1
wait $pid2
wait $pid3

echo "All commands have finished."
