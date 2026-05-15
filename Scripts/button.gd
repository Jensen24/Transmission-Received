extends Node3D

@export var requiredPuzzleCount := 2

func interact(Player):
	if PuzzleManager.completedPuzzleCount >= requiredPuzzleCount:
		var finale = get_tree().get_first_node_in_group("Finale")
		if finale:
			finale.begin_finale()
	else:
		print("Error! Not enough Puzzles completed!")
