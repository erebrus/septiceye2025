extends Node

@warning_ignore("unused_signal")
signal level_ended()

@warning_ignore("unused_signal")
signal show_manual_requested
@warning_ignore("unused_signal")
signal show_list_requested
@warning_ignore("unused_signal")
signal show_passport_requested
@warning_ignore("unused_signal")
signal stamp_requested(destination: Types.Destination)

@warning_ignore("unused_signal")
signal day_started
@warning_ignore("unused_signal")
signal day_finished

@warning_ignore("unused_signal")
signal character_entered(character: Character)
@warning_ignore("unused_signal")
signal character_stamped(destination: Types.Destination, expected: Types.Destination)
@warning_ignore("unused_signal")
signal character_left
