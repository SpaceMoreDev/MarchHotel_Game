extends TextureRect
class_name CharacterSlot

var active : bool = false
var locked : bool = false

@onready var CharacterSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var initialscale : Vector2 = CharacterSprite.scale

@export var characteData : Character_Data
@export var scale_effect_factor : float = .1

func _ready() -> void:
	
	if CharacterSprite.material:
		var selectMaterial : ShaderMaterial = CharacterSprite.material
		CharacterSprite.material = selectMaterial.duplicate()
	
	if not characteData || not characteData.frames:
		return
	
	CharacterSprite.sprite_frames = characteData.frames
	CharacterSprite.animation = "Run"

func _on_mouse_entered() -> void:
	if not locked:
		get_tree().create_tween().tween_property(CharacterSprite,"scale",initialscale + (Vector2.ONE * scale_effect_factor),.1)
		CharacterSprite.play()
	pass 


func _on_mouse_exited() -> void:
	if not locked:
		get_tree().create_tween().tween_property(CharacterSprite,"scale",initialscale,.1)
		CharacterSprite.stop()
	pass

func set_active(slot : CharacterSlot):
	var state = false; 
	locked = true
	if slot == self:
		state = true
	
	if state: # active
		var selectMaterial : ShaderMaterial = CharacterSprite.material
		var tween = get_tree().create_tween()
		tween.tween_property(selectMaterial, "shader_parameter/white_progress", 0, 0.1)
	else:
		var selectMaterial : ShaderMaterial = CharacterSprite.material
		var tween = get_tree().create_tween()
		tween.tween_property(selectMaterial, "shader_parameter/white_progress", 1, 0.1)
	active = state
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if not active and not locked:
				Global.chosen_character_data = characteData
				Global.OnCharacterSelection.emit(self as CharacterSlot)
				
				await get_tree().create_timer(1).timeout

				Global.coins = 0
				get_tree().change_scene_to_file("res://main.tscn")
		
	pass 
