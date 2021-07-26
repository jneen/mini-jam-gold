extends Sprite

func retrieve_save_flags():
	return null

func score_amount(body):
	if body.is_crown: return 2
	return 1

func _process(delta):
	var score = 0
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("Coin"):
			score += score_amount(body)

	$"../../../Players/Player".coins = score
