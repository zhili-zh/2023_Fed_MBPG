#!/bin/bash

# Function to run general tasks for a specific environment three times
run_tasks() {
    env=$1
    for run in {1..3}; do
        for beta in 0.0 0.1 0.2 0.5 0.8 1.0; do
            outfile="Fed_MBPG_${env}_${beta//./p}_${run}.out"
            errfile="Fed_MBPG_${env}_${beta//./p}_${run}.err"
            nohup python Fed_MBPG.py --env "$env" --beta "$beta" > "$outfile" 2> "$errfile" &
        done
        echo "${env} tasks for run ${run} started."
        sleep 7200
    done
}

# Function to run special tasks with --simple-avg option for a specific environment three times
run_special_tasks() {
    env=$1
    for run in {1..3}; do
        outfile="Fed_MBPG_${env}_1p0_avg_${run}.out"
        errfile="Fed_MBPG_${env}_1p0_avg_${run}.err"
        nohup python Fed_MBPG.py --env "$env" --beta 1.0 --simple-avg Yes > "$outfile" 2> "$errfile" &
    done
    echo "Special ${env} tasks started."
    sleep 3600
}

# Run tasks
run_tasks CartPole
run_tasks Walker
run_tasks Hopper
run_tasks HalfCheetah

echo "All fed tasks scheduled."

# Run special tasks
run_special_tasks CartPole
run_special_tasks Walker
run_special_tasks Hopper
run_special_tasks HalfCheetah

echo "All avg tasks scheduled."
