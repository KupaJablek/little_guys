@tool
extends TileMapLayer
class_name Maze


@export var size: Vector2i #Must be ODD number
@export var completion_tile_location: Vector2i


@onready var background: TileMapLayer = $Background
@onready var checkpoints: TileMapLayer = $Checkpoints
@onready var completion: Area2D = $Completion
@onready var player = null

var start: Vector2i
var end: Vector2i
var visited: Array[Vector2i] = []
var grid: Array[Vector2i] = [] #Grid stating if we have walls or not


func _ready():
	#Set background.  This will not change
	generate_maze()


func generate_maze() -> void:
	grid.clear()
	clear()
	
	for x in size.x:
		for y in size.y:
			set_cell(Vector2(x, y), 0, Vector2i(0, 0))
	
	for x in float(size.x + 1) / 2:
		for y in float(size.y + 1) / 2:
			grid.append(Vector2i(2 * int(x), 2 * int(y)))
	
	var current_cell: Vector2i = Vector2i.ZERO
	visited = [current_cell]
	var stack = []
	while len(visited) < ceil(float(size.x) / 2) * ceil(float(size.y) / 2):
		var neighbours: Array = []
		for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var check = direction * 2 + current_cell
			if not visited.has(check) and check.x >= 0 and check.x < size.x and check.y >= 0 and check.y < size.y:
				neighbours.append(check)
		if len(neighbours) > 0:
			var random_neighbour = neighbours[randi() % len(neighbours)]
			stack.push_front(current_cell)
			var wall: Vector2i = (random_neighbour - current_cell) / 2 + current_cell
			grid.append(wall)
			current_cell = random_neighbour
			visited.append(current_cell)
		elif len(stack) > 0:
			current_cell = stack.pop_front()
	
	var random_start: int = randi_range(0, size.x + size.y)
	if random_start <= size.x:
		start = Vector2i(random_start, 0)
		end = Vector2i(size.x - random_start - 1, size.y - 1)
	else:
		start = Vector2i(0, random_start - size.x)
		end = Vector2i(size.x - 1, size.y - (random_start - size.x))
	
	set_cells_terrain_connect(grid, 0, 0)
	for x in size.x:
		for y in size.y:
			if Vector2i(x, y) not in grid:
				set_cell(Vector2i(x, y))
	
	checkpoints.set_cell(end, 0, completion_tile_location)
	#Set the players starting location to start
	completion.position = Vector2(tile_set.tile_size * end) + tile_set.tile_size * 0.5


func _on_completion_entered(body: Node2D) -> void:
	pass #This is our win condition.  We need to add extra dopamine?  Clear our objective and regenerate the maze. Play win sound?
