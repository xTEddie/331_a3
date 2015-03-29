%% Author: Edward Tran & Peter Boulos

%% Rules

%% 1.
is_loop(Event, Guard) :- transition(State, State, Event, Guard, _).

%% 2.
all_loops(Set) :- findall((Event,Guard), transition(State, State, Event, Guard, _), List), list_to_set(List, Set). 

%% 3.
is_edge(Event, Guard) :- transition(_, _ , Event, Guard , _).

%% 4.
size(Length) :- findall(Event, is_edge(Event, _), List), length(List, Length). 

%% 5.
is_link(Event, Guard) :- transition(S1, S2 , Event, Guard , _), S1 \== S2.

%% 6.
all_superstates(Set) :- findall(Superstate, superstate(Superstate, _), List), list_to_set(List, Set).

%% 7.
ancestor(Ancestor, Descendant) :- superstate(Ancestor, Descendant).

%% 8.
inherits_transitions(State, List) :- findall((State, S, Event, Guard, Action), transition(State, S, Event, Guard, Action), List).

%% 9.
all_states(L) :- findall(State, state(State), L).

%% 10.
all_init_states(L) :- findall(InitState, initial_state(InitState, _), L).

%% 11.
get_starting_state(State) :- initial_state(State, _). %%

%% 12.
state_is_reflexive(State) :- transition(State, State, _, _, _).

%% 13.
graph_is_reflexive(false). %%

%% 14.
get_guards(Set) :- findall(Guard, transition(_, _, _, Guard, _), List), list_to_set(List, Set).

%% 15.
get_events(Set) :- findall(Event, transition(_, _, Event, _, _), List), list_to_set(List, Set).

%% 16.
get_actions(Set) :- findall(Action, transition(_, _, _, _, Action), List), list_to_set(List, Set).

%% 17.
get_only_guarded(Ret) :- findall((S1, S2), transition(S1, S2, _, _, Guard), Ret), Guard \== null. 

%% 18.
legal_events_of(State, L) :- findall((Event,Guard), (transition(State, _, Event, Guard, _);transition(_, State, Event, Guard, _)), L). 