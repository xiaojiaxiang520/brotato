extends Line2D
class_name Trail

# 角色
@export var player: Player
# 拖尾长度,也就是这个数组的长度
@export var trail_length := 25
# 拖尾持续时间
@export var trail_duration := 1.0

# 定时器
@onready var trail_timer: Timer = %TrailTimer

# 定义一个数组，用于存储玩家的位置
var posint_array: Array[Vector2] = []
# 开启状态
var is_active := false

func _process(delta: float) -> void:
	# 如果没有激活则直接返回
	if not is_active:
		return
		
	# 添加玩家的位置
	posint_array.append(player.global_position)
	# 如果数组的长度大于25则删除第一个坐标
	if posint_array.size() > trail_length:
		posint_array.pop_front()
	# 将数组中的25个点赋值给这个拖尾线
	points = posint_array

# 这个方法将用于玩家调用
func start_tail() -> void:
	is_active = true
	# 移除所有点，使其为空
	clear_points()
	# 删除所有的点，那么数组的坐标也是需要全部删除
	posint_array.clear()
	# 启动定时器，指定时间
	trail_timer.start(trail_duration)

# 拖尾定时器超时时候，调用
func _on_trail_timer_timeout() -> void:
	is_active = false;
	clear_points()
	posint_array.clear()
