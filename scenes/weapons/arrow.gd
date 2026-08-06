extends RigidBody3D
class_name Arrow

@export var base_speed: float
@export var embedded_distance: float = 0
@onready var ray_cast: RayCast3D = $RayCast3D
var _stuck: bool = false

func _physics_process(delta: float) -> void:
	if !_stuck:
		if ray_cast.is_colliding():
			_stuck = true
			freeze = true
			global_position = ray_cast.get_collision_point() - (-global_basis.z) * (-embedded_distance)

func launch(power: float) -> void:
	linear_velocity = -global_transform.basis.z * (base_speed * power)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if _stuck:
		return
	var v := state.linear_velocity
	if v.length_squared() < 0.01:
		return
	var up := Vector3.UP if absf(v.normalized().dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	state.transform.basis = Basis.looking_at(v, up)

func _on_timer_timeout() -> void:
	queue_free()
