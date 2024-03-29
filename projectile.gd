extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var projectile_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


# Replace with function body.
func _on_body_entered(_body):
	queue_free()
	hide()
