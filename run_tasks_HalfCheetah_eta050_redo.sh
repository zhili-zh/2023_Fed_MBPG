#!/bin/bash


# nohup python -u Fed_MBPG.py --global-iteration 150 --env HalfCheetah --beta 0.2 --num-agent 2 --eta 0.050 > ./outerr/Fed_MBPG_HalfCheetah_0p2_gi150_a2_eta050_redo.out 2> ./outerr/Fed_MBPG_HalfCheetah_0p2_gi150_a2_eta050_redo.err &
# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.2 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p2_gi150_a2_eta050_redo.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p2_gi150_a2_eta050_redo.err &

# nohup python -u Fed_MBPG.py --global-iteration 150 --env HalfCheetah --beta 0.5 --num-agent 2 --eta 0.050 > ./outerr/Fed_MBPG_HalfCheetah_0p5_gi150_a2_eta050_redo.out 2> ./outerr/Fed_MBPG_HalfCheetah_0p5_gi150_a2_eta050_redo.err &
# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.5 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p5_gi150_a2_eta050_redo.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p5_gi150_a2_eta050_redo.err &


nohup python -u Fed_MBPG.py --global-iteration 150 --env HalfCheetah --beta 0.8 --num-agent 2 --eta 0.050 > ./outerr/Fed_MBPG_HalfCheetah_0p8_gi150_a2_eta050_redo.out 2> ./outerr/Fed_MBPG_HalfCheetah_0p8_gi150_a2_eta050_redo.err &
pid1=$!
sleep 40

nohup python -u Fed_MBPG.py --global-iteration 150 --env HalfCheetah --beta 1.0 --num-agent 2 --eta 0.050 > ./outerr/Fed_MBPG_HalfCheetah_1p0_gi150_a2_eta050_redo.out 2> ./outerr/Fed_MBPG_HalfCheetah_1p0_gi150_a2_eta050_redo.err &
pid2=$!
sleep 40

nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.5 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p5_gi150_a2_eta050_redo.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p5_gi150_a2_eta050_redo.err &
pid3=$!
# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 0.8 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_0p8_gi150_a2_eta050_redo.out 2> ./outerr/Fed_HAPG_HalfCheetah_0p8_gi150_a2_eta050_redo.err &
# nohup python -u Fed_HAPG.py --global-iteration 150 --env HalfCheetah --beta 1.0 --num-agent 2 --eta 0.050 > ./outerr/Fed_HAPG_HalfCheetah_1p0_gi150_a2_eta050_redo.out 2> ./outerr/Fed_HAPG_HalfCheetah_1p0_gi150_a2_eta050_redo.err &


echo "PID of the 2 command: $pid1"
echo "PID of the 3 command: $pid2"
echo "PID of the 4 command: $pid3"

wait $pid1
wait $pid2
wait $pid3

echo "All commands have finished."