extends Node
@export var mob_scene: PackedScene
var score
var enemyLaugh := AudioStreamPlayer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("update_health", $HUD._update_bar)
	add_child(enemyLaugh)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop() 
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	

func _on_mob_timer_timeout():
	if $MobManager.get_child_count() > 10:
		return
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	
	mob.set_target($Player)
	
	$MobManager.add_child(mob)
	enemyLaugh.stream = load("res://audio/laugh2.mp3")
	enemyLaugh.play()
	
func _on_body_entered(mob):
	$MobManager.remove_child(mob)



	
	

