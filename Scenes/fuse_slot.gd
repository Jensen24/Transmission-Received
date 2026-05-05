extends Node3D

@export var startingFuseScene : PackedScene

var currentFuse = null

func _ready():
	if startingFuseScene:
		var fuse = startingFuseScene.instantiate()
		add_child(fuse)
		fuse.global_transform = $Marker3D.global_transform
		currentFuse = fuse

func on_inspect_confirmed(Player):
	if currentFuse != null and Player.heldFuse == null:
		currentFuse.get_parent().remove_child(currentFuse)
		Player.heldFuse = currentFuse
		Player.equip_fuse()
		currentFuse = null

func interact(Player):
	if currentFuse == null and Player.heldFuse != null:
		currentFuse = Player.heldFuse
		Player.heldFuse = null
		Player.de_equip_fuse()
		add_child(currentFuse)
		currentFuse.visible = true
		currentFuse.global_transform = $Marker3D.global_transform
