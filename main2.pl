% Práctica 2: Programación ISO-Prolog
:-module(_,_).

% Ejemplo 1: cierre([eslabon(a,b), eslabon(b,c), eslabon(c,d), eslabon(d,a)], X).
% Ejemplo 2: cierre([eslabon(c, b), eslabon(c, d), eslabon(a, b), eslabon(e, b), eslabon(d, b), eslabon(a, e)], X).

alumno_prode(lopez, merlin, jaime, t110296).
alumno_prode(copado, redondo, sergio, t110040).
alumno_prode(calle, ruiz, javier, v130126).

cierre(ListaSinRepeticiones, ListaCerrada):- %cierre/2
    iniciar(ListaSinRepeticiones, ListaSinRepeticiones, ListaCerrada).

comprobarListaSinRepeticiones([]) :- !.
comprobarListaSinRepeticiones([X | T]):-
    comprobarRepetidos(X, T),
    comprobarListaSinRepeticiones(T).

comprobarRepetidos(_, []).
comprobarRepetidos(eslabon(As, Bs), [eslabon(A, B) | T]):-
    eslabon(As, Bs) \= eslabon(B, A),
    comprobarRepetidos(eslabon(As, Bs), T).

iniciar(_, [], _).
iniciar(ListaSinRepeticiones, RecorrerLista, ListaCerrada) :-
    member(eslabon(A, B), RecorrerLista),
    delete(ListaSinRepeticiones, eslabon(A, B), ListaSinBase),
    delete(RecorrerLista, eslabon(A,B), RecorrerResto),
    buscar(B, A, ListaSinBase, [eslabon(A, B)], ListaCerrada),
    buscar(A, B, ListaSinBase, [eslabon(A, B)], ListaCerrada),
    iniciar(ListaSinRepeticiones, RecorrerResto, ListaCerrada).

buscar(_, _, [], _, _).
buscar(A, B, [eslabon(As, Bs) | T], Acc, ListaCerrada) :-
    member(B, [As, Bs]),
    delete([As, Bs], B, [Siguiente | _]),
    append(Acc, [eslabon(As, Bs)], NewAcc),
    comprobarCierre(A, Siguiente, NewAcc, ListaCerrada),
    \+ ground(ListaCerrada),
    buscar(A, Siguiente, T, NewAcc, ListaCerrada).
buscar(A, B, [eslabon(As, Bs) | T], Acc, ListaCerrada) :-
    \+ member(B, [As, Bs]),
    buscar(A, B, T, Acc, ListaCerrada).

comprobarCierre(A, B, Acc, ListaCerrada) :-
    A == B,
    Acc = ListaCerrada,
    !.
comprobarCierre(A, B, Acc, ListaCerrada) :-
    A \= B.