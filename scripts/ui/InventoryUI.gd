# scripts/ui/InventoryUI.gd
extends CanvasLayer

signal item_selected(item: Item)

@onready var grid_container = $MarginContainer/Panel/GridContainer
var inventory: Inventory

var selected_slot = -1
var selected_stylebox: StyleBoxFlat
var default_stylebox: StyleBoxFlat


func _ready():
    # Cria os estilos para o feedback de seleção
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

    # Cria os slots visuais
    for i in range(10):
        var slot = Panel.new()
        slot.custom_minimum_size = Vector2(32, 32)
        slot.set("theme_override_styles/panel", default_stylebox)
        slot.gui_input.connect(_on_slot_gui_input.bind(i))

        var quantity_label = Label.new()
        quantity_label.name = "QuantityLabel"
        quantity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
        quantity_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
        slot.add_child(quantity_label)

        grid_container.add_child(slot)

    hide() # Começa escondido

func set_inventory(inv: Inventory):
    inventory = inv
    inventory.inventory_changed.connect(_on_inventory_changed)
    _update_display()

func _on_inventory_changed():
    # Se o item selecionado foi removido, deseleciona o slot
    if selected_slot != -1 and inventory.slots[selected_slot] == null:
        selected_slot = -1
        item_selected.emit(null)
    _update_display()

func _update_display():
    if not inventory: return
    for i in range(inventory.slots.size()):
        var slot_visual = grid_container.get_child(i)
        var quantity_label = slot_visual.get_node("QuantityLabel")

        # Limpa a textura anterior, se houver
        var texture_rect = slot_visual.get_node_or_null("ItemTexture")
        if texture_rect:
            texture_rect.queue_free()

        var slot_data = inventory.slots[i]
        if slot_data:
            var item_texture = TextureRect.new()
            item_texture.name = "ItemTexture"
            item_texture.texture = slot_data.item.texture
            item_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
            item_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
            slot_visual.add_child(item_texture)
            item_texture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

            if slot_data.quantity > 1:
                quantity_label.text = str(slot_data.quantity)
            else:
                quantity_label.text = ""
        else:
            quantity_label.text = ""

    _update_selection_visuals()

func _on_slot_gui_input(event: InputEvent, slot_index: int):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
        select_slot(slot_index)

func select_slot(slot_index: int):
    if not inventory or slot_index < 0 or slot_index >= inventory.slots.size():
        return

    if selected_slot == slot_index:
        selected_slot = -1
        item_selected.emit(null)
    else:
        selected_slot = slot_index
        if inventory.slots[slot_index]:
            item_selected.emit(inventory.slots[slot_index].item)
        else:
            item_selected.emit(null)

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
    # Ao fechar o inventário, também deseleciona o item
    if not visible:
        if selected_slot != -1:
            selected_slot = -1
            item_selected.emit(null)
            _update_selection_visuals()


func _unhandled_input(event):
    # O script do jogador vai lidar com o input
    pass
