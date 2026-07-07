extends Area2D
class_name HitboxComponent

# 定义一个信号，这个信号暂时还没有使用到
signal on_hit_hurbox(hurbox: HurboxComponent)

# 伤害
var damage := 1.0
# 是否暴击
var critical := false
# 击退
var knockback_power := 0.0
# 攻击者
var source: Node2D

# 设置是否开启，就是如果武器在攻击出去的时候，需要设置为物理碰撞
# 当武器回来的时候，需要设置为不开启物理接触
func enable() -> void:
	# 设置进入这个范围的检测，开启这个检测
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	
# 停止开启，武器回来的时候
func disable() -> void:
	# 设置进入这个范围的检测
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	
# 初始化变量
# damage：伤害	cirtical：是否暴击	knockack：击退	source：来源，攻击者
func setup(damage: float, cirtical: bool, knockback: float, source: Node2D) -> void:
	# 初始化伤害
	self.damage = damage
	# 初始化暴击
	self.critical = critical
	# 初始化击退
	knockback_power = knockback
	# 初始化节点
	self.source = source
	

# 当进入的时候进行判断
func _on_area_entered(area: Area2D) -> void:
	# 是否是属于伤害组件，如果是伤害组件，那么就发送一个信号
	if area is HurboxComponent:
		# 这个信号暂时还没有使用到
		on_hit_hurbox.emit(area)
		print(area.owner.name)
