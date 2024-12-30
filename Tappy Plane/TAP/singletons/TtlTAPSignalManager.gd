extends Node

# The signal hub pattern basically routes
# signals through itself. This way, instead of
# signal emitter A needing to track signal listener B
# for literally all such pairs, we can just have
# both connect to the signal hub.

signal on_score_updated
signal on_plane_died
