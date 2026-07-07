extends Unit
class_name Enemy

@export var flock_push := 20.0

# 用于检测视野范围内的物体
@onready var vision_area: Area2D = $VisionArea

# 移动状态
var can_move := true

# 检测是否可以移动
func _process(delta: float) -> void:
	# 如果不能移动的话
	if not can_move:
		return
		
	# 检查是否应该朝向玩家移动
	# 如果返回 false，说明不在玩家附近或其它原因导致不能移动
	if not can_move_towards_player():
		return
		
	# 根据计算出的方向移动敌人
	position += get_move_direction()
	# 更新敌人朝向（视觉上）
	update_rotation()

# 计算敌人移动的方向向量
func get_move_direction() -> Vector2:
	# 如果全局玩家引用无效，返回零向量（不移动）
	if not is_instance_valid(Global.player):
		return Vector2.ZERO
		
	# 获取从敌人当前位置指向玩家当前位置的方向向量（单位向量）
	var direction := global_position.direction_to(Global.player.global_position)
	
	# 遍历视野区域内所有重叠的 Area2D 节点（通常是其他敌人）
	for area: Node2D in vision_area.get_overlapping_areas():
		# 确保这个区域不是自己，并且已经存在于场景树中
		if area != self and area.is_inside_tree():
			# 计算从当前敌人位置到检测到的敌人位置的向量（即分离方向）
			var vector := global_position - area.global_position
			# 将这个分离向量加入到总的移动方向中，以避免敌人聚集
			# flock_push 是一个系数，控制分离力的强度
			# vector.normalized() 是单位向量
			# / vector.length() 是为了使力随距离衰减（距离越近，力越大）
			direction += flock_push * vector.normalized() / vector.length()
	return direction
	
# 判断敌人是否应该朝向玩家移动
func can_move_towards_player() -> bool:
	# 确保玩家实例有效
	# 并且敌人与玩家的距离大于 60 单位（像素？）
	# 这个距离阈值决定了敌人何时开始追击
	return is_instance_valid(Global.player) and\
	global_position.distance_to(Global.player.global_position) > 60
	
# 更新敌人精灵的旋转（使其朝向玩家）
func update_rotation() -> void:
	# 如果玩家无效，不执行旋转更新
	if not is_instance_valid(Global.player):
		return
	
	# 获取玩家的全局坐标
	var player_pos := Global.player.global_position
	# 判断玩家是在敌人的左侧还是右侧
	var moving_right := global_position.x < player_pos.x
	# 根据左右调整精灵的缩放，实现翻转效果（左翻转，右正常）
	# 注意：这里 scale 的 x 分量是 -0.5 或 0.5，y 保持 0.5
	# 这通常是为了让精灵根据朝向左右翻转，而不是旋转
	visuals.scale = Vector2(-0.5, 0.5) if moving_right else Vector2(0.5, 0.5)
