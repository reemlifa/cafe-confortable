extends Node2D

@onready var coffee_anim: AnimationPlayer = $coffeeMachine/AnimationPlayer

@onready var fridge_closed = $fridge
@onready var fridge_open = $fridgeOpen

@onready var mug: Node2D = $shelf/mug1
@onready var mug_target: Node2D = $coffeeMachine/mugTarget

@onready var coffee: Node2D = $coffee
@onready var coffee_milk_done: Node2D = $coffeeAndMilk

@onready var mug_area: Area2D = $shelf/mug1/Area2D
@onready var machine_area: Area2D = $coffeeMachine/Area2D
@onready var fridge_area: Area2D = $fridge/Area2D
@onready var milk_area: Area2D = $fridgeOpen/milk/Area2D
@onready var doneButton = $doneButton

var mug_selected := false
var brewing := false
var brewed := false

func _ready() -> void:
	fridge_open.visible = false
	coffee.visible = false
	coffee_milk_done.visible = false
	
	fridge_area.monitoring = false
	milk_area.monitoring = false
	
	doneButton.visible = false


	coffee_anim.animation_finished.connect(_on_anim_finished)

	mug_area.input_event.connect(_on_mug_area_input_event)
	machine_area.input_event.connect(_on_machine_area_input_event)
	fridge_area.input_event.connect(_on_fridge_area_input_event)
	milk_area.input_event.connect(_on_milk_area_input_event)

func _on_mug_area_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		mug_clicked()

func _on_machine_area_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		machine_clicked()
func _on_fridge_area_input_event(_viewport, event, _shape_idx) -> void:
	if event is  InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		fridge_clicked()
func _on_milk_area_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		milk_clicked()


func mug_clicked() -> void:
	if brewing or brewed:
		return
	mug_selected = true
	_pop(mug)

func machine_clicked() -> void:
	if not mug_selected:
		return
	if brewing or brewed:
		return

	brewing = true

	var t = create_tween()
	t.tween_property(mug, "global_position", mug_target.global_position, 0.35)

	t.finished.connect(func():
		coffee_anim.play("brew")
	)

func _on_anim_finished(name: StringName) -> void:
	if name != "brew":
		return

	brewing = false
	brewed = true

	coffee.visible = true
	coffee_milk_done.visible = false
	mug.visible = false
	
	fridge_area.monitoring = true


func _pop(n: Node) -> void:
	if n is Node2D:
		var t = create_tween()
		t.tween_property(n, "scale", Vector2(1.05, 1.05), 0.08)
		t.tween_property(n, "scale", Vector2(1.0, 1.0), 0.08)

func fridge_clicked() -> void:
	if not brewed:
		return

	fridge_closed.visible = false
	fridge_open.visible = true
	milk_area.monitoring = true


func milk_clicked() -> void:
	coffee.visible = false
	coffee_milk_done.visible = true
	await get_tree().create_timer(0.6).timeout
	doneButton.visible = true


func _on_done_button_pressed() -> void:
	get_tree().change_scene_to_file("res://day1/create_drinks/create_drinks.tscn")
