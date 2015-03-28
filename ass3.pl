%% Superstates
state(dormant).
state(init).
state(idle).
state(monitoring).

event(kill).

initial_state(dormant).

state(error_diagnosis).
state(safe_shutdown).

event(start).
event(init_ok).
event(init_crash). 
event(retry_init). 
event(shutdown). 
event(sleep). 
event(idle_crash). 
event(idle_rescue).
event(begin_monitoring).
event(monitor_crash). 
event(monitor_rescue).

event(boot_hw).
event(senchk).
event(tchk).
event(psichk).
event(ready).

%% transition(source_state, target_state, event, guard, action).
transition(dormant, init, start, null, null).
transition(init, error_diagnosis, init_crash, null, 'init_error_msg').
transition(error_diagnosis, init, retry_init, '[if retry does not exceed 3]', 'increment retry').
transition(error_diagnosis, safe_shutdown, shutdown, 'if retry is 3', null).
transition(safe_shutdown, dormant, sleep, null, null).
transition(init, idle, init_ok, null, null);
transition(idle, error_diagnosis, idle_crash, null, 'idle_err_msg').
transition(error_diagnosis, idle, idle_rescue, null, null).
transition(idle, monitoring, begin_monitoring, null, null).
transition(monitoring, error_diagnosis, monitor_crash, null, 'moni_err_msg').
transition(error_diagnosis, monitoring, monitor_rescue, null, null).

transition(boot_hw, senchk, hw_ok, null, null).
transition(senchk, tchk, senok, null, null).
transition(tchk, psichk, t_ok, null, null).
transition(psichk, ready, psi_ok, null, null).





