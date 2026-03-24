extends Character
class_name Player

@onready var Sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coin_text : Label = $UI/Control/HBoxContainer/Label
@onready var coin_icon : Control = $UI/Control/HBoxContainer
@onready var player_combat : PlayerCombat = $Combat
@onready var camera : Camera2D = $Camera2D

@export var can_die : bool = true

const SPEED = 330.0
const JUMP_VELOCITY = -670.0

var character_data : Character_Data
var is_taking_damage = false

func go_down():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(.1).timeout
	$CollisionShape2D.disabled = false

func take_damage(attacker : Character):
	if not can_die:
		return
	
	super(attacker)
	
	var attack_dir = (attacker.position - position).normalized()
	
	if sign(attack_dir.x) == 1: 
			Sprite.flip_h = false
	else:
			Sprite.flip_h = true
	
	Sprite.play("Hit")
	
	is_taking_damage = true
	
	velocity.x = -attack_dir.x * 500
	move_and_slide()
	
	await Sprite.animation_finished
	#await get_tree().create_timer(.5).timeout
	
	is_taking_damage = false
	
	
	
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
	if is_taking_damage:
		return
	# Handle jump.
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		go_down()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
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
