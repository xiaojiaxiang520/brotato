extends Control
class_name HealthBar

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_label: Label = $HealthAmount

# 背景颜色
@export var back_color: Color
# 填充颜色
@export var fill_color: Color

func _ready() -> void:
	# 获取生命值进度条中的背景 复制一份(其实主要的目的是将我们外面设置的颜色，设置进入这个面板中)
	var back_style := progress_bar.get_theme_stylebox("background").duplicate()
	back_style.bg_color = back_color
	
	var fill_style := progress_bar.get_theme_stylebox("fill").duplicate()
	fill_style.bg_color = fill_color
	
	# 覆盖样式
	progress_bar.add_theme_stylebox_override("background", back_style)
	progress_bar.add_theme_stylebox_override("fill", fill_style)
	
# 更新血条控件,参数1：（当前血量/最大血量） 参数2：就是当前的血量
func update_bar(value: float, health: float) -> void:
	# 更新进度也就是float
	progress_bar.value = value
	# 更新血条的文本
	health_label.text = str(health)
	

# 血量改变监听 current 当前血量， 最大生命值
func _on_health_component_on_health_changed(current: float, max: float) -> void:
	var value = current / max
	update_bar(value, current)
