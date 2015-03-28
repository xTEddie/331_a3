%% Superstates
state(dormant).
state(init).
state(idle).
state(monitoring).

event(kill).

initial_state(dormant).

state(error_diagnosis).
state(safe_shutdown).

state(boot_hw).
state(senchk).
state(tchk).
state(psichk).
state(ready).

state(monidle).
state(regulate_environment).
state(lockdown).

state(prep_vpurge).
state(alt_temp).
state(alt_psi).
state(risk_assess).
state(safe_status).

state(error_rcv).
state(applicable_rescue).
state(reset_module_data).

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

event(hw_ok).
event(senok).
event(t_ok).
event(psi_ok).

event(no_contagion).
event(contagion_alert).
event(after_100ms).
event(purge_succ).

event(initiate_purge).
event(tcyc_comp).
event(psicyc_comp).

event(apply_protocol_rescues).
event(reset_to_stable).

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

transition(monidle, regulate_environment, no_contagion, 'received no contagion', null).
transition(regulate_environment, monidle, after_100ms, null, null).
transition(monidle, lockdown, contagion_alert, null, 'FACILITY_CRIT_MSG').
transition(monidle, lockdown, contagion_alert, null, 'inlockdown = true').
transition(lockdown, lockdown, null, 'inlockdown = true', null).
transition(lockdown, monidle, purge_succ, null, 'inlockdown = false').

transition(prep_vpurge, alt_temp, initiate_purge, null, 'lock_doors').
transition(prep_vpurge, alt_psi, initiate_purge, null, 'lock_doors').
transition(alt_temp, risk_assess, tcyc_comp, null, null).
transition(alt_psi, risk_assess, psicyc_comp, null, null).
transition(risk_assess, prep_vpurge, null, 'risk > 1%', null).
transition(risk_assess, safe_status, null, 'risk < 1%', 'unlock_doors').

transition(error_rcv, applicable_rescue, apply_protocol_rescues, 'err_protocol_def = true', null).
transition(error_rcv, reset_module_data, reset_to_stable, 'error_protocol_def = false', null).







