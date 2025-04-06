@tool
extends TileMapLayer
class_name Maze


@export var size: Vector2i #Must be ODD number
@export var wall_id: Vector2i
@export var path_id: Vector2i
@export var position_id: Vector2i

var start: Vector2i
var end: Vector2i
var visited: Array[Vector2i] = []


func _ready():
	generate_maze()


func generate_maze() -> void:
	clear()
	
	for x in size.x:
		for y in size.y:
			set_cell(Vector2(x, y), 0, wall_id)
	
	for x in float(size.x + 1) / 2:
		for y in float(size.y + 1) / 2:
			set_cell(Vector2(2 * x , 2 * y), 0, path_id)
	
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
			set_cell(Vector2(wall.x, wall.y), 0, path_id)
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
	set_cell(start, 0, position_id)
	set_cell(end, 0, position_id)
