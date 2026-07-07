extends Node2D
class_name Arena

# 定义一个外面可以设置的参数
@export var player: Player

# 导出定义颜色
@export var normal_color: Color
@export var blocked_color: Color
@export var critical_color: Color
@export var hp_color: Color

# 将导入的角色设置成全局文件中的角色
func _ready() -> void:
	Global.player = player
	
	# 新增关联信号 这个是格挡创建文本信号
	Global.on_create_block_text.connect(_on_create_block_text)
	# 绑定了Global中的伤害文本信号，然后后面的是绑定的方法名字
	Global.on_create_damage_text.connect(_on_create_damage_text)

# 格挡信号的触发
func _on_create_block_text(unit: Node2D) -> void:
	var text := create_floating_text(unit)
	text.setup("Blocked！", blocked_color)

# 伤害信号触发
func _on_create_damage_text(unit: Node2D, hitbox: HitboxComponent) -> void:
	var text := create_floating_text(unit)
	var color := critical_color if hitbox.critical else normal_color
	text.setup(str(hitbox.damage), color)

# 创建一个文本浮窗
func create_floating_text(unit: Node2D) -> FloatingText:
	# 从Global全局中模板克隆一个新的对象
	var instance := Global.FLOATING_TEXT_SCENE.instantiate() as FloatingText
	# 将这个资源添加进入节点树中
	get_tree().root.add_child(instance)
	# 生成随机角度,生成 0 ~ 6.28 之间的随机小数（一个完整圆的弧度）
	var random_pos := randf_range(0, TAU) * 35
	# 计算生成位置：
	# unit.global_position：传入单位的全局位置（比如敌人的位置
	# Vector2.RIGHT：向右的单位向量 (1, 0)
	# rotated(random_pos)：把这个向量旋转随机角度 这两个合起来就是：把旋转后的偏移量加到单位位置上
	var spawn_pos := unit.global_position + Vector2.RIGHT.rotated(random_pos)
	# 放在上面以中心点生成的位置中
	instance.global_position = spawn_pos
	# 返回结果
	return instance

	
