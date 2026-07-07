extends Node2D
class_name FloatingText

# 子节点，用于显示文本
@onready var value_label: Label = $ValueLabel

# 初始化函数 参数一：现实的文本	参数二：显示的颜色
func setup (value: String, color: Color) -> void:
	# 修改文本
	value_label.text = value
	# 修改字体的颜色
	modulate = color
	# 初始缩放为0（从不可见开始）
	scale = Vector2.ZERO # 当前 scale = (0, 0)，节点完全看不见
	# 随机旋转 -10°~10°
	rotation = deg_to_rad(randf_range(-10, 10))
	# 随机最终缩放 0.8~1.6倍
	var random_scale := randf_range(0.8, 1.6)
	
	# tween 创建一个动画控制器
	var tween := create_tween()
	
	# 第一阶段：弹出 + 上浮（往上走一个单位）。	 我这里问了ai，这里不是真正的一起执行，如果需要一起执行，是需要var parallel_tween := tween.parallel()，
	# 然后调用parallel_tween.tween_progerty....
	# tween.parallel()	下一个动画与上一个同时执行（而不是顺序）
	# tween_property(目标, 属性名, 目标值, 时长)	在指定时长内将属性平滑过渡到目标值
	tween.parallel().tween_property(self, "scale", random_scale * Vector2.ONE, 0.4) # 放大，从0放到大后面的这个随机值，在0.4秒内放大到这个范围
	tween.parallel().tween_property(self, "global_position", global_position + Vector2.UP * 15, 0.4) # 上浮，0.4秒内位置上升到
	# 等待0.5秒（停留时间）
	tween.tween_interval(0.5)
	
	# 消失动画： 缩小+淡出
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4) # 缩小，将这个在0.4秒内缩小成0
	# 只修改modulate的透明度通道（alpha）
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4) # 淡出 将这个的alpha慢慢的修改成0
	# 动画结束 浮文本动画
	await tween.finished
	queue_free()
	
	
