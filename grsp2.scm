; ==============================================================================
;
; grsp2.scm
;
; Math procedures.
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
;   along with this program. If not, see <https://www.gnu.org/licenses/>.
;
; ==============================================================================


(define-module (grsp grsp2)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:export (grsp-ps3bl1
	    grsp-sexp
	    grsp-slog))


; grsp-ps3bl1 - Pseudo tri-boolean 1. Provides a pseudo trinary result.
;
; Arguments: 
; - p_n: number.
;
; Output:
; - Retuns -1, 0 or 1 depending on the number being less than, equal or 
;   reater than zero
;
(define (grsp-ps3bl1 p_n)
  (let ((res 0))
    (cond ((equal? p_n 0)(set! res 0))
	  ((> p_n 0)(set! res 1))
	  ((< p_n 0)(set! res -1)))
    res))


; grsp-sexp - Performs a non-recursive tetration operation on p_x of height
; p_n. sexp stands for super exponential.
;
; Arguments;
; - p_x: base.
; - p_n: rank or height of the power tower.
;
; Note:
; - This operation might have a significant impact on the performance of your 
;   computer due to its very fast function growth. Use with care.
;
; Sources:
; - En.wikipedia.org. (2020). Hyperoperation. [online] Available at:
;   https://en.wikipedia.org/wiki/Hyperoperation [Accessed 1 Jan. 2020].
;
(define (grsp-sexp p_x p_n)
  (let ((x p_x)
	(n p_n)
	(i 1)
	(res 0))
    (cond ((= n 0)(set! res 1))
	  ((< n 0)(set! res 0))
	  ((> n 0)(begin (set! res x)
			 (while (< i n)
				(set! res (expt x res))
				(set! i (+ i 1))))))
    res))


; grsp-slog - Performs a non-recursive super logarithm operation on p_x of height
; p_n.
;
; Arguments;
; - p_x: base.
; - p_n: rank or height of the power tower of the super exponentiation for which.
;   grsp-slog is inverse.
;
; Note:
; - This operation might have a significant impact on the performance of your 
;   computer due to its very fast function growth. Use with care.
;
(define (grsp-slog p_x p_n)
  (let ((res 0))
     (set! res (/ 1 (grsp-sexp p_x p_n)))
     res))




