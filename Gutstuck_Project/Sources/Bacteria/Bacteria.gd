extends KinematicBody2D

var target = Vector2()
var velocity = Vector2()
export (int) var speed = 200
var generation_number = 0
var energy=50
var time

var state = 'chill' #state contains {chill, selected, moving, foraging, replication}

# Called when the node enters the scene tree for the first time.
func _ready():
	generation_number+=1
	pass # Replace with function body.


func _input(event):
	if state=='selected':
		look_at(get_global_mouse_position())
		if event.is_action_pressed('click'):
			target = get_global_mouse_position()

func _physics_process(delta):
	velocity = (target - position).normalized() * speed
	#rotation = velocity.angle()
	if state=='selected':
	#if (target - position).length() > 5: taht was in the tuto, thought to replace it with the other if
		move_and_slide(velocity)
		look_at(target)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state=='chill' or state=='selected':
		energy=func _energy_chill(time-((100-energy_after_foraging)/100))
	pass
