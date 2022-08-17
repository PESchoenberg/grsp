#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example4.scm
;;
;; A sample of grsp functions. This program shows how function grsp-matrix-opmm
;; works.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example4.scm 
;;
;; ==============================================================================
;;
;; Copyright (C) 2018 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
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


;; Main program
(clear)

;; Create matrices.
(define M1 (grsp-matrix-create 0 2 2))
(array-set! M1 1 0 0)
(array-set! M1 2 0 1)
(array-set! M1 3 1 0)
(array-set! M1 4 1 1)

(define M2 (grsp-matrix-create 0 2 2))
(array-set! M2 0 0 0)
(array-set! M2 5 0 1)
(array-set! M2 6 1 0)
(array-set! M2 7 1 1)

;; Calculate and display results.
(display "\n")
(display "\nMatrix 1:\n")
(display M1)
(display "\n")
(display "\nMatrix 2:\n")
(display M2)
(display "\n")
(display "\nMatrix sum:\n")
(display (grsp-matrix-opmm "#(+)" M1 M2))
(display "\n")
(display "\nMatrix substraction:\n")
(display (grsp-matrix-opmm "#(-)" M1 M2))
(display "\n")
(display "\nMatrix multiplication:\n")
(display (grsp-matrix-opmm "#(+)" M1 M2))
(display "\n")
(display "\nMatrix pseudo-division:\n")
(display (grsp-matrix-opmm "#(+)" M1 M2))
(display "\n")
(display "\nKronecker product:\n")
(display (grsp-matrix-opmm "#(*)" M1 M2))
(display "\n")
(display "\nKronecker sum:\n")
(display (grsp-matrix-opmm "#(+)" M1 M2))
(display "\n")
