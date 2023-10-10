#!/bin/bash

# 定义一个函数来运行任务
run_task() {
    env="$1"
    beta_value="$2"
    nohup python Fed_MBPG.py --env "$env" --beta "$beta_value" > "Fed_MBPG_${env}_${beta_value//.}p0.out" 2> "Fed_MBPG_${env}_${beta_value//.}p0.err" &
    # 获取最新后台进程的PID
    echo $!
}

beta_values=("0.0" "0.1" "0.2" "0.5" "0.8" "1.0")
environments=("Walker" "Hopper" "HalfCheetah")

for env in "${environments[@]}"; do
    pids=()
    # 启动该环境的所有任务
    for beta in "${beta_values[@]}"; do
        pids+=($(run_task "$env" "$beta"))
    done

    # 等待该环境的所有任务完成
    for pid in "${pids[@]}"; do
        wait $pid
    done

    echo "$env tasks completed."
done

echo "All tasks completed."
