# scripts/Collectible.gd
extends Area2D

@export var item: Item

func _ready():
    if not item:
        # Create a default item if none is assigned.
        # This is a workaround for not being able to create .tres files easily.
        var new_item = Item.new()
        new_item.name = "Tomato"
        new_item.consumable = true
        new_item.stackable = true
        # We still have the texture problem.
        # I'll load the spritesheet and maybe I can create an AtlasTexture in code.
        var full_texture = load("res://assets/itens/Crop_Spritesheet.png")
        var atlas_texture = AtlasTexture.new()
        atlas_texture.atlas = full_texture
        atlas_texture.region = Rect2(0, 32, 16, 16) # The grown tomato sprite
        new_item.texture = atlas_texture
        item = new_item

func _on_body_entered(body: Node2D):
    if body.has_method("get_inventory"):
        var inventory = body.get_inventory()
        if inventory.add_item(item):
            queue_free()
