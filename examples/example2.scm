#! /usr/local/bin/guile -s
!#


; ==============================================================================
;
; example2.scm
;
; A sample of grsp0 and grsp1 functions.
;
; Compilation:
;
; - cd to your /examples folder.
;
; - Enter the following:
;
;   guile example2.scm 
;
; ==============================================================================
;
; Copyright (C) 2018 - 2022  Pablo Edronkin (pablo.edronkin at yahoo.com)
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
(use-modules (grsp grsp0)
	     (grsp grsp1))


; Remember what this program is about (optional).
(define q "This program shows the use of grsp functions.")


; Start.
(newlines 20)
(ptit "=" 60 2 q)


; pline
(ptit " " 1 1 "1 - reading file example1.scm as a string:")
(define a (read-file-as-string "example1.scm"))
(newline)
(display a)
(newlines 2)

