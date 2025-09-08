# scripts/resources/Item.gd
extends Resource
class_name Item

@export var name: String = ""
@export var texture: Texture2D
@export var stackable: bool = false
@export var consumable: bool = false
