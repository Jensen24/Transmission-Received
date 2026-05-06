extends Node3D

var allSigs = []
var currentSig = 0

@onready var Slots = $Slots.get_children()
@onready var display = $Label3D
@onready var red = $Red


func _ready() -> void:
	print(display)
	await get_tree().create_timer(0.2).timeout
	allSigs.clear()
	for slot in Slots:
		print("Slot sig:", slot.correctSig)
		allSigs.append(slot.correctSig)
	start_round()
	
func start_round():
	if currentSig >= allSigs.size():
		display.text = "Completed"
		red.visible = false
		return
	display.text = allSigs[currentSig]
	print("Current Signature:", allSigs[currentSig])
	
func on_fuse_checked(fuse):
	print("Checking fuse:", fuse.signature)
	if fuse.signature == allSigs[currentSig]:
		display.text = "Correct"
		currentSig += 1
		await get_tree().create_timer(2.0).timeout
		start_round()
	else:
		display.text = "Incorrect"
		await get_tree().create_timer(2.0).timeout
		start_round()
	
