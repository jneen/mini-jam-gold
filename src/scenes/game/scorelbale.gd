extends Label

var timerleft = 60

func _on_Timer_timeout():
	if timerleft == 1:
		timerleft -= 1
		$"../ColorRect".show()
		hide()
		$"../../../Players/Player".hide()
		$"../ColorRect/Label".text = "SCORE: " + str($"../../../Players/Player".coins) + "\nShare your score in the comments !\n\nThanks for playing, we took a lot of time making it but due to developing issues (a lot) we didn't come up with the expected result so this will come maybe with other updates."
	else:
		timerleft -= 1
	text = str(timerleft)
	$Timer.start()
