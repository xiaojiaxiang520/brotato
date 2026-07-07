extends Node2D
class_name Unit

# 导出一个数值配置，资源文件
@export var stats: UnitStats

# visual
@onready var visuals: Node2D = %Visuals
# sprite
@onready var sprite: Sprite2D = %Sprite
# 动画（如果在基础类中定义了这个，那么所有的子类都是会有这个属性的）
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# 引用健康组件
@onready var health_component: HealthComponent = $HealthComponent

# 被攻击的材质包
@onready var flash_timer: Timer = $FlashTimer

# 初始化函数
func _ready() -> void:
	# 初始化一下这个健康模块，玩家的生命值
	health_component.setup(stats)

# 修改Unit基类的材质
func set_flash_material() -> void:
	sprite.material = Global.FLASH_MATERIAL
	# 并且启动定时器，然后在0.2秒的时候恢复原来的材质
	flash_timer.start()
	
# HurboxComponent组件中发出的信号(其实也就是碰撞之后出发的信号)，就是监听一下这个HurboxComponent中发出的信号，然后这里监听，监听之后，这里就会执行
# 到目前位置，目前只有这一个地方使用了监听，并且是有执行的结果。
func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	# 因为这个是碰撞之后需要减少角色的生命值，所以需要判断当前的生命值不可以低于0
	if health_component.current_health <= 0:
		return
	
	# 格挡值判断，stats中的整数，所以需要注意.被格挡后就没有后面的操作了
	var block := Global.get_chance_success(stats.block_change / 100) # 这里的change打错了，应该是chance
	if block:
		print("Blocked!")
		Global.on_create_block_text.emit(self) # 发送创建文本的信号，创建格挡的信号
		return
	
	#当被攻击的时候，调用切换材质包的函数
	set_flash_material()
	# 调用健康组件中的减少生命值方法
	health_component.task_damage(hitbox.damage)	
	# 打印当前角色的生命值
	print("%s: %d" % [name, health_component.current_health])
	Global.on_create_damage_text.emit(self, hitbox) # 发送创建伤害的文本信号，这个信号需要传入当前的hixbox


# FlashTimter超时后，我们需要将原来的这个设置会原来的材质
func _on_flash_timer_timeout() -> void:
	sprite.material = null
