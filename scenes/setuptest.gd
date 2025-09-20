extends Control

enum TYPE {RED, BLUE, BROWN}
enum TEAM {RED, BLUE}

func _ready():
	var a = TEAM.RED
	var b = TEAM.BLUE
	
	var x = TYPE.BROWN
	var y = TYPE.RED
	
	print(a == x)
	print(a == y)
	print(b == y+1)
	
	var rr = Global.COLOR[TYPE.RED]
	print(rr)
