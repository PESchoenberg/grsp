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


; Required modules.
(use-modules (grsp grsp0)
	     (grsp grsp1))


; Remember what this program is about (optional).
(define q "This program shows the use of grsp functions.")


; Start.
(newlines 20)
(ptit "=" 60 2 q)

; pline
(ptit " " 1 1 "1 - pline samples:")
(pline "-" 20)
(pline "*" 40)
(pline "=" 60)

; ptit
(ptit " " 1 1 "2 - ptit samples")
(ptit "*" 60 1 "ptit function with 1 line of '*', 60 in length.")
(ptit "/" 40 2 "ptit function with 2 lines of '/', 40 in length.")


; gconst
(ptit " " 1 0 "3 - gconst samples and use of newlines and pres functions:")
(newlines 1)
(pres "Pi" (number->string (gconst "Pi")))
(pres "gr" (number->string (gconst "gr")))


; newspaces
(ptit " " 1 0 "4 - newspaces examples:")
(newlines 1)
(display (newspaces 1 "One blank left" 0))
(newlines 1)
(display (newspaces 1 "One blank right" 1))
(newlines 1)
(display (newspaces 5 "Five blanks left" 0))
(newlines 1)
(display (newspaces 5 "Five blanks right" 1))
(newlines 1)
(display (newspaces 10 "Ten blanks left" 0))
(newlines 1)
(display (newspaces 10 "Ten blanks right" 1))
(newlines 1)
(display (newspaces 20 "Twenty blanks left" 0))
(newlines 1)
(display (newspaces 20 "Twenty blanks right" 1))
(newlines 1)


; strings-append
(ptit " " 1 0 "5 - strings-append examples:")
(newlines 1)
(display (strings-append (list "This" "text" "has" "no" "spaces") 0))
(newlines 1)
(display (strings-append (list "This" "text" "has" "spaces") 1))
(newlines 1)
(define res "")
(set! res (strings-append (list "SELECT" "*" "FROM" "sde_facts" "WHERE" "Item =" "'counter1'") 1))
(display res)
(newlines 1)

; Environment (interpreter ) version analysis.
(ptit " " 1 1 "6 - Version:")
(newline)
(display "Your current GNU Guile version is ")
(display (version))
(display " and your current effective version is ")
(display (effective-version))
(newlines 2)

(define ver 1.8)
(display (strings-append (list "Regarding effective version " (number->string ver) " your Scheme effective version is: ") 0))
(newline)
(display "Lower? ")
(display (grsp-lang-effective-version "lt" ver))
(newline)
(display "Equal? ")
(display (grsp-lang-effective-version "eq" ver))
(newline)
(display "Higher? ")
(display (grsp-lang-effective-version "ht" ver))
(newlines 2)

(set! ver 2.0)
(display (strings-append (list "Regarding version " (number->string ver) " your Scheme version is: ") 0))
(newline)
(display "Lower? ")
(display (grsp-lang-effective-version "lt" ver))
(newline)
(display "Equal? ")
(display (grsp-lang-effective-version "eq" ver))
(newline)
(display "Higher? ")
(display (grsp-lang-effective-version "ht" ver))
(newlines 2)

(set! ver 2.2)
(display (strings-append (list "Regarding version " (number->string ver) " your Guile Scheme version is: ") 0))
(newline)
(display "Lower? ")
(display (grsp-lang-effective-version "lt" ver))
(newline)
(display "Equal? ")
(display (grsp-lang-effective-version "eq" ver))
(newline)
(display "Higher? ")
(display (grsp-lang-effective-version "ht" ver))
(newlines 2)


