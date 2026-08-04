extends RangedWeapon
class_name BowWeapon

@export var draw_time: float = 0.7      # seconds until maximum power
@export var min_power: float = 0.35     
@export var release_time: float = 0.08 

@onready var bow_mesh: MeshInstance3D = find_children("", "MeshInstance3D", true, false)[0]
@onready var draw_shape: int = bow_mesh.find_blend_shape_by_name("Draw")
@onready var arrow_visual: Node3D = %ArrowVisual
@onready var tension_limit : Node3D = $Pivot/TensionLimit

var _nock_rest: Vector3
var _arrow_rest: Vector3
var _travel: Vector3
var _draw: float = 0.0
var _tween: Tween

func _ready() -> void:
	arrow_visual.hide()
	assert(draw_shape >= 0, "Blend shape 'Draw' not found in %s" % bow_mesh.name)
	_nock_rest = projectile_spawner.position
	_arrow_rest = arrow_visual.position
	_travel = tension_limit.position - _nock_rest
	_apply_draw(0.0)

func _process(delta: float) -> void:
	if current_state == Weapon.State.CHARGING:
		_apply_draw(minf(_draw + delta / draw_time, 1.0))

func attack() -> void:
	if current_state == Weapon.State.IDLE:
		arrow_visual.show()
		current_state = Weapon.State.CHARGING

func release_attack() -> void:
	if current_state != Weapon.State.CHARGING:
		return
	current_state = Weapon.State.ATTACKING
	arrow_visual.hide()  
	shoot(lerpf(min_power, 1.0, _draw))
	_snap_back()

func cancel() -> void:
	super()
	_snap_back()

func _apply_draw(t: float) -> void:
	_draw = t
	bow_mesh.set_blend_shape_value(draw_shape, t)
	projectile_spawner.position = _nock_rest + _travel * t
	arrow_visual.position = _arrow_rest + _travel * t

func _snap_back() -> void:
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_method(_apply_draw, _draw, 0.0, release_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
