%% Author: Edward Tran & Peter Boulos

%% Facts

%% Top-level states
state(dormant).
state(init).
state(monitoring).
state(lockdown).
state(error_diagnosis).

%%
state(idle).
state(safe_shutdown).

%% States under init state
state(boot_hw).
state(senchk).
state(tchk).
state(psichk).
state(ready).

%% States under monitoring state
state(monidle).
state(regulate_environment).

%% States under lockdown state
state(prep_vpurge).
state(alt_temp).
state(alt_psi).
state(risk_assess).
state(safe_status).

%% States under error_diagnosis state
state(error_rcv).
state(applicable_rescue).
state(reset_module_data).

%% initial_state(S1, S2) : S1 is initial state of S2
initial_state(dormant, null).
initial_state(boot_hw, init).
initial_state(monidle, monitoring).
initial_state(error_rcv, error_diagnosis).
initial_state(prep_vpurge, lockdown).

%%superstate(S1, S2) : S1 is superstate of S2
superstate(init, boot_hw).
superstate(init, senchk).
superstate(init, tchk).
superstate(init, psichk).
superstate(init, ready).
superstate(error_diagnosis, error_rcv).
superstate(error_diagnosis, applicable_rescue).
superstate(error_diagnosis, reset_module_data).
superstate(monitoring, monidle).
superstate(monitoring, regulate_environment).
superstate(monitoring, lockdown).
superstate(lockdown, prep_vpurge).
superstate(lockdown, alt_temp).
superstate(lockdown, alt_psi).
superstate(lockdown, risk_assess).
superstate(lockdown, safe_status).


event(kill).
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
event(moni_rescue).

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
transition(error_diagnosis, init, retry_init, 'return < 3', 'increment retry').
transition(error_diagnosis, safe_shutdown, shutdown, 'retry >= 3', null).
transition(safe_shutdown, dormant, sleep, null, 'retry = 0').
transition(init, idle, init_ok, null, null);
transition(idle, error_diagnosis, idle_crash, null, 'idle_err_msg').
transition(error_diagnosis, idle, idle_rescue, null, null).
transition(idle, monitoring, begin_monitoring, null, null).
transition(monitoring, error_diagnosis, monitor_crash, 'inlockdown = false', 'moni_err_msg').
transition(error_diagnosis, monitoring, moni_rescue, null, null).

transition(boot_hw, senchk, hw_ok, null, null).
transition(senchk, tchk, senok, null, null).
transition(tchk, psichk, t_ok, null, null).
transition(psichk, ready, psi_ok, null, null).
transition(monidle, regulate_environment, no_contagion, 'received no contagion', null)
transition(regulate_environment, monidle, after_100ms, null, null).
transition(monidle, lockdown, contagion_alert, null, 'FACILITY_CRIT_MSG, inlockdown = true').
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


%% Part VI
is_loop(Event, Guard) :- transition(State, State, Event, Guard, _). %%
all_loops(Set) :- findall(State, transition(State, State, _, _, _), List), list_to_set(List, Set). %% 
is_edge(Event, Guard) :- transition(Event, _ , _ , Guard , _) ; transition(_, _ , Event, Guard, _). %%
size(Length) :- findall(Event, is_edge(Event, _), List), length(List, Length). %%
is_link(Event, Guard) :- is_edge(Event, Guard). %%
ancestor(Ancestor, Descendant) :- superstate(Ancestor, Descendant).

all_superstates(Set) :- findall(Superstate, superstate(Superstate, _), List), list_to_set(List, Set).
all_states(L) :- findall(State, state(State), L).
all_init_states(L) :- findall(InitState, initial_state(InitState, _), L).
get_guards(Set) :- findall(Guard, transition(_, _, _, Guard, _), List), list_to_set(List, Set).
get_events(Set) :- findall(Event, transition(_, _, Event, _, _), List), list_to_set(List, Set).
get_actions(Set) :- findall(Action, transition(_, _, _, _, Action), List), list_to_set(List, Set).