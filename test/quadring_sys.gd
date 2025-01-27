@tool
extends MeshInstance3D

@export_range(0, 100, 0.01) var radius = 1.0:
	set(value):
		radius = value
		call_deferred('_generate')

func _generate():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_LINE_STRIP)
	for i in range(64+1):
		var t = (i/float(64)) * TAU
		var point = Vector3(cos(t) * radius, 0, sin(t) * radius)
		surface_tool.add_vertex(point)
	
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
