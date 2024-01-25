#!/bin/bash

# # finish eta = 0.050
python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.0 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p0_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_CartPole_0p0_gi150_a2_eta050.err
pid0=$!

# # 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.1 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p1_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_CartPole_0p1_gi150_a2_eta050.err
pid1=$!

# # 休息30mins
sleep 20

# now try a different eta = 0.10
python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.2 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p2_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_CartPole_0p2_gi150_a2_eta050.err
pid2=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.5 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p5_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_CartPole_0p5_gi150_a2_eta050.err
pid3=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.8 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_0p8_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_CartPole_0p8_gi150_a2_eta050.err
pid4=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 1.0 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_CartPole_1p0_gi150_a2_eta050.out 2> ./outerr/Fed_HAPG_CartPole_1p0_gi150_a2_eta050.err
pid5=$!

# 休息30mins
sleep 20

# now try another different eta = 0.100
python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.0 --num-agent 2 --eta 0.100 > ./outerr/Fed_HAPG_CartPole_0p0_gi150_a2_eta100.out 2> ./outerr/Fed_HAPG_CartPole_0p0_gi150_a2_eta100.err
pid6=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.1 --num-agent 2 --eta 0.100 > ./outerr/Fed_HAPG_CartPole_0p1_gi150_a2_eta100.out 2> ./outerr/Fed_HAPG_CartPole_0p1_gi150_a2_eta100.err
pid7=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.2 --num-agent 2 --eta 0.100 > ./outerr/Fed_HAPG_CartPole_0p2_gi150_a2_eta100.out 2> ./outerr/Fed_HAPG_CartPole_0p2_gi150_a2_eta100.err
pid8=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.5 --num-agent 2 --eta 0.100 > ./outerr/Fed_HAPG_CartPole_0p5_gi150_a2_eta100.out 2> ./outerr/Fed_HAPG_CartPole_0p5_gi150_a2_eta100.err
pid9=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 0.8 --num-agent 2 --eta 0.100 > ./outerr/Fed_HAPG_CartPole_0p8_gi150_a2_eta100.out 2> ./outerr/Fed_HAPG_CartPole_0p8_gi150_a2_eta100.err
pid10=$!

# 休息30mins
sleep 20

python -u Fed_HAPG.py --global-iteration 150 --env CartPole --beta 1.0 --num-agent 2 --eta 0.100 > ./outerr/Fed_HAPG_CartPole_1p0_gi150_a2_eta100.out 2> ./outerr/Fed_HAPG_CartPole_1p0_gi150_a2_eta100.err
pid11=$!

# 休息30mins
sleep 20



# 打印进程ID
echo "PID of the third command: $pid0"
echo "PID of the first command: $pid1"
echo "PID of the second command: $pid2"
echo "PID of the third command: $pid3"
echo "PID of the fourth command: $pid4"
echo "PID of the first command: $pid5"
echo "PID of the second command: $pid6"
echo "PID of the third command: $pid7"
echo "PID of the second command: $pid8"
echo "PID of the third command: $pid9"
echo "PID of the second command: $pid10"
echo "PID of the third command: $pid11"

# 等待所有命令完成
wait $pid0
wait $pid1
wait $pid2
wait $pid3
wait $pid4
wait $pid5
wait $pid6
wait $pid7
wait $pid8
wait $pid9
wait $pid10
wait $pid11

echo "All commands have finished."
