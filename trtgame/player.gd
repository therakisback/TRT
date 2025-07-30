extends CharacterBody3D


var target_velocity = Vector3.ZERO





		

func _physics_process(delta: float) -> void:
	var direction = Vector3()
	if Input.is_action_pressed("Forward"):
		direction.z -= 1
	if Input.is_action_pressed("Backwards"):
		direction.z += 1
	if Input.is_action_pressed("Left"):
		direction.x -= 1
	if Input.is_action_pressed("Right"):
		direction.x += 1
	if !Input.is_action_pressed("Sprint"):
		sprint_mult = 1
	
	if direction != Vector3():
		direction = direction.normalized()
	
	target_velocity.x = direction.x * move_speed * sprint_mult
	target_velocity.z = direction.z * move_speed * sprint_mult
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
	
	velocity = target_velocity
	move_and_slide()
