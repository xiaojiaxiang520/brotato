extends Resource
# 物品基类
class_name ItemBase

# 物品类型
enum ItemType{
	# 武器
	WEAPON,
	# 升级
	UPGRADE,
	# 被动技能
	PASSIVE
}

# 物品名字
@export var item_name: String
# 物品图片
@export var item_icon: Texture2D
# 物品升级等级
@export var item_tier: Global.UpgredeTier
# 物品类型
@export var item_type: ItemType
# 物品花费
@export var item_cose: int

func get_desription() -> String:
	return ""
	
