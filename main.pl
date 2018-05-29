% Práctica 2: Programación ISO-Prolog
:-module(_,_).

alumno_prode(lopez, merlin, jaime, t110296).
alumno_prode(copado, redondo, sergio, t110040).
alumno_prode(calle, ruiz, javier, v130126).

cierre(ListaSinRepeticiones, ListaCerrada):- %cierre/2
    comprobarListaSinRepeticiones(ListaSinRepeticiones),
    recorrerLista(ListaSinRepeticiones, ListaSinRepeticiones, ListaCerrada).

comprobarListaSinRepeticiones([]).
comprobarListaSinRepeticiones([X | T]):-
    comprobarRepetidos(X, T),
    comprobarListaSinRepeticiones(T).

comprobarRepetidos(_, []).
comprobarRepetidos(eslabon(As, Bs), [eslabon(A, B) | T]):-
    eslabon(As, Bs) \= eslabon(B, A),
    comprobarRepetidos(eslabon(As, Bs), T).

recorrerLista(ListaSinRepeticiones, ListaPorRecorrrer, ListaCerrada) :-
    cogerElemento(ListaPorRecorrrer, Eslabon, NuevaListaPorRecorrer),
    sacarElemento(Eslabon, ListaSinRepeticiones, ListaSinElemento),

    buscarListaCerrada(Eslabon, ListaSinElemento, Salida),

    recorrerLista(ListaSinRepeticiones, NuevaListaPorRecorrer, ListaCerrada).

cogerElemento([eslabon(A, B) | T], Eslabon, Salida) :-
    eslabon(A, B) = Eslabon,
    T = Salida.

sacarElemento(eslabon(A,B), Lista, NuevaLista) :-
    delete(Lista, eslabon(A,B), NuevaLista).

buscarListaCerrada(eslabon(A, B), [eslabon(As, Bs) | T], Salida) :-
    isMember([A, B], [As, Bs]).

buscarListaCerrada(eslabon(A, B), [eslabon(As, Bs) | T], Salida) :-
    \+ isMember([A, B], [As, Bs]).

isMember(List1, [As, Bs]) :-
    member(As, List1).
isMember(List1, [As, Bs]) :-
    member(Bs, List1).