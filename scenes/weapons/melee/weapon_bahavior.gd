extends Node2D
class_name WeaponBehavior

# 主要这些都是武器行为

@export var weapon: Weapon

# 是否暴击
var critical := false

# 攻击函数
func execute_attack() -> void:
	pass

# 获取伤害函数，当前我们对敌人施加伤害时，需要添加武器伤害或者是玩家伤害，还需是应用暴击伤害
func get_damage() -> float:
	# 伤害 = 武器伤害 + 人物伤害
	var damage := weapon.data.stats.damage + Global.player.stats.damage
	# 暴击率，获取武器的暴击率
	var cri_chance := weapon.data.stats.crit_chance
	
	# 调用全局文件里面的是否命中
	if Global.get_chance_success(cri_chance):
		# 命中，设置为暴击
		critical = true
		# 向上取证获取暴击
		damage += ceil(damage * weapon.data.stats.crit_damage)
	return damage
