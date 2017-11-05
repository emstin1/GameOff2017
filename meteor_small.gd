extends KinematicBody2D

var ROT = rand_range(1, 6)

var movement = rand_range(50, 200)
var velocity = Vector2(-movement, 0)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	#spinning meteor
	set_rot(get_rot() + delta * ROT)
	
	if (is_colliding()):
		var collision = get_collider()
		if collision:
			if collision.get_name() == "player":
				get_parent().get_node("player").health -= 1
		queue_free()
	move(velocity * delta)