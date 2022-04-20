extends Sprite

export(NodePath) var viewport_path:NodePath

func _ready() -> void:
	var viewport:Viewport = get_node(viewport_path)
	texture = viewport.get_texture()
