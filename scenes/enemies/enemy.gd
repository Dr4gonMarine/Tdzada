extends RigidBody3D
class_name Enemy

#region Variable

#endregion

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.owner is Weapon:
		print("take damage")
