% question(1)

multiple_lines(S):- line(X), line(Y), X\==Y, stop(X, _, S), stop(Y, _, S).


% question(2)

non_termini(L, E):- stop(L, E1, _), E1 > E.
termini(L, S1, S2):- stop(L, 1, S1), stop(L, E, S2), \+non_termini(L, E).


% question(3)

isort(Line, [], []).
isort(Line, [H|T], L) :- isort(Line, T, Ts), insert(Line, H, Ts, L).

insert(Line, X, [H|T], [H|Ti]) :- stop(Line, E1, X), stop(Line, E2, H), E1 > E2, !, insert(Line, X, T, Ti).
insert(Line, X, L, [X|L]).

list_stops(Line, List):- findall(S, stop(Line, _, S), First_list), isort(Line, First_list, List).


% question(4)

member_of_path(segment(Line, _, _), [segment(Line, _, _)|_]).
member_of_path(segment(Line, _, _), [_|T]):- member_of_path(segment(Line, _, _), T).

station_traversed(S, [segment(L,S1,S2)|_]):- stop(L, N, S), stop(L, N1, S1), stop(L, N2, S2), N1 =< N, N < N2, N1 =< N2.
station_traversed(S, [_|R]):- station_traversed(S, R).

stations_traversed(Path, Stations):- findall(X, station_traversed(X, Path), Stations).

segment_adds_cycle(segment(L, S1, S2), Path):- station_traversed(S, [segment(L, S1, S2)]), stations_traversed(Path, Stations), member(S, Stations).

path(S1, S2, Path):- path_helper(S1, S2, [], Path).

path_helper(S1, S2, Attempted_path, Path):- stop(X, N1, S1), stop(X, N2, S2), N1 < N2, 
									\+ member_of_path(segment(X, S1, S2), Attempted_path),
									\+ segment_adds_cycle(segment(X, S1, S2), Attempted_path),
									Path = [segment(X, S1, S2)].
path_helper(S1, S2, Attempted_path, Path):- stop(X, N1, S1), stop(X, N_Middle, S_Middle), N1 < N_Middle, 
									\+ member_of_path(segment(X, S1, S_Middle), Attempted_path),
									\+ segment_adds_cycle(segment(X, S1, S_Middle), Attempted_path),
									path_helper(S_Middle, S2, [segment(X, S1, S_Middle)|Attempted_path], Tail_path),
									Path = [segment(X, S1, S_Middle)|Tail_path].
	
	
% question(5)

minimum_path(S1,S2,Path) :- setof((Length, Path), (path(S1, S2, Path), length(Path, Length)), AllPaths),
							nth0(0, AllPaths, MinPath),
							more_paths(AllPaths, MinPath, Path).
	
more_paths([(Len, Pat)|_], (Min,_), Path) :- Len == Min, Path = Pat.
more_paths([_|T], MinPath, Path) :- more_paths(T, MinPath, Path).
