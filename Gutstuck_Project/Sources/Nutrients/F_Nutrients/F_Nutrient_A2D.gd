extends Nutrient

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	#what to do here ?
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (state == STATE_DEPLETED):
		#to prevent anyone from colliding into me 
		#until I completely die
		get_node("CollisionShape2D").disabled = true 
		
		#TODO: replace Sprite with a 
		#Particle2D explosion effect
		
		
		#last thing I do: I delete myelf from memory
		queue_free()
		# wait, is it possible that another bacteria was waiting in line
		# to feed on me and now will get smth like a NULL pointer exception ?
#	pass

func _on_F_Nutrient_A2D_body_entered(body) -> void:
	print("Body entered event")
	if body.is_in_group("Bacteria"):
		#add bacteria to the nutrient's list of bacterias
		#that are feeding on it
		colliding_bacteria.append(body)
		
		#add myself to the list that the bacteria keeps
		#it doesn't keep a list anymore
		#body.colliding_nutrient.append(self)
		
		#change my state
		state_set(STATE_ATTACKED)

func _on_F_Nutrient_A2D_body_exited(body: PhysicsBody2D) -> void:
	print("Body exited event")
	if body.is_in_group("Bacteria"):
		#remove the bacteria from the list of bacteria
		#currently feeding on this nutrient
		colliding_bacteria.erase(body) 
		if colliding_bacteria.empty():
			#no longer under attack
			state = STATE_CHILL
		
		#remove this nutrient from the colliding bacteria's 
		#list of nutrients that it's currently feeding on
		#body.colliding_nutrients.remove(body.colliding_nutrients.find(self))
