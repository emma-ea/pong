extends Node2D

var screen_size
var pad_size
var RAND_DIR = randf() * 2 -1
var direction = Vector2(1.0, 0.0)

# constant for ball speed (in pixels/second)
const INITIAL_BALL_SPEED = 80

# speed of ball (in pixels/second)
var ball_speed = INITIAL_BALL_SPEED

# speed of pads
const PAD_SPEED = 150


func _ready():
	screen_size = get_viewport_rect().size
	pad_size = $left.get_texture().get_size()
	set_process(true)


func move_pads(delta):
	# move right pad
	var rpad = $right.position
	if (rpad.y > 0 and Input.is_action_pressed("right_move_up")):
		rpad.y += -PAD_SPEED * delta
	if (rpad.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		rpad.y += PAD_SPEED * delta
	$right.position = rpad
	
	# move left pad
	var lpad = $left.position
	if (lpad.y > 0 and Input.is_action_pressed("left_move_up")):
		lpad.y += -PAD_SPEED * delta
	if (lpad.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		lpad.y += PAD_SPEED * delta
	$left.position = lpad


func ball_physics(left_rect, right_rect, ball_pos):
	# is ball colling with roof or floor. flip
	if ((ball_pos.y < 0 and direction.y < 0) 
		or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
		
	# change ball direction as collides with rect
	if ((left_rect.has_point(ball_pos) and direction.x < 0) 
		or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf() * 2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		
	# check game over. ball out of screen bounds
	if (ball_pos.x > screen_size.x or ball_pos.x < 0):
		ball_pos = screen_size * .5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(RAND_DIR, RAND_DIR)
	
	$ball.position = ball_pos


func _process(delta):
	var ball_pos = $ball.position
	# Rect2 wraps around pads for collision/tests..
	var left_rect = Rect2($left.position - pad_size * .5, pad_size)
	var right_rect = Rect2($right.position - pad_size * .5, pad_size)
	
	# integrate new ball position
	ball_pos += direction * ball_speed * delta
	
	
	ball_physics(left_rect, right_rect, ball_pos)
	
	move_pads(delta)
	
	
