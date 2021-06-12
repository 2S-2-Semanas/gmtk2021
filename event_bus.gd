extends Node

# This class is a hub for signals that need to be global. 

# All nodes can connect/emit this signals

# This way, we can e.g. update UI nodes with signals that are emited in game,
# such as losing lives, gaining points, and having a game over,
# and also control the game with the UI buttons. 
# Or at least thats the idea I think. I saw it first on a youtube video but is
# mainly taken from here https://gdscript.com/solutions/signals-godot/

# Tell Godot to ignore warnings of unused signals
#warning-ignore:unused_signal

signal game_over

signal monkey_grabbed

signal banana_eated
