extends KinematicBody2D

var target = Vector2()
var velocity = Vector2()
export (int) var speed = 200
var generation_number = 0
const INITIAL_ENERGY=50
var energy = INITIAL_ENERGY
var energy_after_foraging

var time

const STATE_CHILL = 0
const STATE_SELECTED = 1
const STATE_MOVING = 2
const STATE_EATING = 3
const STATE_REPLICATING = 4

var state = STATE_CHILL #state can contain {STATE_CHILL, STATE_SELECTED, STATE_MOVING, STATE_EATING, STATE_REPLICATING}


#food_sources
# Called when the node enters the scene tree for the first time.
func _ready():
	if generation_number >0:
		generation_number+=1
	pass # Replace with function body.

# get.time_from general game timer # how do I do that

func _input(event):
	if state==STATE_SELECTED:
		look_at(get_global_mouse_position())
		if event.is_action_pressed('click'):
			target = get_global_mouse_position()

func _physics_process(delta):
	if state== STATE_SELECTED:
		velocity = (target - position).normalized() * speed
		#rotation = velocity.angle()
	#if (target - position).length() > 5: that was in the tuto, thought to replace it with the other if
		move_and_slide(velocity)
		# using move_and_collide
		var collision = move_and_collide(velocity * delta)
		#A collision will stop the moving except if the collider is another bacteria
		if collision:
			#if body extends Bacteria #still need to find the right words
    		velocity = velocity.slide(collision.normal)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Evolution of energy quantity
	if state==STATE_CHILL or state==STATE_SELECTED:
		energy=_energy_chill(time-((100-energy_after_foraging)/100)) #f(t), t being the time from the origin, where energy=initial_energy
	elif state==STATE_MOVING:
		energy=_energy_moving(time-((100-energy_after_foraging)/100))
	
	elif state==STATE_EATING:
		
		#energy=bite_me ?
		energy_after_foraging=energy
	pass

func _energy_chill(t):
	energy=100-t
	pass

func _energy_moving(t):
	energy=90-t
	pass

bool fed_up
func _feed_me(energy):
	if energy==100:
		fed_up=true
	else:
		energy+=get_energy_from_nutrient

func _stop_feeding():
	state=STATE_CHILL