#!/bin/bash

# # finish eta = 0.050
python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 1 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a1_eta050.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a1_eta050.err
pid0=$!

# # 休息30mins
sleep 20

python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 2 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a2_eta050.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a2_eta050.err
pid1=$!

# # 休息30mins
sleep 20

python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 10 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a10_eta050.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a10_eta050.err
pid2=$!

# 休息30mins
sleep 20

python -u Fed_MBPG.py --global-iteration 250 --env CartPole --beta 0.8 --num-agent 20 --eta 0.050 > ./outerr/Fed_MBPG_CartPole_0p8_gi250_a20_eta050.out 2> ./outerr/Fed_MBPG_CartPole_0p8_gi250_a20_eta050.err
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
