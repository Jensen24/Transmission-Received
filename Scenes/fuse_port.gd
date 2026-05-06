extends Node3D

var allSigs = []
var currentSig = 0

@onready var Slots = $Slots.get_children()
@onready var display = $Label3D


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
		return
	display.text = allSigs[currentSig]
	print("Current Signature:", allSigs[currentSig])
	
func on_fuse_checked(fuse):
	print("Checking fuse:", fuse.signature)
	if fuse.signature == allSigs[currentSig]:
		display.text = "Correct"
		print("Correct")
		currentSig += 1
		await get_tree().create_timer(1.0).timeout
		start_round()
	else:
		display.text = "Incorrect"
		print("Incorrect")
	
