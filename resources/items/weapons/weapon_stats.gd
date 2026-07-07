extends Resource
class_name WeaponStats

# 武器伤害
@export var damage := 1.0
# 武器的精准度
@export_range(0.0, 1.0) var accuracy := 0.9
# 武器冷却时间
@export_range(0.5, 3.0) var cooldown := 1.0
# 武器命中率
@export_range(0.0, 1.0) var crit_chance := 0.05
# 击中伤害
@export var crit_damage := 1.5
# 武器最大射程
@export var max_range := 150.0
# 武器击退效果
@export var knockback := 0.0
# 射程范围
@export_range(0.0, 1.0) var life_steal := 0.0
# 武器后坐力
@export var recoil := 25.0
# 后坐力持续时间
@export_range(0.1, 3.0) var recoil_duration := 0.1
# 武器攻击持续时间
@export_range(0.1, 3.0) var attaack_duration := 0.2
# 返回持续时间
@export_range(0.1, 3.0) var back_duration := 0.15
# 弹药
@export var projectile_scene: PackedScene
# 子弹速度
@export var projectile_speed := 1600.0
