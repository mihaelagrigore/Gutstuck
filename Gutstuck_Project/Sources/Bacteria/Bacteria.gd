extends KinematicBody2D
class_name Bacteria

const INITIAL_ENERGY=50
const ENERGY_LOS_PER_SECOND_CHILL = 1
const ENERGY_LOS_PER_SECOND_MOVE = 1
const MAX_ENERGY=100

var target = Vector2()
export (int) var speed = 200

var generation_number = 0
var energy_level = INITIAL_ENERGY

#energy_after_foraging var must be dropped
#it must be declared as a local var inside the functions
#where it is being used
#also, mind that you use the var before initializing it (before
#attributing a value to it) 
#var energy_after_foraging  

#var time

const STATE_CHILL = 0
const STATE_SELECTED = 1
const STATE_MOVING = 2
const STATE_EATING = 3
const STATE_FULL = 4
const STATE_REPLICATING = 5

var state = STATE_CHILL #state can contain {STATE_CHILL, STATE_SELECTED, STATE_MOVING, STATE_EATING, STATE_REPLICATING}
#var colliding_nutrients

#food_sources
# Called when the node enters the scene tree for the first time.
func _ready():
	if generation_number >0:
		generation_number+=1
	pass # Replace with function body.


func _input(event):
	if state==STATE_SELECTED:
		look_at(get_global_mouse_position())
		if event.is_action_pressed('click'):
			target = get_global_mouse_position()

func _physics_process(delta):
	var velocity = Vector2()
	if state== STATE_SELECTED:
		velocity = (target - position).normalized() * speed
		#rotation = velocity.angle()
	#if (target - position).length() > 5: that was in the tuto, thought to replace it with the other if
#		move_and_slide(velocity)

		var collision = move_and_collide(velocity * delta)
		#A collision will stop the moving except if the collider is another bacteria
		if collision:
			#if body extends Bacteria #still need to find the right words
    		velocity = velocity.slide(collision.normal)

var bar = load("res://Sources/Bacteria/Energy_level_bar.gd").new() #I don't know if it's the right
#way to code it
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if energy_level==0:
		#queue_free() # Removes the node from the scene and frees it when it becomes safe to do so.
		pass
	# Evolution of energy quantity
	if state==STATE_CHILL or state==STATE_SELECTED:
		#energy_level=energy_chill(time-((100-energy_after_foraging)/100)) #f(t), t being the time from the origin, where energy=initial_energy
		energy_level -= ENERGY_LOS_PER_SECOND_CHILL * delta
	elif state==STATE_MOVING:
		#energy_level=energy_moving(time-((100-energy_after_foraging)/100))
		energy_level -= ENERGY_LOS_PER_SECOND_MOVE * delta
	elif state==STATE_EATING:
		bar.update_energy_bar(energy_level)
		#TODO: update the energy bar displayed above the bacteria Sprite
	elif state==STATE_FULL:
		#TODO: implement replication
		pass #remove pass once code is added above this line

#no longer using these functions. 
#implemented the energy loss directly in _process
#func energy_chill(t):
#	energy_level=100-t

#no longer using these functions. 
#implemented the energy loss directly in _process
#func energy_moving(t):
#	energy_level=90-t


func feed_me(energy_from_nutrient: int) -> int :
	var morsel
	energy_level + energy_from_nutrient 
	if (energy_level+energy_from_nutrient) < MAX_ENERGY:
		morsel = energy_from_nutrient
		energy_level += energy_from_nutrient
	else:
		morsel = MAX_ENERGY - energy_level
		energy_level = MAX_ENERGY
		state = STATE_FULL
		#done eating, I deactivate my collisionshape
		#this way all nutrients I was feeding on
		#get a body_exit signal triggered and are informed I disappeared
		#don't forget to activate back
		deactivate()
	return morsel

func stop_feeding():
	state=STATE_CHILL
	
func activate():
	get_node("CollisionShape2D").disabled = false
	visible = true
	
func deactivate():
	get_node("CollisionShape2D").disabled = true
	visible = false