extends KinematicBody2D
class_name Nutrient

#what am I doing at the moment ?
#when I spawn, I am just chillin'
var state = STATE_CHILL

#my energy level 
#when reaches 0 -> depleted -> time to break into pieces
var energy = INITIAL_ENERGY

const STATE_CHILL = 0		#nothing happening
const STATE_ATTACKED = 1	#someone is feeding on me
const STATE_DEPLETED = 2	#time to gracefully die
const INITIAL_ENERGY = 100	#my energy level when I spawn

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE_CHILL
	energy = INITIAL_ENERGY

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
