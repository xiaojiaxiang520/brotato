extends Node2D
class_name Weapon

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var cooldown_timer: Timer = $CooldownTimer


# 武器
var data: ItemWeapon
# 是否攻击
var is_attacking := false
# 攻击起始位置
var atk_start_pos: Vector2
# 存储最近的敌方单位
var targets: Array[Enemy]
# 存储最近的敌人
var closest_target: Enemy
# 武器扩散
var weapon_spread: float

func _ready() -> void:
	# 初始化攻击的起始位置
	atk_start_pos = sprite.position

# 设置武器函数
func setup_weapon(data: ItemWeapon) ->void:
	# 设置了武器
	self.data = data
	# 每次更新武器，要求需要把攻击范围也修改了
	collision.shape.radius = data.stats.max_range
	
# 是否可以攻击
#func can_use_weapon() ->void:
	

# 进入范围
func _on_range_area_area_entered(area: Area2D) -> void:
	# 当敌人进入这个范围后，就进入附近敌人数组
	targets.push_back(area)

# 退出范围
func _on_range_area_area_exited(area: Area2D) -> void:
	# 当敌人退出这个范围后，就删除敌人
	targets.erase(area)
	if targets.size() == 0:
		# 设置最近的敌人
		closest_target = null
	
