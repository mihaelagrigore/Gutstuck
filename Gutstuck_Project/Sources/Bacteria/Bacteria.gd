extends KinematicBody2D

var target = Vector2()
var velocity = Vector2()
export (int) var speed = 200
var generation_number = 0
const initial_energy=50
var energy = initial_energy
var energy_after_foraging
var time
var state = 'chill' #state can contain {chill, selected, moving, foraging, replicating}

# Called when the node enters the scene tree for the first time.
func _ready():
	if generation_number >0:
		generation_number+=1
	pass # Replace with function body.

# get.time_from general game timer # how do I do that

func _input(event):
	if state=='selected':
		look_at(get_global_mouse_position())
		if event.is_action_pressed('click'):
			target = get_global_mouse_position()

func _physics_process(delta):
	if state=='selected':
		velocity = (target - position).normalized() * speed
		#rotation = velocity.angle()
	#if (target - position).length() > 5: that was in the tuto, thought to replace it with the other if
		move_and_slide(velocity) #to replace by pathfinding
		look_at(target)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Evolution of energy quantity
	if state=='chill' or state=='selected':
		energy=_energy_chill(time-((100-energy_after_foraging)/100)) #f(t), t being the time from the origin, where energy=initial_energy
	elif state=='moving':
		energy=_energy_moving(time-((100-energy_after_foraging)/100))
	elif state=='foraging':
		#energy=bite_me ?
		energy_after_foraging=energy
	pass

func _energy_chill(t):
	energy=100-t
	pass

func _energy_moving(t):
	energy=90-t
	pass