state(dormant).
state(init).
state(idle).
state(monitoring).

initial_state(dormant).

state(error_diagnosis).
state(safe_shutdown).

event(init_crash).
event(retry_init).
event(shutdown).
event(sleep).
event(idle_crash).
event(idle_rescue).
event(monitor_crash).
event(monitor_rescue).

guard('information must be logged').
guard('if retry does not exceed 3').
guard('if retry is 3').

%% transition(source_state, target_state, event, guard, action).
transition(init, error_diagnosis, init_crash, 'information must be logged', 'init_error_msg').
transition(error_diagnosis, init, retry_init, 'if retry does not exceed 3', null).
transition(error_diagnosis, safe_shutdown, shutdown, 'if retry is 3', null).
transition(safe_shutdown, dormant, sleep, null, null).
transition(idle, error_diagnosis, idle_crash, null, 'idle_err_msg').
transition(error_diagnosis, idle, idle_rescue, null, null).
transition(monitoring, error_diagnosis, monitor_crash, null, 'moni_err_msg').
transition(error_diagnosis, monitoring, monitor_rescue, null, null).





