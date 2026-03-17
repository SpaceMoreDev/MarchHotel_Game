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
		Global.OnCharacterHover.emit(self)
		get_tree().create_tween().tween_property(CharacterSprite,"scale",initialscale + (Vector2.ONE * scale_effect_factor),.1)
		CharacterSprite.play()
	pass 


func _on_mouse_exited() -> void:
	if not locked:
		get_tree().create_tween().tween_property(CharacterSprite,"scale",initialscale,.1)
		CharacterSprite.stop()
	pass

func reset():
	active = false
	locked = false
	
	CharacterSprite.scale = initialscale
	CharacterSprite.stop()
	self_modulate = Color.WHITE
	var selectMaterial : ShaderMaterial = CharacterSprite.material
	selectMaterial.set_shader_parameter("white_progress",0)

func set_active(slot : CharacterSlot):
	var state = false; 
	if slot == self:
		state = true
	
	if state: # active
		self_modulate = Color.DARK_RED
		var selectMaterial : ShaderMaterial = CharacterSprite.material
		var tween = get_tree().create_tween()
		tween.tween_property(selectMaterial, "shader_parameter/white_progress", 0.5, 0.1)
	else:
		reset()
		
	active = state
	#locked = true
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if not active and not locked:
				Global.set_player_data(characteData)
				Global.OnCharacterSelection.emit(self as CharacterSlot)
		
	pass 
