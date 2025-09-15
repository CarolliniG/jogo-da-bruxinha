# scripts/Inventory.gd
extends Node
class_name Inventory

signal inventory_changed

# Array de dicionários: [{ "item": Item, "quantity": int }, ...]
var slots = []
const INVENTORY_SIZE = 10

func _ready():
    # Initialize the inventory with empty slots
    slots.resize(INVENTORY_SIZE)
    slots.fill(null)

func add_item(item_to_add: Item) -> bool:
    # Primeiro, tenta empilhar com itens existentes
    if item_to_add.stackable:
        for i in range(slots.size()):
            if slots[i] != null and slots[i].item == item_to_add:
                if slots[i].quantity < item_to_add.max_stack_size:
                    slots[i].quantity += 1
                    inventory_changed.emit()
                    return true

    # Se não for empilhável ou não houver pilhas existentes, encontra um slot vazio
    for i in range(slots.size()):
        if slots[i] == null:
            slots[i] = { "item": item_to_add, "quantity": 1 }
            inventory_changed.emit()
            return true

    # Inventário está cheio
    print("Inventory is full!")
    return false

func remove_item(slot_index: int):
    if slot_index >= 0 and slot_index < slots.size() and slots[slot_index] != null:
        slots[slot_index].quantity -= 1
        if slots[slot_index].quantity <= 0:
            slots[slot_index] = null
        inventory_changed.emit()

func use_item(slot_index: int):
    if slot_index >= 0 and slot_index < slots.size() and slots[slot_index] != null:
        var item_slot = slots[slot_index]
        var item = item_slot.item
        print("Using item: " + item.name)

        # Mantém a dependência do nó "Stats" do script original, com verificação de segurança
        var player = get_parent()
        var stats_node = player.get_node_or_null("Stats")

        match item.item_type:
            Item.ItemType.FOOD:
                if stats_node and stats_node.has_method("eat"):
                    stats_node.eat(item.health_restored)
                remove_item(slot_index)
            Item.ItemType.POTION:
                # Adicionar lógica de poção aqui
                remove_item(slot_index)
            Item.ItemType.SEED:
                # Adicionar lógica de semente aqui
                remove_item(slot_index)
            Item.ItemType.TOOL:
                # Ferramentas não são consumidas
                pass
            Item.ItemType.OTHER:
                # Adicionar lógica de outros itens aqui
                pass
