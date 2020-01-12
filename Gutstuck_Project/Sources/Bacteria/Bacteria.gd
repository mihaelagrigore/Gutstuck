extends KinematicBody2D
class_name Bacteria

const INITIAL_ENERGY=50
const ENERGY_LOS_PER_SECOND_CHILL = 1
const ENERGY_LOS_PER_SECOND_MOVE = 1
const MAX_ENERGY=100

var target = Vector2()
export (int) var speed = 400

var generation_number = 0 #measures the number of generation to kill the oldest ones in a situation of conflict
var energy_level = INITIAL_ENERGY

#energy_after_foraging var must be dropped
#it must be declared as a local var inside the functions
#where it is being used
#also, mind that you use the var before initializing it (before
#attributing a value to it) 


onready var energy_level_bar = $Energy_level_bar


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
		$Sprite.look_at(get_global_mouse_position())
#		if event.is_action_pressed('click'):
#			target = get_global_mouse_position()

func _physics_process(delta):
	var velocity = Vector2()
	if state== STATE_MOVING:
		velocity = (target - position).normalized() * speed
		$Sprite.look_at(get_global_mouse_position())
		#print("velocity=",velocity)
		#rotation = velocity.angle()
	#if (target - position).length() > 5: that was in the tuto, thought to replace it with the other if
		move_and_slide(velocity)

#		var collision = move_and_collide(velocity * delta)
#		#A collision will stop the moving except if the collider is another bacteria
#		if collision:
#			#if body extends Bacteria #still need to find the right words
#    		velocity = velocity.slide(collision.normal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if energy_level==0:
		queue_free() # Removes the node from the scene and frees it when it becomes safe to do so.
	# Evolution of energy quantity
	if state==STATE_CHILL or state==STATE_SELECTED:
		energy_level -= ENERGY_LOS_PER_SECOND_CHILL * delta
	elif state==STATE_MOVING:
		energy_level -= ENERGY_LOS_PER_SECOND_MOVE * delta
	elif state==STATE_EATING:
		update_energy_bar(energy_level)
		# update the energy bar displayed above the bacteria Sprite
	elif state==STATE_FULL:
		#TODO: implement replication
		pass #remove pass once code is added above this line


func update_energy_bar(value: int):
	energy_level_bar.value=value
	pass

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