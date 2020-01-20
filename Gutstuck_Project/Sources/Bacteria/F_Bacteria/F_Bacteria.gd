extends Bacteria

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("F_Bacteria")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_NutrientInteraction_body_entered(body: PhysicsBody2D) -> void:
	#print("[Bacteria] Body entered event: ")
	#print(body.get_class())
	if body.is_in_group("F_Nutrient"): #is the colliding entity a bacteria ?
		print('[Bacteria] appending nutrient') 
		colliding_nutrients.append(body)		
		if state != STATE_EATING:
			$EnergyLossTimer.stop()
			state_set(STATE_EATING)
			$MealTimer.start()
	#else:
	#	print('[Bacteria] this was not an F_Nutrient')

func _on_NutrientInteraction_body_exited(body: PhysicsBody2D) -> void:
	#print("[Bacteria] Body exited event")
	if body.is_in_group("F_Nutrient"):
		#remove the bacteria from my list
		if colliding_nutrients.count(body):
			print('[Bacteria] removing nutrient') 
			colliding_nutrients.erase(body) 
		if (state!=STATE_FULL) && colliding_nutrients.empty():
			prematurely_finish_eating()
	#else:
	#	print('[Bacteria] this was not an F_Nutrient')