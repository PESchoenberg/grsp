#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example7.scm
;;
;; A sample of grsp functions. This program shows how function 
;; grsp-matrix-create-fix works by creating a few quantum gate matrices.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example7.scm 
;;
;; ==============================================================================
;;
;; Copyright (C) 2018 - 2023 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public License
;;   along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;; ==============================================================================


; Required modules.
(use-modules (grsp grsp0)
	     (grsp grsp1)
	     (grsp grsp2)
	     (grsp grsp3)
	     (grsp grsp4)
	     (grsp grsp5)
	     (grsp grsp6)
	     (grsp grsp7)
	     (grsp grsp8)
	     (grsp grsp9)
	     (grsp grsp10)
	     (grsp grsp11)
	     (grsp grsp12)
	     (grsp grsp13)
	     (grsp grsp14)
	     (grsp grsp15))


;; Vars
(define i1 0)
(define M 0)
(define z1 30.0+0.0i)
(define s1 "")
(define L (list "#X" "#Y" "#Z" "#QI" "#H" "#P" "#S" "#T" "#TDG" "#CX" "#CY" "#CZ"))
(define hn (length L))

	   
;; Main program
(clear)
(while (< i1 hn)

       (set! s1 (list-ref L i1))
       (set! M (grsp-matrix-create-fix s1 z1))
       (newlines 1)
       (display "Matrix of quantum gate:")
       (display s1)
       (newlines 1)
       (grsp-matrix-display M)
       (newlines 2)
       
       (set! i1 (in i1)))


