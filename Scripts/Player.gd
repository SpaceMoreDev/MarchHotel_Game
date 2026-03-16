extends CharacterBody2D
class_name Player

@onready var Sprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var coin_text : Label = $CanvasLayer/Control/HBoxContainer/Label
@onready var coin_icon : Control = $CanvasLayer/Control/HBoxContainer

const SPEED = 300.0
const JUMP_VELOCITY = -770.0

func _ready() -> void:
	if Global.chosen_character_data:
		Sprite.sprite_frames = Global.chosen_character_data.frames

func _physics_process(delta: float) -> void:
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
		Sprite.play("Jump")
	
	move_and_slide()
	
	if global_position.y > 850:
		Global.Death()
