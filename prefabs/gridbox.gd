extends CSGBox3D


@export var gridbox: Node3D

func _ready():
	gridbox.choose.connect(check_choose)

func check_choose(num):
	print("Choose from " + self.name)

func hit():
	print("Hit gridbox!")
