extends Sprite

func retrieve_save_flags():
	return null

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if $"../../../World/Entities/Coin".held:
			print("yea")
			$"../../../Players/Player".coins += 1
			$"../../../World/Entities/Coin".held = false
			$"../../../World/Entities/Coin".show()
			$"../../../Players/Player".held_item = null
		else:
			print("   " + str($"../../../World/Entities/Coin".held))
			
