#extends KinematicBody2D
extends Area2D
class_name Nutrient

const STATE_CHILL = 0		#nothing happening
const STATE_ATTACKED = 1	#someone is feeding on me
const STATE_DEPLETED = 2	#time to gracefully die
const INITIAL_ENERGY = 100	#my energy level when I spawn

#what am I doing at the moment ?
#when I spawn, I am just chillin'
var state = STATE_CHILL setget state_set, state_get

#my energy level 
#when reaches 0 -> depleted -> time to break into pieces
var energy = INITIAL_ENERGY setget energy_set, energy_get

var colliding_bacteria = [] 
var one_bite = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE_CHILL
	energy = INITIAL_ENERGY

func _process(delta):
	if state == STATE_ATTACKED:
		for bacteria in colliding_bacteria:
			var morsel = 0
			if energy >= one_bite:
				#feed the bacteria the standard energy morsel
				morsel = bacteria.feed_me(one_bite)
			else:
				morsel = bacteria.feed_me(energy)
			energy -= morsel
			#if my energy level is 0, I change my state. 
			#my children will know what to do 
			if energy == 0:
				state = STATE_DEPLETED
				colliding_bacteria.clear()
				deactivate()
				#TODO: explode into pieces
				break #terminate the for loop

# Bacteria feeding on me will call this function
func bite_me(bite_size: int) -> int:
	var morsel = 0
	if energy >= bite_size:
		morsel = bite_size
		energy -= bite_size
	else:
		morsel = energy
		energy = 0

	#if my energy level is 0, I change my state. 
	#my children will know what to do 
	if energy == 0:
		state = STATE_DEPLETED

	return morsel

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func state_set(value):
	state = value

func state_get():
	return state

func energy_set(value):
	energy = value

func energy_get():
	return energy
	
func activate():
	get_node("CollisionShape2D").disabled = false
	visible = true
	
func deactivate():
	get_node("CollisionShape2D").disabled = true
	visible = false