extends Node2D
# 武器容器
class_name WeaponContainer

# 武器节点
@onready var one: Node2D = $One
@onready var two: Node2D = $Two
@onready var three: Node2D = $Three
@onready var four: Node2D = $Four
@onready var five: Node2D = $Five
@onready var six: Node2D = $Six

# 更新武器
func update_weapons_position(weapons: Array[Weapon]) -> void:
	# 获取武器的数量
	var count := weapons.size()
	# 定义对应武器数量的节点,
	var reference_node: Node2D
	match count:
		1: reference_node = one
		2: reference_node = one
		3: reference_node = one
		4: reference_node = one
		5: reference_node = one
		6: reference_node = one
	
	# 获取武器节点的子节点
	var markers := reference_node.get_children()
	# 为了安全重新校验一下
	if markers.size() != count:
		return
	for i in count:
		weapons[i].global_position = markers[i].global_position
