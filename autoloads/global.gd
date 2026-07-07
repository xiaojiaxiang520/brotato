extends Node

# 全局文件中定义一个用户角色
var player: Player

# 定义两个信号，一个是创建浮动文本字体，一个是销毁浮动文本字体
signal on_create_block_text(unit: Node2D)
signal on_create_damage_text(unit: Node2D, hitbox: HitboxComponent)


# 这个是被攻击后，选需要将玩家用上一个材料
const FLASH_MATERIAL = preload("uid://cyscskw1lqqrb")
# 导入这个浮动字体的场景
const FLOATING_TEXT_SCENE = preload("uid://dlxmjwchbpk4s")

# 升级的枚举类型（层级
enum UpgredeTier{
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}


# 生产一个随机参数，然后返回true和false，这个函数的作用是用于判断当前攻击是否被格挡.
# 目前的原理就是传入一个参数，然后生成一个随机数，然后判断生产的随机数是否小于当前的参数
func get_chance_success(chance: float) -> bool:
	var random := randf_range(0, 1.0)
	if random < chance:
		return true
	return false
