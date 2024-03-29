extends RigidBody2D
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity = (target.position - position).normalized() * 100

func _on_body_entered(_body):
	queue_free()
	hide()

	
func set_target(player):
	target = player

	
