extends Node2D


@export var customer_path: NodePath
@export var messageBox_path: NodePath
@export var coffee_path: NodePath
@export var milk_path: NodePath
@export var done_button_path: NodePath

@export var delay_customer_to_messageBox := 1
@export var delay_messagebox_to_coffee := 2
@export var delay_coffee_to_milk := 2
@export var delay_milk_to_done := 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await play_intro()
	var done_button := get_node(done_button_path) as Button
func play_intro() -> void:
	var customer := get_node(customer_path) as CanvasItem
	var box := get_node(messageBox_path) as CanvasItem
	var coffee := get_node(coffee_path) as CanvasItem
	var milk := get_node(milk_path) as CanvasItem
	var done_button := get_node(done_button_path) as Button
	
	# starting hidden 
	customer.visible = false
	box.visible = false
	coffee.visible = false
	milk.visible = false
	done_button.visible = false
	
	await pop_in(customer)
	await get_tree().create_timer(delay_customer_to_messageBox).timeout
	
	await pop_in(box)
	await get_tree().create_timer(delay_messagebox_to_coffee).timeout
	
	await pop_in(coffee)
	await get_tree().create_timer(delay_coffee_to_milk).timeout
	
	await pop_in(milk)
	await get_tree().create_timer(delay_milk_to_done).timeout
	
	await pop_in(done_button)
	
func pop_in(item: CanvasItem) -> void: 
	item.visible = true
	
	var target_scale: Vector2 = item.scale
	item.scale = target_scale * 0.7
	
	
	var t := create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(item, "scale", target_scale, 0.18)

	await t.finished
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_done_button_pressed() -> void:
		get_tree().change_scene_to_file("res://day1/create_drinks/create_drinks.tscn")
