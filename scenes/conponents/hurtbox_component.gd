extends Area2D
class_name HurboxComponent

# 自定义创建信号， 就是下面的这个信号，要求传入一个HitboxComponent
signal on_damaged(hitbox: HitboxComponent)

# 当进入到这个范围，则发送伤害信号
func _on_area_entered(area: Area2D) -> void:
	# 要求必须要是HitboxComponent组件，因为这个组件目前只有在enmey上面才有，这个是热点碰撞区域
	# 其实每次敌人碰撞后，都会进入这个判断，然后判断这个对象是否是HitboxComponent组件，如果是，才会发送信号
	# 目前，这个只有在Player中才有效，因为只有在Player中的HurboxComponenet下面才会有碰撞的Collision范围，在enemy中是没有作用的
	if area is HitboxComponent:
		# 发送信号，表示造成了伤害，需要减少生命值
		on_damaged.emit(area)
		
