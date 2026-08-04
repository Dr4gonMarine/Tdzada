extends Weapon
class_name MeleeWeapon

#region Variable

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var HitBox : Area3D = %HitBox
#endregion

func attack() -> void:
	if current_state == Weapon.State.IDLE:
		HitBox.monitoring = true
		animation_player.play("attack_1")
		current_state = Weapon.State.ATTACKING

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if current_state == Weapon.State.ATTACKING:
		animation_player.play("attack_1", -1, -2.0, true)
	
	HitBox.monitoring = false
	current_state = Weapon.State.IDLE
