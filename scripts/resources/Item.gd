# scripts/resources/Item.gd
extends Resource
class_name Item

enum ItemType { FOOD, POTION, TOOL, SEED, OTHER }
enum ToolType { STAFF, SWORD, HOE, WATERING_CAN, SCYTHE }

@export var name: String = ""
@export var texture: Texture2D
@export var stackable: bool = false
@export var max_stack_size: int = 1
@export var item_type: ItemType = ItemType.FOOD

# Food properties
@export var health_restored: int = 0
@export var energy_restored: int = 0

# Potion properties
@export var effects: Dictionary = {}

# Tool properties
@export var tool_type: ToolType
