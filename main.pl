% Práctica 2: Programación ISO-Prolog
:-module(_,_).

% Ejemplo: cierre([eslabon(a,b), eslabon(b,c), eslabon(c,d), eslabon(d,a)], X).

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

    conectarPrimerEslabon(Eslabon, ListaSinElemento, Salida),

    recorrerLista(ListaSinRepeticiones, NuevaListaPorRecorrer, ListaCerrada).

cogerElemento([eslabon(A, B) | T], Eslabon, Salida) :-
    eslabon(A, B) = Eslabon,
    T = Salida.

sacarElemento(eslabon(A,B), Lista, NuevaLista) :-
    delete(Lista, eslabon(A,B), NuevaLista).

conectarPrimerEslabon(eslabon(A, B), [eslabon(As, Bs) | T], Acc) :-
    puedeConectar([A, B], [As, Bs], Cabeza, Siguiente),
    append([eslabon(A, B)], [eslabon(As, Bs)], Acc),
    buscarListaCerrada(Cabeza, Siguiente, T, Acc).
conectarPrimerEslabon(eslabon(A, B), [eslabon(As, Bs) | T], Salida) :-
    \+ puedeConectar([A, B], [As, Bs], Cabeza, Siguiente),
    conectarPrimerEslabon(eslabon(A, B), T, Salida).

buscarListaCerrada(Cabeza, Siguiente, [eslabon(A, B) | T], Acc) :-
    conectarSiguiente(Siguiente, [A, B], NewSiguiente),
    append(Acc, [eslabon(A, B)], NewAcc),
    comprobarCierre(Cabeza, NewSiguiente).
buscarListaCerrada(Cabeza, Siguiente, [eslabon(A, B) | T], Acc) :-
    \+ conectarSiguiente(Siguiente, [A, B], NewSiguiente),
    buscarListaCerrada(Cabeza, Siguiente, T).

conectarSiguiente(Siguiente, List, NewSiguiente) :-
    member(Siguiente, List),
    delete(List, Siguiente, [NewSiguiente | _]).

comprobarCierre(Cabeza, Siguiente) :-
    Cabeza == Siguiente.
comprobarCierre(Cabeza, Siguiente) :-
    Cabeza \= Siguiente.

puedeConectar([A, B], List, Cabeza, Siguiente) :-
    member(A, List),
    delete(List, A, [Siguiente | _]),
    B = Cabeza.
puedeConectar([A, B], List, Cabeza, Siguiente) :-
    member(B, List),
    delete(List, B, [Siguiente | _]),
    A = Cabeza.