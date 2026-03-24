extends Node2D
class_name Pool

var object_pool : Array[Variant] = []
var POOL_SIZE := 100

func init_pool( _packed_scene : PackedScene, _pool_size = POOL_SIZE) -> Array[Variant]:
	POOL_SIZE = _pool_size
	
	var pool_scene := _packed_scene
	var pool_array  : Array[Variant] = []
	for i in POOL_SIZE:
		var instance := pool_scene.instantiate()
		instance.visible = false
		#instance.set_physics_process(false)
		add_child(instance)
		pool_array.append(instance)
	object_pool = pool_array
	return pool_array


func spawn_from_pool(NodePosition : Node2D):
	spawn(0.0, NodePosition)


func get_pool_instance() -> Variant:
	for obj in object_pool:
		if !obj.visible:
			return obj
	return null
	
func spawn(direction:float , target : Node2D) -> void:
	var spawned_obj = get_pool_instance() as Node2D

	if spawned_obj == null:
		return
	
	spawned_obj.global_position = target.global_position
	spawned_obj.visible = true
	#spawned_obj.set_physics_process(true)
	

	

	
