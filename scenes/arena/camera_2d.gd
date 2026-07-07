extends Camera2D
class_name Camera

func _process(delta: float) -> void:
	# 如果全局角色存在，那么就把全局角色赋值给当前的照相机位置
	if is_instance_valid(Global.player):
		global_position = Global.player.global_position
	
