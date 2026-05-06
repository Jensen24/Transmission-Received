extends Node

var fuseSigs = []
var usedSigs = []

func generate_signatures():
	var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var signature = ""
	
	signature += letters[randi() % letters.length()]
	signature += str(randi() % 10)
	signature += letters[randi() % letters.length()]
	signature += str(randi() % 10)
	
	return signature
	
func generate_uniques():
	var signature = generate_signatures()
	while signature in usedSigs:
		signature = generate_signatures()
	usedSigs.append(signature)
	return signature
	
func collect_signatures():
	fuseSigs.clear()
	var fuses = get_tree().get_nodes_in_group("Fuse")
	for fuse in fuses:
		fuseSigs.append(fuse.signature)

func assign_ports():
	var pool = fuseSigs.duplicate()
	pool.shuffle()
	var ports = get_tree().get_nodes_in_group("Ports")
	for i in range(ports.size()):
		if i < pool.size():
			ports[i].correctSig = pool[i]
