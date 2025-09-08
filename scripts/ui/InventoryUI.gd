# scripts/ui/InventoryUI.gd
extends CanvasLayer

@onready var grid_container = $MarginContainer/Panel/GridContainer
var inventory: Inventory

func _ready():
    # Create the visual slots
    for i in range(10):
        var slot = Panel.new()
        slot.custom_minimum_size = Vector2(32, 32)
        grid_container.add_child(slot)

    hide() # Start hidden

func set_inventory(inv: Inventory):
    inventory = inv
    inventory.inventory_changed.connect(_on_inventory_changed)
    _update_display()

func _on_inventory_changed():
    _update_display()

func _update_display():
    for i in range(inventory.items.size()):
        var slot_visual = grid_container.get_child(i)

        # Clear previous texture if any
        if slot_visual.get_child_count() > 0:
            for child in slot_visual.get_children():
                child.queue_free()

        # Draw new texture
        if inventory.items[i] != null:
            var item_texture = TextureRect.new()
            item_texture.texture = inventory.items[i].texture
            item_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
            item_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
            slot_visual.add_child(item_texture)
            item_texture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func toggle():
    visible = not visible


func _unhandled_input(event):
    # Player script will handle the input
    pass
