extends Node3D

@export var startingFuseScene : PackedScene
@export var portSlot := false
@export var correctSig := ""

var currentFuse = null

func _ready():
	if startingFuseScene and not is_in_group("Ports"):
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
		if portSlot:
			check_fuse()
			get_parent().get_parent().on_fuse_checked(currentFuse)

func check_fuse():
	if currentFuse == null:
		return
	if currentFuse.signature == correctSig:
		print("Correct")
	else:
		print("Incorrect")
