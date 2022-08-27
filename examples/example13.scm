#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example13.scm
;;
;; A sample of grsp functions. This program creates a matrix of three columns
;; and a user-define number of rows. Fills the first two colums with random
;; values and the third one with the sum of the other two.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example13.scm 
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


;; Required modules.
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

 
;; Vars.
(define tm 100)
(define tn 3)
(define i1 0)
(define t1 "")

;; Main program.
(clear)

;; Create strictly row diagonally dominant matrix with random values.
(newlines 1)
(display "Creating matrix...")
(define A (grsp-matrix-create "#rprnd" tm tn))

;; Calculate sum.
(set! i1 (grsp-lm A))
(while (<= i1 (grsp-hm A))
       (array-set! A (+ (array-ref A i1 0) (array-ref A i1 1)) i1 2)
       (set! i1 (in i1)))

;; Create table name for database.
(set! t1 "A_example13.csv")

;; Create database.
(grsp-mc2dbc-csv "database.csv" A t1)

;; Display matrix
(newlines 1)
(display "Matrix A:")
(newlines 1)
(grsp-matrix-display A)
(newlines 1)




