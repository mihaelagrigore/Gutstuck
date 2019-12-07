extends KinematicBody2D

var target = Vector2()
var velocity = Vector2()
export (int) var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	look_at(get_global_mouse_position())
	if event.is_action_pressed('click'):
		target = get_global_mouse_position()

func _physics_process(delta):
	velocity = (target - position).normalized() * speed
	#rotation = velocity.angle()
	if (target - position).length() > 5:
		move_and_slide(velocity)
		look_at(target)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
