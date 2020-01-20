extends KinematicBody2D
class_name Bacteria

const INITIAL_ENERGY=50
const ENERGY_LOS_PER_PERIOD_CHILL = 10 #1
const ENERGY_LOS_PER_PERIOD_MOVE = 20
const MAX_ENERGY=100

var target = Vector2()
export (int) var speed = 400

var generation_number = -1 #measures the number of generation to kill the oldest ones in a situation of conflict
var energy_level = INITIAL_ENERGY
var energy_per_bite = 10

#energy_after_foraging var must be dropped
#it must be declared as a local var inside the functions
#where it is being used
#also, mind that you use the var before initializing it (before
#attributing a value to it) 

onready var Energy_Level_Bar = $EnergyLevel

const STATE_CHILL = 0
const STATE_MOVING = 1
const STATE_EATING = 2
const STATE_FULL = 3
const STATE_REPLICATING = 4

signal die(victim)
signal duplicate(mother)

const STATE_SELECTED = 1
const STATE_UNSELECTED = 2

var substate = STATE_UNSELECTED setget state_set, state_get
var state = STATE_CHILL setget state_set, state_get
var colliding_nutrients = []

var isBacteriaLowEnergy = false

func state_set(value):
	state = value

func state_get():
	return state

func substate_set(value):
	substate = value

func substate_get():
	return substate

#food_sources
# Called when the node enters the scene tree for the first time.
func _ready():
	#var inputManager = load("res://Sources/System/Input_Manager.tscn")
	#connect("die", inputManager, "_on_die" )
	$Dying_Signal.hide()
	
	generation_number+=1
	$EnergyLossTimer.start()

func _input(event):
	if substate==STATE_SELECTED:
		$Sprite.look_at(get_global_mouse_position())
#		if event.is_action_pressed('click'):
#			target = get_global_mouse_position()

func _physics_process(delta):
	var velocity = Vector2()
	if state == STATE_MOVING:
		if (abs(target.x-position.x)<5) && (abs(target.y-position.y))<5:
			target = position
			state=STATE_CHILL
			pass
		velocity = (target - position).normalized() * speed
		move_and_slide(velocity)
		#$Sprite.look_at(get_global_mouse_position())
		#rotation = velocity.angle()
	#if (target - position).length() > 5: that was in the tuto, thought to replace it with the other if
		
#		var collision = move_and_collide(velocity * delta)
#		#A collision will stop the moving except if the collider is another bacteria
#		if collision:
#			#if body extends Bacteria #still need to find the right words
#    		velocity = velocity.slide(collision.normal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if energy_level < 0:
		energy_level = 0


	if energy_level<=0:
		$Sprite/AnimationPlayer.play("Bacteria_Die")
	
	if energy_level <= 30 && !isBacteriaLowEnergy:
		isBacteriaLowEnergy = true
		$Dying_Signal.show()
		$Sprite/AnimationPlayer.play("Bacteria_Low_Energy")
	if energy_level > 30 && isBacteriaLowEnergy:
		isBacteriaLowEnergy = false
		$Dying_Signal.hide()
		$Sprite/AnimationPlayer.stop()
	# Evolution of energy quantity
	#TODO: implement energy loss as a function of time
	#I commented the ones below because they led to weird
	#energy quantities like 94.688899
	#Thinking to implement energy loss as a Timer
#	if state==STATE_CHILL or state==STATE_SELECTED:
#		energy_level -= ENERGY_LOS_PER_SECOND_CHILL * delta
#	elif state==STATE_MOVING:
#		energy_level -= ENERGY_LOS_PER_SECOND_MOVE * delta
#		# update the energy bar displayed above the bacteria Sprite
#	elif state==STATE_FULL:
#		#TODO: implement replication
#		pass #remove pass once code is added above this line

func finish_eating():
	print("[Bacteria] finished eating...")
	$MealTimer.stop()
	#it feels natural to have some inertia when we are full
	#when the SaturationTimer is off, I can start loosing energy
	#and start eating again
	$SaturationTimer.start()
	state = STATE_REPLICATING
	emit_signal("duplicate", self)
	
func prematurely_finish_eating():
	print("[Bacteria] abandoning food...")
	$MealTimer.stop()
	#it feels natural to have some inertia when we are full
	#when the SaturationTimer is off, I can start loosing energy
	#and start eating again
	$EnergyLossTimer.start() 
	
func update_energy_bar(value: int):
	Energy_Level_Bar.value=value
	
func _on_MealTimer_timeout() -> void:
	# we should always be in STATE_EATING when this timer goes off
	# but for now it's good to check just to staty safe
	if state==STATE_EATING: 
		var count = 0
		for nutrient in colliding_nutrients:
			count = count + 1
			print(str("[bite from Nutrient ",count,"]"))
			var morsel = energy_per_bite
			if energy_level + energy_per_bite >= MAX_ENERGY:
				morsel =  MAX_ENERGY - energy_level
				state = STATE_FULL
			print(str("requested: ", morsel))
			var real_morsel = nutrient.bite_me(morsel)
			print(str("received: ", real_morsel))
			energy_level += real_morsel
			$Energy.text = str(energy_level)
			update_energy_bar(energy_level)
			if state == STATE_FULL:
				finish_eating()

func _on_SaturationTimer_timeout() -> void:
	state_set(STATE_CHILL)
	$SaturationTimer.stop()
	$EnergyLossTimer.start()

func _on_EnergyLossTimer_timeout() -> void:
	if state==STATE_CHILL:
		energy_level -= ENERGY_LOS_PER_PERIOD_CHILL
	if state==STATE_MOVING:
		energy_level -= ENERGY_LOS_PER_PERIOD_MOVE
	$Energy.text = str(energy_level)
	update_energy_bar(energy_level)


func Bacteria_Die():
	emit_signal("die", self)
	queue_free() # Removes the node from the scene and frees it when it becomes safe to do so.