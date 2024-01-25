#!/bin/bash

# # finish eta = 0.050
nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.0 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p0_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p0_gi150_a2_eta050.err  &
# pid0=$!

# # 休息30mins
# sleep 20

nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.1 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p1_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p1_gi150_a2_eta050.err &
# pid1=$!

# # # 休息30mins
# sleep 20

# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.2 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p2_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p2_gi150_a2_eta050.err &
# pid2=$!

# # 休息30mins
# sleep 20

# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.5 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p5_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p5_gi150_a2_eta050.err &
# pid3=$!

# # 休息30mins
# sleep 20

# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.8 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p8_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p8_gi150_a2_eta050.err &
# pid4=$!

# # 休息30mins
# sleep 20

# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 1.0 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_1p0_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_HalfCheetah_1p0_gi150_a2_eta050.err &
# pid5=$!


# 打印进程ID
echo "PID of the 1 command: $pid0"
echo "PID of the 2 command: $pid1"
echo "PID of the 3 command: $pid2"
echo "PID of the 4 command: $pid3"
echo "PID of the 5 command: $pid4"
echo "PID of the 6 command: $pid5"


# 等待所有命令完成
wait $pid0
wait $pid1
wait $pid2
wait $pid3
wait $pid4
wait $pid5

echo "All commands have finished."
