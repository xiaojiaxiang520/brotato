extends Node2D
class_name Weapon

# 精灵
@onready var sprite: Sprite2D = $Sprite2D
# 碰撞
@onready var collision: CollisionShape2D = %CollisionShape2D
# 冷却
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

func _process(delta: float) -> void:
	# 武器不在攻击
	if not is_attacking:
		# 范围内有敌人
		if targets.size() > 0:
			# 更新获取最近的敌人
			update_closest_target()
		else:
			# 范围内没有敌人
			closest_target = null
	
	# 调用武器转向的方法
	rotate_to_target()
	
# 设置武器函数
func setup_weapon(data: ItemWeapon) ->void:
	# 设置了武器
	self.data = data
	# 每次更新武器，要求需要把攻击范围也修改了
	collision.shape.radius = data.stats.max_range

# 使用武器
func use_weapon() -> void:
	# 武器散步
	calculate_spread()

# 旋转武器函数
func rotate_to_target() -> void:
	# 在攻击
	if is_attacking:
		rotation = get_custom_rotation_to_target()
	# 不在攻击
	else:
		rotation = get_rotation_to_target()
		
# 如果武器正在攻击，需要一个立体的转向
func get_custom_rotation_to_target() -> float:
	# 如果附近没有目标，我们需要返回当前的转向
	if not closest_target or not is_instance_valid(closest_target):
		return rotation
	
	# 获得角度，用于旋转武器
	var rot := global_position.direction_to(closest_target.global_position).angle()
	# 返回 武器角度 + 武器散布
	return rot + weapon_spread
	
# 武器没有攻击
func get_rotation_to_target() -> float:
	# 没有敌人的时候，就是自己面向的角度
	if targets.size() == 0:
		return get_idle_rotation()
		
	# 有敌人的时候，获得的角度是和敌人的角度，用于旋转武器
	var rot := global_position.direction_to(closest_target.global_position).angle()
	# 返回 武器角度
	return rot

# 武器的空闲旋转
func get_idle_rotation() -> float:
	# 调用player中的方法，方法作用是 当前人物是否是向右看
	if Global.player.is_facing_right():
		return 0
	else:
		return PI

# 计算散布函数
func calculate_spread() -> void:
	weapon_spread += randf_range(-1 + data.stats.accuracy, 1 - data.stats.accuracy)
	rotation += weapon_spread

# 更新靠近武器最近的目标
func update_closest_target() -> void:
	closest_target = get_closest_target()

# 获取最近敌人目标(有点疑问，这样的性能会不会下降，因为每次都是这样的查询，有优化的方法吗)
func get_closest_target() -> Node2D:
	if targets.size() == 0:
		return
	# 获取第一个敌人的引用
	var closest_enemy := targets[0]
	# 获取第一个敌人的距离
	var closest_distance := global_position.distance_to(closest_enemy.global_position)
	
	# 遍历每一个敌人，寻找最近的敌人
	for i in range(1, targets.size()):
		var taget: Enemy = targets[i]
		var distance := global_position.distance_to(taget.global_position)
		
		if distance < closest_distance:
			closest_enemy = taget
			closest_distance = distance
			
	return closest_enemy
	
# 是否可以攻击
func can_use_weapon() -> bool:
	return cooldown_timer.is_stopped() and closest_target

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
	
