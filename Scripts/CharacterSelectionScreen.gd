extends Control

class_name CharacterSelect

var slots : Array
var chosen_character_slot : CharacterSlot
var cstween : Tween

func _ready() -> void:
	Global.OnCharacterHover.connect(set_character_name)
	Global.OnCharacterSelection.connect(character_selected)
	
	slots = get_tree().get_nodes_in_group("CharacterSelectionSlot")
	
	for i in slots:
		if i is CharacterSlot:
			Global.OnCharacterSelection.connect((i as CharacterSlot).set_active)
	
	if slots.size() > 0 and slots[0] is CharacterSlot:
		chosen_character_slot = slots[0]

func character_selected(node : CharacterSlot) -> void:
	chosen_character_slot = node

func set_character_name(slot : CharacterSlot):
	$character_name.text = slot.characteData.name
	$creator.text = "by " + slot.characteData.creator

var flipflop = false

func activate():
	for i in slots:
		if i is CharacterSlot:
			(i as CharacterSlot).reset()
	
	if chosen_character_slot:
		chosen_character_slot.self_modulate = Color.DARK_RED
	
	create_tween().tween_property(self, "global_position", Vector2(555,246),.2)

func deactivate():
	create_tween().tween_property(self, "global_position", Vector2(555,925),.2)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("CharacterSelect"):
		#flipflop = !flipflop
		#if flipflop:
			#activate()
		#else:
			#deactivate()


func _on_button_button_down() -> void:
	deactivate()
	Global.get_player().self_active = true
	$TextureRect/Button.focus_mode = 0
