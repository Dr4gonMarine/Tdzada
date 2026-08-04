extends Weapon
class_name RangedWeapon

#region Variable
@export var ammo : PackedScene

@onready var projectile_spawner: Marker3D = %ProjectileSpawner
@onready var animation_player : AnimationPlayer = %AnimationPlayer
#endregion


func attack() -> void:
	if current_state == Weapon.State.IDLE:
		shoot()
		current_state = Weapon.State.ATTACKING

func shoot(power: float = 1.0) -> void:
	animation_player.play("shoot")
	var projectile := ammo.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = projectile_spawner.global_position
	projectile.global_transform.basis = projectile_spawner.global_transform.basis
	if projectile.has_method("launch"):
		projectile.launch(power)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	current_state = Weapon.State.IDLE
