# scripts/Collectible.gd
extends Area2D

@export var item: Item

func _ready():
    if item and item.texture:
        var sprite = get_node_or_null("Sprite2D")
        if sprite:
            sprite.texture = item.texture

func _on_body_entered(body: Node2D):
    if body.has_method("get_inventory"):
        var inventory = body.get_inventory()
        if inventory.add_item(item):
            queue_free()
