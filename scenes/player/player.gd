extends CharacterBody3D

const SPEED: float = 5.0
const RUN_SPEED_BONUS: float = SPEED * 0.35
const JUMP_VELOCITY: float = 4.5
const MOUSE_SENSITIVITY: float = 0.003

var initial_weapon: PackedScene = load("res://scenes/weapons/sword.tscn")
var current_weapon_index : int
var bow: PackedScene = load("res://scenes/weapons/bow_A.tscn")
var sword: PackedScene = load("res://scenes/weapons/sword.tscn")
var all_weapons: Array[Weapon] = []

@onready var head: Node3D = $Head
@onready var hand : Node3D = %Hand


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	equip_weapon(sword)
	equip_weapon(bow)	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, -PI / 2, PI / 2)

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event.is_action_pressed("attack"):
		_get_current_weapon().attack()
		
	if event.is_action_pressed("weapon_slot_1"):
		change_weapon(0)
		
	if event.is_action_pressed("weapon_slot_2"):
		change_weapon(1)



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "foward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = direction.x * SPEED * RUN_SPEED_BONUS
			velocity.z = direction.z * SPEED * RUN_SPEED_BONUS
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func equip_weapon(weapon: PackedScene) -> void:
	var weapon_instance: Weapon = weapon.instantiate() as Weapon
	hand.add_child(weapon_instance)

	if (_get_current_weapon() != null):
		weapon_instance.hide()

	all_weapons.append(weapon_instance)
		
	if (_get_current_weapon() == null):
		current_weapon_index = all_weapons.find(weapon_instance)
	
	
func change_weapon(new_weapon_index: int) -> void:
	_get_weapon_by_index(current_weapon_index).hide()
	current_weapon_index = new_weapon_index
	_get_weapon_by_index(new_weapon_index).show()

func _get_current_weapon() -> Weapon:
	return _get_weapon_by_index(current_weapon_index)

func _get_weapon_by_index(index: int) -> Weapon:
	return all_weapons.get(index)