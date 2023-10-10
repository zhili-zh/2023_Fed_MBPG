import torch
import garage
from garage.experiment import run_experiment
from garage.experiment import LocalRunner
from garage.np.baselines import LinearFeatureBaseline
from garage.tf.envs import TfEnv
from Policy import GaussianMLPPolicy, CategoricalMLPPolicy
from Algorithms.MBPG import MBPG_IM
from gym.envs.mujoco import Walker2dEnv, HopperEnv,HalfCheetahEnv
from gym.envs.classic_control import CartPoleEnv

from garage.envs import normalize
import copy

import argparse
parser = argparse.ArgumentParser(description='FedSVRPG-M for DRL in mujoco')
parser.add_argument('--env', default='CartPole', type=str, help='choose environment from [CartPole, Walker, Hopper, HalfCheetah]')
parser.add_argument('--IS_MBPG_star', default=False, type=bool, help='whether to use IS-MBPG*')
parser.add_argument('--beta', default=0.5, type=float, help='the value of Beta')
parser.add_argument('--num-agent', default=5, type=int, help='the numbers of agents/devices')
parser.add_argument('--global-iteration', default=50, type=int, help='the numbers of global interations')
parser.add_argument('--local-iteration', default=10, type=int, help='the numbers of local interations')
parser.add_argument('--simple-avg', default='No', type=str)


args = parser.parse_args()

def run_task(snapshot_config, *_):
    """Set up environment and algorithm and run the task.
    Args:
        snapshot_config (garage.experiment.SnapshotConfig): The snapshot
            configuration used by LocalRunner to create the snapshotter.
            If None, it will create one with default settings.
        _ : Unused parameters
    """

    #count = 1
    th = 1.8
    g_max = 0.05
    star_version = args.IS_MBPG_star
    if args.env == 'CartPole':
    #CartPole

        env = TfEnv(normalize(CartPoleEnv()))
        runner = LocalRunner(snapshot_config)
        batch_size = 5000
        max_length = 100
        n_timestep = 5e5
        name = 'CartPole'
        #grad_factor = 5
        grad_factor = 100
        th = 1.2
        # # batchsize:1
        # lr = 0.1
        # w = 1.5
        # c = 15

        #batchsize:50
        lr = 0.75
        c = 1
        w = 1

        # for MBPG+:
        # lr = 1.2

        #g_max = 0.03
        discount = 0.995
        path = './init/CartPole_policy.pth'

    if args.env == 'Walker':
        #Walker_2d
        env = TfEnv(normalize(Walker2dEnv()))
        runner = LocalRunner(snapshot_config)
        batch_size = 50000
        max_length = 500

        th = 1.2

        n_timestep = 1e7
        lr = 0.75
        w = 2
        c = 5
        grad_factor = 10

        # for MBPG+:
        #lr = 0.9

        discount = 0.999

        name = 'Walk'
        path = './init/Walk_policy.pth'

    if args.env == 'Hopper':
        #Hopper
        env = TfEnv(normalize(HopperEnv()))
        runner = LocalRunner(snapshot_config)

        batch_size = 50000

        max_length = 1000
        th = 1.5
        n_timestep = 1e7
        lr = 0.75
        w = 1
        c = 3
        grad_factor = 10
        g_max = 0.15
        discount = 0.999

        name = 'Hopper'
        path = './init/Hopper_policy.pth'

    if args.env == 'HalfCheetah':
        env = TfEnv(normalize(HalfCheetahEnv()))
        runner = LocalRunner(snapshot_config)
        batch_size = 10000
        #batch_size = 50000
        max_length = 500

        n_timestep = 1e7
        lr = 0.6
        w = 3
        c =7
        grad_factor = 10
        th = 1.2
        g_max = 0.06

        discount = 0.999

        name = 'HalfCheetah'
        path = './init/HalfCheetah_policy.pth'

    num_policies = args.num_agent
    num_global_iterations = args.global_iteration
    num_local_iterations = args.local_iteration
    global_lr = 0.6
    local_lr = lr
    coef = global_lr / (local_lr * num_policies * num_local_iterations)
    beta = args.beta

    print("num_policies:", args.num_agent)
    print("num_global_iterations:", args.global_iteration)
    print("num_local_iterations:", args.local_iteration)
    print("global_lr:", 0.6)
    print("local_lr:", lr)
    print("coef:", 0.6 / (lr * args.num_agent * args.local_iteration))
    print("beta:", args.beta)


    # 初始化一个初始策略
    if args.env == 'CartPole':
        init_policy = CategoricalMLPPolicy(env.spec,
                                        hidden_sizes=[8, 8],
                                        hidden_nonlinearity=torch.tanh,
                                        output_nonlinearity=None)
    else:
        init_policy = GaussianMLPPolicy(env.spec,
                                        hidden_sizes=[64, 64],
                                        hidden_nonlinearity=torch.tanh,
                                        output_nonlinearity=None)

    # 循环num_global_iterations次
    for iteration in range(num_global_iterations):
        print("begin to train policies of iteration ", iteration)

        # 初始化5个策略，它们一开始都与初始策略相同
        policies = [copy.deepcopy(init_policy) for _ in range(num_policies)]
        init_policy_params = init_policy.state_dict()
        total_diff_params = {k: torch.zeros_like(v) for k, v in init_policy_params.items()}
        total_avg_params = {k: torch.zeros_like(v) for k, v in init_policy_params.items()}

        
        # 对每个策略进行训练
        index = 0
        for policy in policies:
            print("begin to train policy ", index)
            policy_params = policy.state_dict()
            for layer_name, param in policy_params.items():
                print(f"Layer: {layer_name}, Shape: {param.shape}")

            baseline = LinearFeatureBaseline(env_spec=env.spec)
            algo = MBPG_IM(env_spec=env.spec,
                   env = env,
                   env_name= name,
                   policy=policy,
                   baseline=baseline,
                   max_path_length=max_length,
                   discount=discount,
                   grad_factor=grad_factor,
                   policy_lr= lr,
                   c = c,
                   w = w,
                   n_timestep=batch_size*num_local_iterations,
                   #count=count,
                   th = th,
                   batch_size=batch_size,
                   center_adv=True,
                   g_max = g_max,
                   #decay_learning_rate=d_lr,
                   star_version=star_version,
                   beta=beta
                   )
            runner.setup(algo, env)
            runner.train(n_epochs=100, batch_size=batch_size)
            print("finish trainning policy ", index)

            # 计算差值，并累加到总差值中
            print("计算差值，并累加到总差值中")
            for key in init_policy_params:
                diff = policy.state_dict()[key] - init_policy_params[key]
                total_diff_params[key] += diff

            # 计算平均参数
            print("计算平均值")
            for key in init_policy_params:
                total_avg_params[key] += policy.state_dict()[key] / num_policies

            index = index + 1

        # 使用初始策略的参数和总差值更新每个策略
        if args.simple_avg == 'No':
            print("使用初始策略的参数和总差值更新每个策略")
            updated_params = {k: init_policy_params[k] + coef * total_diff_params[k] for k in init_policy_params}
            init_policy.load_state_dict(updated_params)
        elif args.simple_avg == 'Yes':
            print("使用初始策略的参数和策略的参数平均值更新每个策略")
            init_policy.load_state_dict(total_avg_params)
        else:
            print("不使用联邦学习")
            init_policy = copy.deepcopy(policy)
            policy_params = policy.state_dict()
            for layer_name, param in policy_params.items():
                print(f"Layer: {layer_name}, Shape: {param.shape}")



    # 这时，任意一个策略对象中都保存着最终的策略参数
    final_policy = policies[0]


run_experiment(
    run_task,
    snapshot_mode='last',
    seed=1,
)