extends Node

signal updated_score(new_score)

var score: int = 0

func update_score():
	score += 1
	updated_score.emit(score)
