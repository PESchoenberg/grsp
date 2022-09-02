#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example16.scm
;;
;; A sample of grsp functions. Created a matrix that has numerical strings as
;; pinters to text files, then it creates those files and then reads them.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example16.scm 
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
(define A (grsp-matrix-create 0 2 2))
(define fa "A_example16.txt")
(define fb "B_example16.txt")
(define db "database.csv/")
(define fpa "")
(define fpb "")
(define sa "Arthur Dent is a friend of Ford Prefect.")
(define sb "Ford Prefect has a white towel.")
(define i1 0)
(define hm 0)
(define s1 "")
(define la '())
(define lb '())

;; Main program.
(clear)
(newlines 1)

(display "Creating files...")
(set! fpa (string-append db fa))
(set! fpb (string-append db fb))
(array-set! A 0 0 0)
(array-set! A 1 1 0)
(array-set! A (grsp-s2dbc fpa) 0 1)
(array-set! A (grsp-s2dbc fpb) 1 1)
(grsp-save-to-file sa fpa "w")
(grsp-save-to-file sb fpb "w")


;; Display matrix
(newlines 1)
(display "Matrix A: first col shows a primary key. Second column shows an utc-numeric pointer to a file.")
(newlines 1)
(grsp-matrix-display A)
(newlines 1)


;; Read files.
(set! la (grsp-dbc2lls A (grsp-lm A) 1))
(set! lb (grsp-dbc2lls A (grsp-hm A) 1))

;; Display the contents of the text files associated to matrix A.
(display "Text of first file:")
(newlines 1)
(display (list-ref la 1))
(newline)
(display "Found at: ")
(newlines 1)
(display (list-ref la 0))
(newlines 2)

(display "Text of second file:")
(newlines 1)
(display (list-ref lb 1))
(newline)
(display "Found at: ")
(newlines 1)
(display (list-ref lb 0))
(newlines 2)
      



