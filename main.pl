% Práctica 2: Programación ISO-Prolog
:-module(_,_).

% Ejemplo 1: cierre([eslabon(a,b), eslabon(b,c), eslabon(c,d), eslabon(d,a)], X).
% Ejemplo 2: cierre([eslabon(c, b), eslabon(c, d), eslabon(a, b), eslabon(a, b), eslabon(e, b), eslabon(d, b), eslabon(a, e)], X).

alumno_prode(lopez, merlin, jaime, t110296).
alumno_prode(copado, redondo, sergio, t110040).
alumno_prode(calle, ruiz, javier, v130126).

cierre(ListaSinRepeticiones, ListaCerrada):- %cierre/2
    comprobarListaSinRepeticiones(ListaSinRepeticiones),
    recorrerLista(ListaSinRepeticiones, ListaSinRepeticiones, ListaCerrada).

comprobarListaSinRepeticiones([]) :- !.
comprobarListaSinRepeticiones([X | T]):-
    comprobarRepetidos(X, T),
    comprobarListaSinRepeticiones(T).

comprobarRepetidos(_, []).
comprobarRepetidos(eslabon(As, Bs), [eslabon(A, B) | T]):-
    eslabon(As, Bs) \= eslabon(B, A),
    comprobarRepetidos(eslabon(As, Bs), T).

recorrerLista(_, [], ListaCerrada).
recorrerLista(ListaSinRepeticiones, ListaPorRecorrrer, ListaCerrada) :-
    cogerElemento(ListaPorRecorrrer, Eslabon, NuevaListaPorRecorrer),
    sacarElemento(Eslabon, ListaSinRepeticiones, ListaSinElemento),

    conectarPrimerEslabon(ListaSinElemento, Eslabon, ListaSinElemento, Salida, ListaCerrada),

    recorrerLista(ListaSinRepeticiones, NuevaListaPorRecorrer, ListaCerrada).

cogerElemento([eslabon(A, B) | T], Eslabon, Salida) :-
    eslabon(A, B) = Eslabon,
    T = Salida.

sacarElemento(eslabon(A,B), Lista, NuevaLista) :-
    delete(Lista, eslabon(A,B), NuevaLista).

conectarPrimerEslabon(ListaSinBase, eslabon(A, B), [eslabon(As, Bs) | T], Salida, ListaCerrada) :-
    puedeConectar([A, B], [As, Bs], Cabeza, Siguiente),
    append([eslabon(A, B)], [eslabon(As, Bs)], Acc),
    sacarElemento(ListaSinBase, eslabon(As, Bs), ListaSinBaseNiConectado),
    buscarListaCerrada(ListaSinBaseNiConectado, Cabeza, Siguiente, T, Acc, ListaCerrada),

    conectarPrimerEslabon(ListaSinBase, eslabon(A, B), T, Salida, ListaCerrada).
conectarPrimerEslabon(ListaSinBase, eslabon(A, B), [eslabon(As, Bs) | T], Salida, ListaCerrada) :-
    \+ puedeConectar([A, B], [As, Bs], Cabeza, Siguiente),
    conectarPrimerEslabon(ListaSinBase, eslabon(A,B), T, Salida, ListaCerrada).

puedeConectar([A, B], List, Cabeza, Siguiente) :-
    member(A, List),
    delete(List, A, [Siguiente | _]),
    B = Cabeza.
puedeConectar([A, B], List, Cabeza, Siguiente) :-
    member(B, List),
    delete(List, B, [Siguiente | _]),
    A = Cabeza.

buscarListaCerrada(Lista, Cabeza, Siguiente, [eslabon(A, B) | T], Acc, ListaCerrada) :-
    