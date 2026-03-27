extends Character
class_name Goblin

var SPEED = 8000.0
var JUMP_VELOCITY = 670.0
var random_speed_variation

@export var goblin_combat : EnemyCombat
@export var fire_interval : float = 1.5

var groundY : int
var player : Player
var Sprite : AnimatedSprite2D

var can_move : bool = true
var is_shooting : bool = false


func _ready() -> void:
	active = false
	player = Global.get_player()
	Sprite = $AnimatedSprite2D


# ========================
# DAMAGE / DEATH
# ========================

func take_damage(attacker):
	if dead or not active:
		return
	
	super(attacker)
	active = false
	Sprite.play("Hit")
	await Sprite.animation_finished
	call_deferred("death")


func death():
	super()
	global_position = Vector2(700, -700)
	active = false
	visible = false
	can_move = false
	dead = true
	call_deferred("set_collision", false)


func set_collision(onoff : bool):
	$CollisionShape2D.disabled = !onoff


# ========================
# COMBAT
# ========================

func attack():
	if dead or not active:
		return
	
	can_move = false
	Sprite.play("Attack")
	await Sprite.animation_finished
	if active:
		player.take_damage(self,100)
	can_move = true


func shoot(fire_dir):
	if dead or not active:
		return
	
	is_shooting = true
	#active = false
	Sprite.play("Cast")
	await get_tree().create_timer(fire_interval).timeout
	is_shooting = false
	#active = true
	goblin_combat.fire(fire_dir)


# ========================
# MOVEMENT HELPERS
# ========================

func go_down():
	if dead or not active:
		return
	
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false


func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		groundY = int(global_position.y)


func handle_vertical_movement():
	if not is_on_floor():
		return
	
	if player.global_position.y < groundY - 100:
		velocity.y = -JUMP_VELOCITY
	
	elif player.global_position.y > groundY + 100:
		go_down()


func handle_horizontal_movement(direction: Vector2, delta: float):
	var distance = direction.length()

	if distance > 500:
		handle_far_behavior(direction)
	elif distance > 70:
		velocity.x = direction.normalized().x * SPEED * delta
	else:
		handle_close_behavior()


func handle_far_behavior(direction: Vector2):
	if dead or not active:
		return
	
	velocity.x = move_toward(velocity.x, 0, SPEED)

	var fire_dir = get_fire_direction(direction)

	if not is_shooting and is_on_floor():
		shoot(fire_dir)


func handle_close_behavior():
	if dead or not active or is_shooting:
		return
	
	velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor() and is_zero_approx(velocity.length()) and can_move:
		attack()


func get_fire_direction(direction: Vector2) -> float:
	if sign(direction.x) == 1:
		Sprite.flip_h = false
		return Vector2.RIGHT.angle()
	else:
		Sprite.flip_h = true
		return Vector2.LEFT.angle()


func handle_sprite_flip(direction: Vector2):
	Sprite.flip_h = sign(direction.x) != 1


# ========================
# ANIMATION
# ========================

func update_animation():
	if is_shooting:
		return
	
	if not is_on_floor():
		Sprite.play("Jump")
		return
	
	if not can_move:
		return
	
	if abs(velocity.x) > 0:
		Sprite.play("Run")
	else:
		Sprite.play("Idle")


# ========================
# PROCESS
# ========================

func _process(delta: float) -> void:
	if global_position.y > 850:
		death()


func _physics_process(delta: float) -> void:
	if dead or not active or not can_move:
		return
	
	apply_gravity(delta)
	handle_vertical_movement()
	
	var direction := player.global_position - global_position
	
	handle_sprite_flip(direction)
	handle_horizontal_movement(direction, delta)
	update_animation()
	
	move_and_slide()
