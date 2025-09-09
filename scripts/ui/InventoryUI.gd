# scripts/ui/InventoryUI.gd
extends CanvasLayer

signal item_selected(item: Item)

@onready var grid_container = $MarginContainer/Panel/GridContainer
var inventory: Inventory

var selected_slot = -1
var selected_stylebox: StyleBoxFlat
var default_stylebox: StyleBoxFlat


func _ready():
    # Create styleboxes for selection feedback
    default_stylebox = StyleBoxFlat.new()
    default_stylebox.bg_color = Color(0.2, 0.2, 0.2, 0.5)
    default_stylebox.border_width_left = 1
    default_stylebox.border_width_top = 1
    default_stylebox.border_width_right = 1
    default_stylebox.border_width_bottom = 1
    default_stylebox.border_color = Color(0.5, 0.5, 0.5, 1)

    selected_stylebox = StyleBoxFlat.new()
    selected_stylebox.bg_color = Color(0.4, 0.4, 0.2, 0.5)
    selected_stylebox.border_width_left = 2
    selected_stylebox.border_width_top = 2
    selected_stylebox.border_width_right = 2
    selected_stylebox.border_width_bottom = 2
    selected_stylebox.border_color = Color(1, 1, 0, 1)

    # Create the visual slots
    for i in range(10):
        var slot = Panel.new()
        slot.custom_minimum_size = Vector2(32, 32)
        slot.set("theme_override_styles/panel", default_stylebox)
        slot.gui_input.connect(_on_slot_gui_input.bind(i))
        grid_container.add_child(slot)

    hide() # Start hidden

func set_inventory(inv: Inventory):
    inventory = inv
    inventory.inventory_changed.connect(_on_inventory_changed)
    _update_display()

func _on_inventory_changed():
    # If the selected item was removed, deselect it
    if selected_slot != -1 and inventory.items[selected_slot] == null:
        selected_slot = -1
        item_selected.emit(null)
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

    _update_selection_visuals()

func _on_slot_gui_input(event: InputEvent, slot_index: int):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
        # If clicking the already selected slot, deselect it
        if selected_slot == slot_index:
            selected_slot = -1
            item_selected.emit(null)
        else:
            selected_slot = slot_index
            item_selected.emit(inventory.items[selected_slot])

        _update_selection_visuals()

func _update_selection_visuals():
    for i in range(grid_container.get_child_count()):
        var slot_visual = grid_container.get_child(i)
        if i == selected_slot:
            slot_visual.set("theme_override_styles/panel", selected_stylebox)
        else:
            slot_visual.set("theme_override_styles/panel", default_stylebox)


func toggle():
    visible = not visible
    # When closing the inventory, also deselect the item
    if not visible:
        if selected_slot != -1:
            selected_slot = -1
            item_selected.emit(null)
            _update_selection_visuals()


func _unhandled_input(event):
    # Player script will handle the input
    pass
