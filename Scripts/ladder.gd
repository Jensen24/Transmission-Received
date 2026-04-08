extends Area3D

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		body.ladder_array.append(self)
		body.current_state = body.State.LADDER
	
func _on_body_exited(body):
	if body.name == "Player":
		body.ladder_array.erase(self)
		if body.ladder_array.size() == 0:
			body.current_state = body.State.NORMAL
