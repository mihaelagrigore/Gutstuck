extends Nutrient

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	#what to do here ?
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if (state == STATE_DEPLETED):
		#to prevent anyone from colliding into me 
		#until I completely die
		#get_node("CollisionShape2D").disabled = true 
		
		#TODO: replace Sprite with a 
		#Particle2D explosion effect
				
		#last thing I do: I delete myelf from memory
		#queue_free()
		# wait, is it possible that another bacteria was waiting in line
		# to feed on me and now will get smth like a NULL pointer exception ?
	pass
