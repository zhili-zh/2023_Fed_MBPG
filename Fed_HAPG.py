import torch
import garage
from garage.experiment import run_experiment
from garage.experiment import LocalRunner
from garage.np.baselines import LinearFeatureBaseline
from garage.tf.envs import TfEnv
from Policy import GaussianMLPPolicy, CategoricalMLPPolicy
from Algorithms.MBPG_HA import MBPG_HA
from gym.envs.mujoco import Walker2dEnv, HopperEnv, HalfCheetahEnv
from gym.envs.classic_control import CartPoleEnv
#from garage.envs.box2d import CartpoleEnv
from garage.envs import normalize
import copy
import argparse
from Envs.cartpole import CustomCartPoleEnv
from Envs.halfcheetah import CustomHalfCheetahEnv
from Envs.hopper import CustomHopperEnv
from Envs.walker2d import CustomWalker2dEnv
import numpy as np

parser = argparse.ArgumentParser(description='FedHAPG-M for DRL in mujoco')
parser.add_argument('--env', default='CartPole', type=str, help='choose environment from [CartPole, Walker, Hopper, HalfCheetah]')
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

    th = 1.8
    g_max = 0.1
    env_list = []
    sample_noise_list = []
    #delta = 1e-7
    if args.env == 'CartPole':
        #CartPole
        for _ in range(args.num_agent):
            sample_noise = np.random.uniform(-0.005, 0.005)
            env_list.append(TfEnv(normalize(CustomCartPoleEnv(custom_low_bound=-0.05-sample_noise, custom_high_bound=0.05+sample_noise))))
            sample_noise_list.append(sample_noise)
        runner = LocalRunner(snapshot_config)
        batch_size = 5000
        max_length = 100
        n_timestep = 5e5
        n_counts = 5
        name = 'CartPole'
        grad_factor = 5
        th = 1.2
        #batchsize: 1
        # lr = 0.1
        # w = 2
        # c = 50

        #batchsize: 50
        lr = 0.75
        c = 3
        w = 2

        discount = 0.995
        path = './init/CartPole_policy.pth'

    if args.env == 'Walker':
        #Walker_2d
        for _ in range(args.num_agent):
            sample_noise = np.random.uniform(-0.0005, 0.0005)
            env_list.append(TfEnv(normalize(CustomWalker2dEnv(custom_low_bound=-0.005-sample_noise, custom_high_bound=0.005+sample_noise))))
            sample_noise_list.append(sample_noise)
        runner = LocalRunner(snapshot_config)
        batch_size = 50000
        max_length = 500

        n_timestep = 1e7
        n_counts = 5
        lr = 0.75
        w = 2
        c = 12
        grad_factor = 6

        discount = 0.999

        name = 'Walk'
        path = './init/Walk_policy.pth'

    if args.env == 'HalfCheetah':
        for _ in range(args.num_agent):
            sample_noise = np.random.uniform(-0.0005, 0.0005)
            env_list.append(TfEnv(normalize(CustomHopperEnv(custom_low_bound=-0.005-sample_noise, custom_high_bound=0.005+sample_noise))))
            sample_noise_list.append(sample_noise)
        runner = LocalRunner(snapshot_config)

        batch_size = 50000
        max_length = 500

        n_timestep = 1e7
        n_counts = 5
        lr = 0.6
        w = 1
        c = 4
        grad_factor = 5
        th = 1.2
        g_max = 0.06

        discount = 0.999

        name = 'HalfCheetah'
        path = './init/HalfCheetah_policy.pth'

    if args.env == 'Hopper':
        #Hopper
        for _ in range(args.num_agent):
                sample_noise = np.random.uniform(-0.01, 0.01)
                env_list.append(TfEnv(normalize(CustomHalfCheetahEnv(custom_low_bound=-0.1-sample_noise, custom_high_bound=0.1+sample_noise))))
                sample_noise_list.append(sample_noise)
        runner = LocalRunner(snapshot_config)

        batch_size = 50000
        max_length = 1000
        th = 1.5
        n_timestep = 1e7
        n_counts = 5
        lr = 0.75
        w = 1
        c = 3
        grad_factor = 6
        g_max = 0.15
        discount = 0.999

        name = 'Hopper'
        path = './init/Hopper_policy.pth'

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
    # print("simple_avg:", args.simple_avg)
    print("sample_noise_list:", sample_noise_list)
    print("local_lr:", lr)
    print("coef:", 0.6 / (lr * args.num_agent * args.local_iteration))
    print("beta:", args.beta)

    if args.env == 'CartPole':
        init_policy = CategoricalMLPPolicy(env_list[0].spec,
                                    hidden_sizes=[8, 8],
                                    hidden_nonlinearity=torch.tanh,
                                    output_nonlinearity=None)
    else:
        init_policy = GaussianMLPPolicy(env_list[0].spec,
                                    hidden_sizes=[64, 64],
                                       hidden_nonlinearity=torch.tanh,
                                       output_nonlinearity=None)

    # init_policy.load_state_dict(torch.load(path))
    for iteration in range(num_global_iterations):
        # 初始化5个策略，它们一开始都与初始策略相同
        policies = [copy.deepcopy(init_policy) for _ in range(num_policies)]
        init_policy_params = init_policy.state_dict()
        total_diff_params = {k: torch.zeros_like(v) for k, v in init_policy_params.items()}
        total_avg_params = {k: torch.zeros_like(v) for k, v in init_policy_params.items()}

        for i, env in enumerate(env_list):
            policy = policies[i]
            # print("begin to train policy ", index)
            policy_params = policy.state_dict()
            baseline = LinearFeatureBaseline(env_spec=env.spec)
            algo = MBPG_HA(env_spec=env.spec,
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
                    th=th,
                    g_max=g_max,
                    n_timestep=batch_size*num_local_iterations,
                    batch_size=batch_size,
                    center_adv=True,
                    beta=beta
                    # delta=delta
                    #decay_learning_rate=d_lr,
                    )
            runner.setup(algo, env)
            _, new_policy = runner.train(n_epochs=100, batch_size=batch_size)

            # 计算差值，并累加到总差值中
            # print("计算差值，并累加到总差值中")
            for key in init_policy_params:
                diff = new_policy.state_dict()[key] - init_policy_params[key]
                total_diff_params[key] += diff

            # 计算平均参数
            # print("计算平均值")
            for key in init_policy_params:
                total_avg_params[key] += new_policy.state_dict()[key] / num_policies
        
        # 使用初始策略的参数和总差值更新每个策略
        if args.simple_avg == 'No':
            # print("使用初始策略的参数和总差值更新每个策略")
            updated_params = {k: init_policy_params[k] + coef * total_diff_params[k] for k in init_policy_params}
            init_policy.load_state_dict(updated_params)
        elif args.simple_avg == 'Yes':
            # print("使用初始策略的参数和策略的参数平均值更新每个策略")
            init_policy.load_state_dict(total_avg_params)
        else:
            # print("不使用联邦学习")
            init_policy = copy.deepcopy(new_policy)
    
    final_policy = init_policy

run_experiment(
    run_task,
    snapshot_mode='last',
    seed=1,
)