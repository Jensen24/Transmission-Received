extends Node3D

@export var startingFuseScene : PackedScene

var currentFuse = null

func _ready():
	if startingFuseScene:
		var fuse = startingFuseScene.instantiate()
		get_tree().current_scene.add_child(fuse)
		fuse.global_transform = $Marker3D.global_transform
		currentFuse = fuse

func on_inspect_confirmed(Player):
	if currentFuse != null and Player.heldFuse == null:
		Player.heldFuse = currentFuse
		currentFuse.visible = true
		currentFuse = null

func interact(Player):
	if currentFuse == null and Player.heldFuse != null:
		currentFuse = Player.heldFuse
		Player.heldFuse = null
		currentFuse.global_transform = $Marker3D.global_transform
