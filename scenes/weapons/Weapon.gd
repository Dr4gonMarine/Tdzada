extends Node3D
class_name Weapon

enum State {IDLE, ATTACKING}

@onready var animation_player : AnimationPlayer = %AnimationPlayer

var current_state : State = State.IDLE

func attack() -> void:
	if current_state == Weapon.State.IDLE:
		animation_player.play("sword_attack_1")
		current_state = Weapon.State.ATTACKING


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if current_state == Weapon.State.ATTACKING:
		animation_player.play("sword_attack_1", -1, -2.0, true)
	
	current_state = Weapon.State.IDLE
