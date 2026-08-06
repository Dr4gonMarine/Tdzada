@abstract
extends Node3D
class_name Weapon

enum State {IDLE, ATTACKING, CHARGING}

var current_state : State = State.IDLE

@export var weapon_name: String 

@abstract func attack() -> void

func release_attack() -> void:
	pass

func cancel() -> void:
	current_state = State.IDLE
