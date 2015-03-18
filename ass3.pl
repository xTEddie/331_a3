state(dormant).
state(init).
state(idle).
state(monitoring).

initial_state(dormant).

%% transitions(source_state, target_state, event, guard, msg).
transitions(init, error_diagnosis, init_crash, 'information must be logged', 'init_error_msg').



