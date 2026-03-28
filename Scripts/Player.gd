extends Character
class_name Player

@onready var Sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coin_text : Label = $UI/Control/HBoxContainer/Label
@onready var coin_icon : Control = $UI/Control/HBoxContainer
@onready var player_combat : PlayerCombat = $Combat
@onready var camera : Camera2D = $Camera2D

@export var can_die : bool = true
@export var self_active : bool = true

const SPEED = 330.0
const JUMP_VELOCITY = -670.0

var is_knockback = false
@export var character_data : Character_Data
var is_taking_damage = false
var is_attacking = false

func go_down():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(.1).timeout
	$CollisionShape2D.disabled = false

func take_damage(attacker : Character, force : float = 500):
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
	
	velocity.x = -attack_dir.x * force
	move_and_slide()
	
	await Sprite.animation_finished
	#await get_tree().create_timer(.5).timeout
	
	is_taking_damage = false
	
	
	
	Global.OnLoseHeatlh.emit(1)

func _ready() -> void:
	
	coin_text.text = str(Global.coins)
	
	if not self_active:
		camera.enabled =false
	Global.checkpoint_location = position
	if Global.chosen_character_data:
		set_character(Global.chosen_character_data)
	elif character_data:
		set_character(character_data)
		Global.chosen_character_data = character_data
func set_character(data : Character_Data) -> void:
	if data:
		character_data = data
		Sprite.sprite_frames = data.frames


func apply_force(dir: Vector2, force: float):
	velocity = dir.normalized() * force
	is_knockback = true
	
	await get_tree().create_timer(0.2).timeout
	is_knockback = false


func _process(delta: float) -> void:
	if not self_active:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_taking_damage or is_knockback:
		move_and_slide()
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
		is_attacking = false
		if sign(direction) == 1: 
			Sprite.flip_h = false
		else:
			Sprite.flip_h = true
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not is_attacking:
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
