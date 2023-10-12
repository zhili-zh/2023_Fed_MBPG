import numpy as np
from gym.envs.classic_control.cartpole import CartPoleEnv

class CustomCartPoleEnv(CartPoleEnv):

    def __init__(self, custom_low_bound=-0.05, custom_high_bound=0.05, **kwargs):
        super().__init__(**kwargs)  # 调用父类的初始化方法
        self.custom_low_bound = custom_low_bound
        self.custom_high_bound = custom_high_bound

    def reset(self, *args, **kwargs):
        super().reset(*args, **kwargs)  # 调用父类的reset方法
        # 这里我们只修改了初始状态的上下界，其他部分保持不变
        self.state = self.np_random.uniform(low=self.custom_low_bound, high=self.custom_high_bound, size=(4,))
        self.steps_beyond_terminated = None
        return np.array(self.state, dtype=np.float32)
