extends DialogEvent
class_name  TimedEvent

@export var triggerTime = 60
@onready var TriggerTimer = $EventTimer

func _ready() -> void:
	super._ready()
	TriggerTimer.wait_time = triggerTime
	TriggerTimer.start()
	
func _on_event_timer_timeout() -> void:
	self.fireEvent()
