extends Bacteria

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("select", self, "Being_Selected")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func Being_Selected(unit) :
	print("i'm being selected !")
	
func select(unit) :
	print("i'm being selected !")


func get_pos() :
	print(position)