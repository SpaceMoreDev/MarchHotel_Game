extends Character
class_name Player

@onready var Sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coin_text : Label = $UI/Control/HBoxContainer/Label
@onready var coin_icon : Control = $UI/Control/HBoxContainer
@onready var player_combat : PlayerCombat = $Combat
@onready var camera : Camera2D = $Camera2D

const SPEED = 330.0
const JUMP_VELOCITY = -670.0

var character_data : Character_Data

func take_damage():
	super()
	Global.OnLoseHeatlh.emit(1)

func _ready() -> void:
	Global.checkpoint_location = position
	if Global.chosen_character_data:
		set_character(Global.chosen_character_data)

func set_character(data : Character_Data) -> void:
	if data:
		character_data = data
		Sprite.sprite_frames = data.frames

func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		if sign(direction) == 1: 
			Sprite.flip_h = false
		else:
			Sprite.flip_h = true
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	if is_on_floor():
		if velocity.length() > 0:
			Sprite.play("Run")
		else:
			Sprite.play("Idle")
	else:
		if Sprite.is_playing():
			Sprite.play("Jump")
	
	move_and_slide()
	
	if global_position.y > 850:
		Global.Death()
