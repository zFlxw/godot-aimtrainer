extends Control

@onready var label = $ScoreLabel

func _ready():
	Globals.updated_score.connect(render_score)

func render_score(score):
	label.text = "Score: " + str(score)
