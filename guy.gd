extends Node2D

#variables
var velocity  = Vector2()
var current_spd = 0
var facing = "right"
var can_jump = false
var health = 3

onready var standing_collision = get_node("StandingCollisionPoly")
onready var crouching_collision = get_node("CrouchingCollisionPoly")
onready var sprite = get_node("Spr")
onready var collision_shape_id = standing_collision.get_collision_object_shape_index()
onready var standing_collision_transform = get_shape_transform(collision_shape_id)
var col_xform = Vector2(1,-0.5)

#constants
const MAX_VEL = 500
const MV_LAG  = 100
#finely tuned.  pls no touch
const GRAVITY = 2000
const JMP     = 500

func gravity(_delta):
	velocity.y += _delta * GRAVITY 

func _fixed_process(delta):
	gravity(delta)
	# the movement code below gives us a bit of a lag effect
	# when chaning directions or starting from a dead stop.
	if (Input.is_action_pressed("player_left")):
		if facing == "right":
			sprite.set_flip_h(true)
		facing = "left"
		if not current_spd == -MAX_VEL:
			current_spd -= MV_LAG
		velocity.x = current_spd
	elif (Input.is_action_pressed("player_right")):
		if facing == "left":
			sprite.set_flip_h(false)
		facing = "right"
		if not current_spd == MAX_VEL:
			current_spd += MV_LAG
		velocity.x = current_spd
	else:
		while current_spd != 0:
			if current_spd < 0:
				current_spd += MV_LAG
			elif current_spd > 0:
				current_spd -= MV_LAG
		velocity.x = current_spd
	if (Input.is_action_pressed("player_jump")) and (can_jump):
		can_jump = false
		velocity.y = -JMP
	
	if (Input.is_action_pressed("player_crouch")):
		sprite.set_frame(1)
		standing_collision.set_trigger(true)
		crouching_collision.set_trigger(false)
	else:
		sprite.set_frame(0)
		standing_collision.set_trigger(false)
		crouching_collision.set_trigger(true)
		
	move(velocity * delta)
	if (is_colliding()):
		if (not Input.is_action_pressed("player_jump")) and (not can_jump):
			can_jump = true
		var n = get_collision_normal()
		var motion = n.slide(velocity * delta)
		velocity = n.slide(velocity)
		move(motion)
	if health <= 0:
		get_tree().quit()

func _ready():
	set_fixed_process(true)