# scripts/Inventory.gd
extends Node
class_name Inventory

signal inventory_changed

var items = []

func _ready():
    # Initialize the inventory with 10 empty slots
    items.resize(10)
    items.fill(null)

func add_item(item: Item) -> bool:
    # Find an empty slot
    for i in range(items.size()):
        if items[i] == null:
            items[i] = item
            inventory_changed.emit()
            return true

    # Inventory is full
    print("Inventory is full!")
    return false

func remove_item(slot: int):
    if slot >= 0 and slot < items.size() and items[slot] != null:
        items[slot] = null
        inventory_changed.emit()

func use_item(slot: int):
    if slot >= 0 and slot < items.size() and items[slot] != null:
        var item = items[slot]
        print("Using item: " + item.name)

        match item.item_type:
            Item.ItemType.FOOD:
                get_parent().get_node("Stats").eat(item.health_restored)
                remove_item(slot)
            Item.ItemType.POTION:
                # Logic for using potion
                remove_item(slot)
            Item.ItemType.SEED:
                # Logic for using seed
                remove_item(slot)
            Item.ItemType.TOOL:
                # Logic for using tool
                pass
            Item.ItemType.OTHER:
                # Logic for using other
                pass
