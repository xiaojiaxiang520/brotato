extends Unit
class_name Player

# 暴露节点
@export var dash_duration := 0.5
# 速度倍速
@export var dash_speed_multi := 2.5 
@export var dash_cooldown := 0.5

# 该对象导入的其他节点
# 两个Timer节点
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
# 一个物理碰撞
@onready var collision: CollisionShape2D = $CollisionShape2D
# 拖尾
@onready var trail: Trail = %Trail

# 武器容器引入
@onready var weapon_contrainer: WeaponContainer = $WeaponContrainer
# 初始化武器数组
var current_weapons: Array[Weapon] = []

# 移动向量（移动方向）
var move_dir: Vector2
# 是否冲刺中
var is_dashing := false
# 是否可冲刺
var dash_available := true

# 初始化
func _ready() -> void:
	# 这个是防止玩家初始化生命值，要求先调用一下父类的初始化，因为这个初始化是在父类中的实现的，避免了覆盖
	super._ready()
	dash_timer.wait_time = dash_duration # 等待时间
	dash_cooldown_timer.wait_time = dash_cooldown # 等待时间
	
	# 模拟添加武器
	add_weapon(preload("uid://dspcu8h8mjyyy"))
	
# 每帧
func _process(delta: float) -> void:
	# 移动方向，获取从按键获取这个值
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
	# 设置速度，使用配置
	var current_velocity := move_dir * stats.speed
	
	# 如果在冲刺状态，如果在冲刺状态则设置新的速度。 （这里我感觉可以优化，就是不需要进行判断，反而将这个被设置成值，开启的时候设置为 3，结束的时候设置回原来的值
	if is_dashing:
		current_velocity *= dash_speed_multi # 设置冲刺速度倍率
		
	# 设置player的位置，position这个属性，当前的脚本属于谁的，就是谁的属性，
	# 也就是这个属性是属于当前的根的属性
	position += current_velocity * delta # 这里为什么要乘法于帧数，我不是很明白
		
	# 限制玩家的移动，不要超过的范围，也就是空气墙
	position.x = clamp(position.x, -1000, 1000)
	position.y = clamp(position.y, -500, 500)

	# 如果可以冲刺就冲刺
	if can_dash():
		start_dash()
	
	# 更新动画
	update_animations()
	# 更新方向
	update_ratation()

# 添加武器
func add_weapon(data: ItemWeapon) -> void:
	# 获取data中的场景weapon ，并且将其转换为Weapon
	var weapon := data.scene.instantiate() as Weapon
	# 进入场景树
	add_child(weapon)
	# 设置武器的信息
	weapon.setup_weapon(data)
	# 放入到武器数组中
	current_weapons.append(weapon)
	# 更新武器视图
	weapon_contrainer.update_weapons_position(current_weapons)
	
	
# 更新动画
func update_animations() -> void:
		# 因为只要这个移动的值大于0，那么就是场景里面，如果没有移动，那么就是空闲动画
	if move_dir.length() > 0:
		# 这个anim_player这个属性，是在基础类中定义的，这里虽然没有定义，但是可以直接使用
		# 这里还有注意一个点，可以发现这个动画是其实操作的是unit场景中的根的值，但是我们这个继承了unit节点，那么就当前的根节点就是unit的根节点了
		# 那么这个anim_player其实播放的还是我们的在这个player的根节点
		anim_player.play("move")
	else:
		# 空闲动画
		anim_player.play("idle")
		
# 更新面的朝向
func update_ratation() -> void:
	# 如果当前的位置是为0，那么就是原来的样子
	if move_dir == Vector2.ZERO:
		return
	
	# R 如果这个x大于0，则是向右，小于0则是向左
	if move_dir.x >= 0.1:
		# 这是是操控这当前场景的Visual节点的Scale，其实原来的就是0.5，现在也是，只是换了一个方向
		visuals.scale = Vector2(-0.5, 0.5)
	else:
		visuals.scale = Vector2(0.5, 0.5)

# 冲刺函数
func start_dash() -> void:
	# 冲刺状态打开
	is_dashing = true
	# 开始定时器
	dash_timer.start()
	trail.start_tail() # 调用拖尾里面的方法
	# 设置透明度
	visuals.modulate.a = 0.5
	# 延时碰撞
	collision.set_deferred("disabled", true)

# 能否冲刺函数
func can_dash() -> bool:
	# 不在冲刺状态 and # 冲刺冷却计时器已停止 and 按下了空格键 and 移动方向不为0
	return not is_dashing and\
	dash_cooldown_timer.is_stopped() and\
	Input.is_action_just_pressed("dash") and\
	move_dir != Vector2.ZERO

# 获取角色是否转向
func is_facing_right() -> bool:
	return visuals.scale.x == -0.5

# 当DashTimer超时时候调用
func _on_dash_timer_timeout() -> void:
	is_dashing = false
	visuals.modulate.a = 1.0 # 透明度设置回 1
	move_dir = Vector2.ZERO # 设置方向向量为0，感觉这个意义不是很大
	# 开启碰撞
	collision.set_deferred("disabled", false)
	dash_cooldown_timer.start() # 这个只是用于记录当前是否冷却，没有超时回调，因为过了等待时间就是stop了
