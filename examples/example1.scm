#! /usr/local/bin/guile -s
!#


; ==============================================================================
;
; example1.scm
;
; A sample of grsp0 functions.
;
; Compilation:
;
; - cd to your /examples folder.
;
; - Enter the following:
;
;   guile example1.scm 
;
; ==============================================================================
;
; Copyright (C) 2018  Pablo Edronkin (pablo.edronkin at yahoo.com)
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU Lesser General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU Lesser General Public License for more details.
;
;   You should have received a copy of the GNU Lesser General Public License
;   along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
; ==============================================================================


; Reqired modules.
(use-modules (grsp grsp0))


; Remember what this program is about (optional).
(define q "This program shows the use of grsp functions.")


; Start.
(newlines 20)
(ptit "=" 60 2 q)

; pline
(ptit " " 1 1 "pline samples")
(pline "-" 20)
(pline "*" 40)
(pline "=" 60)

; ptit
(ptit " " 1 1 "ptit samples")
(ptit "*" 60 1 "ptit function with 1 line of '*', 60 in length.")
(ptit "/" 40 2 "ptit function with 2 lines of '/', 40 in length.")





