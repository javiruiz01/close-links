% Práctica 2: Programación ISO-Prolog
:-module(_,_).

% Ejemplo 1: cierre([eslabon(a,b), eslabon(b,c), eslabon(c,d), eslabon(d, a)], X).
% Ejemplo 2: cierre([eslabon(c, b), eslabon(c, d), eslabon(a, b), eslabon(e, b), eslabon(d, b), eslabon(a, e)], X).
% Ejemplo 3: cierreMinimo([eslabon(c, b), eslabon(c, d), eslabon(a, b), eslabon(e, b), eslabon(d, b), eslabon(a, e)], Min).
% Ejemplo 4: cierreMinimo([eslabon(a,b), eslabon(b,c), eslabon(c,a)], Min).
% Ejemplo 5: cierreUnico([eslabon(c,b), eslabon(c,d), eslabon(a,b), eslabon(e,b), eslabon(d,b), eslabon(a,e)], Cierre).
% Ejemplo 6: cierreUnico([eslabon(a,b), eslabon(b,c), eslabon(c,d), eslabon(d, a)], Cierre).

alumno_prode(lopez, merlin, jaime, t110296).
alumno_prode(copado, redondo, sergio, t110040).
alumno_prode(calle, ruiz, javier, v130126).

cierre(ListaSinRepeticiones, ListaCerrada):- %cierre/2
    iniciar(ListaSinRepeticiones, ListaSinRepeticiones, ListaCerrada).

iniciar(_, [], ListaCerrada) :-
    ground(ListaCerrada).
iniciar(_, _, ListaCerrada) :-
    ground(ListaCerrada).
iniciar(ListaSinRepeticiones, RecorrerLista, ListaCerrada) :-
    member(eslabon(A, B), RecorrerLista),
    delete(ListaSinRepeticiones, eslabon(A, B), ListaSinBase),
    delete(RecorrerLista, eslabon(A,B), RecorrerResto),
    buscar(A, B, ListaSinBase, [eslabon(A, B)], ListaCerrada),
    iniciar(ListaSinRepeticiones, RecorrerResto, ListaCerrada).
iniciar(ListaSinRepeticiones, RecorrerLista, ListaCerrada) :-
    member(eslabon(A, B), RecorrerLista),
    delete(ListaSinRepeticiones, eslabon(A, B), ListaSinBase),
    delete(RecorrerLista, eslabon(A,B), RecorrerResto),
    buscar(B, A, ListaSinBase, [eslabon(A, B)], ListaCerrada),
    iniciar(ListaSinRepeticiones, RecorrerResto, ListaCerrada).

buscar(A, B, List, Acc, ListaCerrada) :-
    A == B,
    member(eslabon(B, X), List),
    append(Acc, [eslabon(B, X)], NewAcc),
    delete(List, eslabon(B, X), List2),
    buscar(A, X, List2, NewAcc, ListaCerrada).
buscar(A, B, List, Acc, ListaCerrada) :-
    A == B,
    member(eslabon(X, B), List),
    append(Acc, [eslabon(X, B)], NewAcc),
    delete(List, eslabon(X, B), List2),
    buscar(A, X, List2, NewAcc, ListaCerrada).
buscar(A, B, List, Acc, ListaCerrada) :-
    A == B,
    !,
    Acc = ListaCerrada.
buscar(A, B, [], Acc, ListaCerrada) :-
    A == B,
    !,
    Acc = ListaCerrada.
buscar(A, B, List, Acc, ListaCerrada) :-
    member(eslabon(B, X), List),
    append(Acc, [eslabon(B, X)], NewAcc),
    delete(List, eslabon(B, X), List2),
    buscar(A, X, List2, NewAcc, ListaCerrada).
buscar(A, B, List, Acc, ListaCerrada) :-
    member(eslabon(X, B), List),
    append(Acc, [eslabon(X, B)], NewAcc),
    delete(List, eslabon(X, B), List2),
    buscar(A, X, List2, NewAcc, ListaCerrada).

cierreMinimo(OriginalList, Min) :-
    findall(X, cierre(OriginalList, X), Result),
    findMin(Result, Min).

findMin([Elem], Min) :-
    length(Elem, Min).
findMin([Elem1, Elem2 | T], Min) :-
    length(Elem1, L1),
    length(Elem2, L2),
    L1 < L2,
    findMin([Elem1 | T], Min).
findMin([Elem1, Elem2 | T], Min) :-
    length(Elem1, L1),
    length(Elem2, L2),
    L1 >= L2,
    findMin([Elem2 | T], Min).

cierreUnico(OriginalList, Cierre) :-
    findall(X, cierre(OriginalList, X), Result),
    findUnique(Result, Cierre).

findUnique([], Cierre).
findUnique(_, Cierre) :-
    ground(Cierre).
findUnique([Elem | T], Cierre) :-
    recursive(Elem, T, Cierre),
    findUnique(T, Cierre).

recursive(_, _, Cierre) :-
    ground(Cierre).
recursive(Elem, [], Cierre).
recursive(Elem, [A | T], Cierre):-
    length(Elem, L1),
    length(A, L2),
    L1 == L2,
    is_sublist(Elem, A),
    recursive(Elem,  T, Cierre).
recursive(Elem, [A | T], Cierre):-
    length(Elem, L1),
    length(A, L2),
    L1 == L2,
    \+ is_sublist(Elem, A),
    !,
    Elem = Cierre,
    recursive(Elem, T, Cierre).
recursive(Elem, [A | T], Cierre):-
    length(Elem, L1),
    length(A, L2),
    L1 =\= L2,
    recursive(Elem,  T, Cierre).

is_sublist([], List).
is_sublist([X | T], List) :-
    member(X, List),
    delete(List, X, List1),
    is_sublist(T, List1).
