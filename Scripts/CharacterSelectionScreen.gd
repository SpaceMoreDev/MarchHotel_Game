extends Control

func _ready() -> void:
	Global.OnCharacterSelection.connect(set_character_display_name)
	var slots = get_tree().get_nodes_in_group("CharacterSelectionSlot")
	print(slots.size())
	for i in slots:
		if i is CharacterSlot:
			Global.OnCharacterSelection.connect((i as CharacterSlot).set_active)

func set_character_display_name(node : CharacterSlot) -> void:
	$Label.text = node.characteData.name
