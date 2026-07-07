extends Resource
class_name UnitStats

enum UnitType {
	PLAYER,
	ENEMY
}

# 名称
@export var name:String
# 人物类型，玩家或者是npc
@export var type:UnitType
# 图片
@export var icon:Texture2D
# 生命值
@export var health := 1
# 每个实体每波生命值增加1
@export var health_increase_per_wave := 1.0
# 伤害值
@export var damage := 1.0
# 每一波伤害值
@export var damage_increase_per_wave := 1.0
# 默认速度
@export var speed := 300
# 默认幸运值
@export var luck := 1.0
# 默认格挡伤害
@export var block_change := 0.0
# 掉落
@export var gold_drop := 1
