@tool
extends EditorNode3DGizmoPlugin

func _get_gizmo_name():
	return "BetterCollision3DGizmo"

func _create_gizmo(node):
	if node is CollisionShape3D:
		return preload("col3d_gizmo.gd").new()
	else:
		return null
