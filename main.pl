% Práctica 2: Programación ISO-Prolog
:-module(_,_).

% Ejemplo 1: cierre([eslabon(a,b), eslabon(b,c), eslabon(c,d), eslabon(d, a)], X).
% Ejemplo 2: cierre([eslabon(c, b), eslabon(c, d), eslabon(a, b), eslabon(e, b), eslabon(d, b), eslabon(a, e)], X).
% Ejemplo 3: cierreMinimo([eslabon(c, b), eslabon(c, d), eslabon(a, b), eslabon(e, b), eslabon(d, b), eslabon(a, e)], Min).
% Ejemplo 4: cierreMinimo([eslabon(a,b), eslabon(b,c), eslabon(c,a)], Min).
% Ejemplo 5: cierreUnico([eslabon(c,b), eslabon(c,d), eslabon(a,b), eslabon(e,b), eslabon(d,b), eslabon(a,e)], Cierre).
% Ejemplo 6: cierreUnico([eslabon(a,b), eslabon(b,c), eslabon(c,a)], Cierre).

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
    findUnique(Result, [], Salida),
    member(Cierre, Salida).

findUnique([], Acc, Salida):-
    Acc = Salida.
findUnique([Elemento | T], Acc, Salida) :-
    inAcc(Elemento, Acc, Acc, NewAcc),
    findUnique(T, NewAcc, Salida).

inAcc(Elemento, [], Acc, Salida) :-
    append([Elemento], Acc, Salida).
inAcc(Elemento, [X | T], Acc, Salida) :-
    is_sublist(Elemento, X).
inAcc(Elemento, [X | T], Acc, Salida) :-
    \+ is_sublist(Elemento, X),
    inAcc(Elemento, T, Acc, Salida).

is_sublist([X], List) :-
    length([X], L1),
    length(List, L2),
    L1 == L2,
    member(X, List).
is_sublist([X | T], List) :-
    length([X | T], L1),
    length(List, L2),
    L1 == L2,
    member(X, List),
    delete(List, X, List1),
    is_sublist(T, List1).