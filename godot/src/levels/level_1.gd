extends BaseLevel

func _ready():
	super._ready()
	Events.manual_hidden.connect(%OpenManual.trigger)
