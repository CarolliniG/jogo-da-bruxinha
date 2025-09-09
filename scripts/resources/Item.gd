# scripts/resources/Item.gd
extends Resource
class_name Item

enum ItemType { TOOL, CONSUMABLE, SEED }

@export var name: String = ""
@export var texture: Texture2D
@export var stackable: bool = false
@export var item_type: ItemType = ItemType.CONSUMABLE
