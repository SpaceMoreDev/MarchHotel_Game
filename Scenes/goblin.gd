extends Character
class_name Goblin

const SPEED = 100.0
const JUMP_VELOCITY = 670.0

@export var goblin_combat : EnemyCombat
@export var fire_interval : float = 0.5
var groundY : int
var player : Player
var Sprite : AnimatedSprite2D

signal OnCombat()

func _ready() -> void:
	player = Global.get_player()
	Sprite = $AnimatedSprite2D
	
	OnCombat.connect(attack)

func take_damage():
	super()
	call_deferred("queue_free")

func go_down():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(.1).timeout
	$CollisionShape2D.disabled = false

var in_combat = false
var is_shooting = false

func attack():
	in_combat = true
	Sprite.play("Attack")
	await Sprite.animation_finished
	Global.OnLoseHeatlh.emit(1)
	in_combat = false

func shoot(fire_dir):
	is_shooting = true
	await get_tree().create_timer(fire_interval).timeout
	is_shooting = false
	goblin_combat.fire(fire_dir)

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		groundY = int(position.y)
	
	if is_on_floor():
		if player.position.y < groundY - 100:
			velocity.y = -JUMP_VELOCITY
			
		if player.position.y > groundY + 100:
			go_down()
			#print("down")
		
	
	var direction := player.position - position
	
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
		velocity.x = direction.normalized().x * SPEED
		
		if sign(direction.x) == 1: 
			Sprite.flip_h = false
		else:
			Sprite.flip_h = true
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			if is_zero_approx(velocity.length()) && not in_combat:
				attack()
	
	
	if is_on_floor():
		if not in_combat:
			if abs(velocity.x) > 0:
				Sprite.play("Run")
			else:
				Sprite.play("Idle")
	else:
		if Sprite.is_playing():
			Sprite.play("Jump")
			in_combat = false
		
	#print(str(velocity))
	move_and_slide()
