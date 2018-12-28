; ==============================================================================
;
; grsp0.scm
;
; Some useful functions for GNU Guile Scheme programs.
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


(define-module (grsp grsp0)
  ;#:use-module ()
  #:export (pline
	    ptit
	    newlines))


; pline - displays character p_n p_m times in one line at the console.
;
; Arguments:
; - p_c: line character to display.
; - p_l: line length.
;
(define (pline p_c p_l)
  (let ((str ""))
    (let loop ((i 0))
      (if (= i p_l)
	  (begin (newline)(newline)(display str)(newline)(newline))
	  (begin (set! str (string-append str p_c))
	         (loop (+ i 1))
	  )
      )
    )
  )
)


; ptit - displays a console title surrounded by one or two lines.
;
; Arguments:
; - p_c: line character to display.
; - p_l: line length.
; - p_n: number of lines (1 or 2, defaults to 1 line above title).
; - p_t: title to display.
;
(define (ptit p_c p_l p_n p_t)
  (if (<= p_n 1)(pline p_c p_l))
  (if (>= p_n 2)(pline p_c p_l))
  (display p_t)
  (if (>= p_n 2)(pline p_c p_l))
  (newline)
)


; newlines - repeats function newline p_n times.
;
; Arguments:
; - p_n: numbr of iterations.
;
(define (newlines p_n)
  (let loop ((i 0))
    (if (<= i p_n)
	(begin (newline)
	       (loop (+ i 1))
	)
    )
  )
)






