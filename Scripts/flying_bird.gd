extends AnimatedSprite2D

var timer : Timer
@onready var anim_player : AnimationPlayer = $"../AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.timeout.connect(show_bird)
	add_child(timer)
	start_timer()

func start_timer():
	var rand = RandomNumberGenerator.new()
	var time = rand.randf_range(10, 30)
	timer.start(time)

func show_bird():
	anim_player.play("bird_fly_across")
	start_timer()
