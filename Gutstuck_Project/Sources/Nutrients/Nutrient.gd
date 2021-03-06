extends KinematicBody2D
#extends Area2D
class_name Nutrient

const STATE_CHILL = 0		#nothing happening
const STATE_ATTACKED = 1	#someone is feeding on me
const STATE_DEPLETED = 2	#time to gracefully die
const STATE_EXPLODING = 3	#time to gracefully die
const INITIAL_ENERGY = 100	#my energy level when I spawn

#Declaring the health bar
onready var Energy_Level_Bar = $EnergyLevel

#what am I doing at the moment ?
#when I spawn, I am just chillin'
var state = STATE_CHILL setget state_set, state_get

#my energy level 
#when reaches 0 -> depleted -> time to break into pieces
var energy = INITIAL_ENERGY setget energy_set, energy_get

var colliding_bacteria = []

onready var audio_player = get_node("AudioStreamPlayer")
var finish_being_eaten_sound = load("res://Assets/Audios/Sounds/reward_sound.wav")


func update_energy_bar(value: int):
	Energy_Level_Bar.value=value

func _timeout():
	print("Timed out!")

func state_set(value):
	state = value

func state_get():
	return state

func energy_set(value):
	energy = value

func energy_get():
	return energy

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE_CHILL
	energy = INITIAL_ENERGY
	$Explosion.hide()
	update_energy_bar(energy)

func _process(delta):
	if state == STATE_DEPLETED:
		colliding_bacteria.clear()
		get_node("CollisionShape2D").disabled = true
		print("draw explosion")
		state = STATE_EXPLODING
		$Explosion.show()
		#$ExplosionTimer.start()
		$AnimationPlayer.play("Explosion")

# Bacteria feeding on me will call this function
# Bacteria tries to bite an amount of energy = bite_size
# I might have less energy left than bite_size
# So I return bite_size >= energy ? bite_size : energy (ternary operator) 
func bite_me(bite_size: int) -> int:
	var morsel = 0
	if energy >= bite_size:
		morsel = bite_size
		energy -= bite_size
	else:
		morsel = energy
		energy = 0
	update_energy_bar(energy)
	$Energy.text = str(energy)

	#if my energy level is 0, I change my state. 
	#my children will know what to do 
	if energy == 0:
		state = STATE_DEPLETED

	return morsel
	
func activate():
	get_node("CollisionShape2D").disabled = false
	visible = true
	
func deactivate():
	get_node("CollisionShape2D").disabled = true
	visible = false
	
func _on_BacteriaInteraction_body_entered(body: PhysicsBody2D) -> void:
	print("[Nutrient] Body entered event: ")
	print(body.get_class())
	if body.is_in_group("Bacteria"): #is the colliding entity a bacteria ?
		#add bacteria to the nutrient's list of bacterias currently feeding on it
		print('[Nutrient] appending bacteria') 
		colliding_bacteria.append(body)
		state_set(STATE_ATTACKED)

func _on_BacteriaInteraction_body_exited(body: PhysicsBody2D) -> void:
	print("[Nutrient] Body exited event")
	if body.is_in_group("Bacteria"):
		#remove the bacteria from my list
		if colliding_bacteria.count(body):
			print('[Nutrient] removing bacteria') 
			colliding_bacteria.erase(body) 
		if colliding_bacteria.empty():
			state = STATE_CHILL #no longer under attack

func _on_ExplosionTimer_timeout() -> void:
	print("hide particle")
	$Explosion.hide()
	queue_free()
	deactivate()

func instanciate_death_chunck_particles():
	$Particles_Nutrients_Death/AnimationPlayer.play("Particles")