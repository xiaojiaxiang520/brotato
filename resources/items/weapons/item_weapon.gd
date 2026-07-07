extends ItemBase
# 武器基类
class_name ItemWeapon

# 武器类型： 近战、远程
enum WeaponType {
	MELEE,
	RANGE
}

# 导出武器类型
@export var type: WeaponType
# 当前武器场景的引用
@export var scene: PackedScene
# 武器的属性
@export var stats: WeaponStats
# 武器的升级，后续武器的引用
@export var upgrede_to: ItemWeapon
