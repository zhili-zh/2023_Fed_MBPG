import numpy as np
from gym.envs.mujoco import Walker2dEnv, HopperEnv, HalfCheetahEnv

class CustomHalfCheetahEnv(HalfCheetahEnv):

    def __init__(self, custom_low_bound=-0.1, custom_high_bound=0.1, **kwargs):
        super().__init__(**kwargs)  # 调用父类的初始化方法
        self.custom_low_bound = custom_low_bound
        self.custom_high_bound = custom_high_bound

    def reset_model(self):
        qpos = self.init_qpos + self.np_random.uniform(
            low=self.custom_low_bound, high=self.custom_high_bound, size=self.model.nq
        )
        qvel = self.init_qvel + self.np_random.standard_normal(self.model.nv) * 0.1
        self.set_state(qpos, qvel)
        return self._get_obs()