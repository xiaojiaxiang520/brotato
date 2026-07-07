extends Node
class_name HealthComponent

# 单位生命值信号
signal on_unit_hit
# 单位死亡信号
signal on_unit_died
# 健康变化(共享当前生命值和最大生命值)
signal on_health_changed(current: float, max: float)

# 初始化最大生命值和当前的生命值
var max_health := 1.0
var current_health := 1.0

# 初始化，（在Unit的脚本时中进行了初始化）
func setup(stats: UnitStats) -> void:
	# 初始化生命
	max_health = stats.health
	# 初始化最大生命值
	current_health = max_health
	# 发送生命改变信号
	on_health_changed.emit(current_health, max_health)

# 受到攻击（参数是伤害值）
func task_damage(value: float) -> void:
	# 如果生命值为0 则返回
	if current_health <= 0:
		return
	# 两个生命值，如果包含0，则选择一个最小的
	current_health -= value
	current_health = max(current_health, 0)
	
	# 发送信号单位生命值信号
	on_unit_hit.emit()
	# 发送生命值改变信号
	on_health_changed.emit(current_health, max_health)
	
	# 如果生命值小于0，则死亡
	if current_health <= 0:
		current_health = 0
		on_unit_died.emit()
		die()
		
# 回复生命函数
func heal(amount: float) -> void:
	# 如果生命值低于0
	if current_health <= 0:
		return
	# 当前生命值+
	current_health += amount
	# 选择一个最小的生命值
	current_health = min(current_health, max_health)
	# 触发生命值改变信号
	on_health_changed.emit(current_health, max_health)
		
func die() -> void:
		owner.queue_free()
		
	
