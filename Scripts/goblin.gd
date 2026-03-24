extends Character
class_name Goblin

var SPEED = 100.0
var JUMP_VELOCITY = 670.0
var random_speed_variation

@export var goblin_combat : EnemyCombat
@export var fire_interval : float = 0.5
var groundY : int
var player : Player
var Sprite : AnimatedSprite2D

var coin_spawner : Pool


func _ready() -> void:
	player = Global.get_player()
	Sprite = $AnimatedSprite2D

func take_damage(attacker):
	death()
	dead = true
	super(attacker)
	Sprite.play("Hit")
	await Sprite.animation_finished 
	visible = false
	is_shooting = false
	in_combat = false
	global_position = Vector2(-200,-600)
	set_collision(false)
	#set_physics_process(false)
	

func set_collision(onoff : bool):
	$CollisionShape2D.disabled = !onoff

func go_down():
	if dead:
		return
	
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(.1).timeout
	$CollisionShape2D.disabled = false

var in_combat = false
var is_shooting = false

func attack():
	if dead:
		return
	
	in_combat = true
	Sprite.play("Attack")
	await Sprite.animation_finished
	player.take_damage(self)
	in_combat = false

func shoot(fire_dir):
	if dead:
		return
	
	is_shooting = true
	Sprite.play("Cast")
	await get_tree().create_timer(fire_interval).timeout
	is_shooting = false
	goblin_combat.fire(fire_dir)

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		groundY = int(global_position.y)
	
	if is_on_floor():
		if player.global_position.y < groundY - 100:
			velocity.y = -JUMP_VELOCITY
			
		if player.global_position.y > groundY + 100:
			go_down()
		
	
	var direction := player.global_position - global_position
	
	if sign(direction.x) == 1: 
			Sprite.flip_h = false
	else:
			Sprite.flip_h = true
	
	
	if direction.length() > 500: # too far away
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		var fire_dir = Vector2.LEFT.angle()
		if sign(direction.x) == 1: 
			fire_dir = Vector2.RIGHT.angle()
		else:
			Sprite.flip_h = Vector2.LEFT.angle()
		
		if not is_shooting:
			shoot(fire_dir)
	
	
	elif direction.length() > 70:
		velocity.x = direction.normalized().x * SPEED * delta * 80
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED )
		if is_on_floor():
			if is_zero_approx(velocity.length()) && not in_combat:
				attack()
	
	
	if not is_on_floor():
		if Sprite.is_playing():
			Sprite.play("Jump")
			in_combat = false
		
	else:
		if not in_combat and not is_shooting:
			if abs(velocity.x) > 0:
				Sprite.play("Run")
			else:
				Sprite.play("Idle")
			
		
	#print(str(velocity))
	move_and_slide()
