% Práctica 2: Programación ISO-Prolog
:-module(_,_).

% Ejemplo 1: cierre([eslabon(a,b), eslabon(b,c), eslabon(c,d), eslabon(d,a)], X).
% Ejemplo 2: cierre([eslabon(c, b), eslabon(c, d), eslabon(a, b), eslabon(a, b), eslabon(e, b), eslabon(d, b), eslabon(a, e)], X).

alumno_prode(lopez, merlin, jaime, t110296).
alumno_prode(copado, redondo, sergio, t110040).
alumno_prode(calle, ruiz, javier, v130126).

cierre(ListaSinRepeticiones, ListaCerrada):- %cierre/2
    comprobarListaSinRepeticiones(ListaSinRepeticiones),
    iniciar(ListaSinRepeticiones).

comprobarListaSinRepeticiones([]) :- !.
comprobarListaSinRepeticiones([X | T]):-
    comprobarRepetidos(X, T),
    comprobarListaSinRepeticiones(T).

comprobarRepetidos(_, []).
comprobarRepetidos(eslabon(As, Bs), [eslabon(A, B) | T]):-
    eslabon(As, Bs) \= eslabon(B, A),
    comprobarRepetidos(eslabon(As, Bs), T).

iniciar(ListaSinRepeticiones) :-
    member(eslabon(A, B), ListaSinRepeticiones),
    delete(ListaSinRepeticiones, eslabon(A, B), ListaSinBase),
    buscar(A, B, ListaSinBase, [eslabon(A, B)]),
    iniciar(ListaSinBase).

buscar(A, B, [eslabon(As, Bs) | T], Acc) :-
    member(A, [As, Bs]),
    delete([As, Bs], A, [Siguiente | _]),
    append(Acc, [eslabon(As, Bs)], NewAcc),
    comprobarCierre(B, Siguiente),
    buscar(B, Siguiente, T, NewAcc).
buscar(A, B, [eslabon(As, Bs) | T], Acc) :-
    member(B, [As, Bs]),
    delete([As, Bs], B, [Siguiente | _]),
    append(Acc, [eslabon(As, Bs)], NewAcc),
    comprobarCierre(A, Siguiente),
    buscar(A, Siguiente, T, NewAcc).
buscar(A, B, [eslabon(As, Bs) | T], Acc) :-
    \+ member(A, [As, Bs]),
    \+ member(B, [As, Bs]),
    buscar(A, B, T, Acc).

comprobarCierre(A, B) :-
    A == B.
comprobarCierre(A, B) :-
    A \= B.