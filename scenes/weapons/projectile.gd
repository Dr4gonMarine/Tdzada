extends Node3D

const BASE_SPEED: float = 15.0

var speed: float = BASE_SPEED

@onready var raycast : RayCast3D = $RayCast3D

func _process(delta: float) -> void:
	if !raycast.is_colliding():
		position += transform.basis * Vector3(0, 0, -speed) * delta

func launch(power: float) -> void:
	speed = BASE_SPEED * power

func _on_timer_timeout() -> void:
	queue_free()
