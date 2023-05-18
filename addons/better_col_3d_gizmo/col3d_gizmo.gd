extends EditorNode3DGizmo

var betterMesh: Mesh
var colShape: CollisionShape3D
var debugMesh: Mesh

func _redraw():
	clear()

	var node = get_node_3d()
	if node != null and colShape != node and node.shape != null:
		colShape = node as CollisionShape3D
		update_mesh(colShape.shape)
		colShape.shape.changed.connect(update_mesh.bind(colShape.shape))
		
	if betterMesh != null:
		add_mesh(betterMesh, preload("better_debug_colshape_mat.tres"))
		
func update_mesh(shape: Shape3D):
	betterMesh = make_mesh(shape)
		
func make_mesh(shape: Shape3D) -> Mesh:
	var mesh: Mesh
	if shape is CapsuleShape3D:
		mesh = CapsuleMesh.new()
		mesh.height = shape.height
		mesh.radius = shape.radius
		
	return mesh
