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
        # Here you would add the logic for using the item
        print("Using item: " + item.name)

        if item.item_type == Item.ItemType.CONSUMABLE or item.item_type == Item.ItemType.SEED:
            remove_item(slot)
