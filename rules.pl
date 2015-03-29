%% Part VI
is_loop(Event, Guard) :- transition(State, State, Event, Guard, _).
all_loops(Set) :- findall((Event,Guard), transition(State, State, Event, Guard, _), List), list_to_set(List, Set). 
is_edge(Event, Guard) :- transition(_, _ , Event, Guard , _).
size(Length) :- findall(Event, is_edge(Event, _), List), length(List, Length). 
is_link(Event, Guard) :- transition(S1, S2 , Event, Guard , _), S1 \== S2.
all_superstates(Set) :- findall(Superstate, superstate(Superstate, _), List), list_to_set(List, Set).
ancestor(Ancestor, Descendant) :- superstate(Ancestor, Descendant).
inherits_transitions(State, List) :- findall((State, S, Event, Guard, Action), transition(State, S, Event, Guard, Action), List).
all_states(L) :- findall(State, state(State), L).
all_init_states(L) :- findall(InitState, initial_state(InitState, _), L).
get_starting_state(State) :- initial_state(State, _). %%
state_is_reflexive(State) :- transition(State, State, _, _, _).
graph_is_reflexive(false). %%
get_guards(Set) :- findall(Guard, transition(_, _, _, Guard, _), List), list_to_set(List, Set).
get_events(Set) :- findall(Event, transition(_, _, Event, _, _), List), list_to_set(List, Set).
get_actions(Set) :- findall(Action, transition(_, _, _, _, Action), List), list_to_set(List, Set).
get_only_guarded(Ret) :- findall((S1, S2), transition(S1, S2, _, _, Guard), Ret), Guard \== null. 
legal_events_of(State, L) :- findall((Event,Guard), (transition(State, _, Event, Guard, _);transition(_, State, Event, Guard, _)), L). 