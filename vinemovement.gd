extends Area2D



func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "Player":
			body.vine_on = true


func _on_Area2D_body_exited(body):
	if body.get("TYPE") == "Player":
			body.vine_on = false
