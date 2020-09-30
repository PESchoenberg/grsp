;; =============================================================================
;;
;; grsp4.scm
;;
;; Complex number functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2020  Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;   along with this program. If not, see <https://www.gnu.org/licenses/>.
;;
;; =============================================================================


;; Sources:
;; - [1] Gnu.org. 2020. Complex (Guile Reference Manual). [online] Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Complex.html
;;   [Accessed 24 July 2020].
;; - [2] https://en.wikipedia.org/wiki/Mandelbrot_set
;; - [3] https://en.wikipedia.org/wiki/Feigenbaum_constants

(define-module (grsp grsp4)
  #:use-module (grsp grsp2)
  #:export (grsp-complex-inv-imag
	    grsp-complex-inv-real
	    grsp-complex-inv
	    grsp-complex-sign
	    grsp-complex-logistic
	    grsp-complex-mandelbrot))
  

;; grsp-complex-inv-imag - Calculates the inverse of the imaginary component of a
;; complex number.
;;
;; Arguments:
;; - p_v1: complex number.
;;
;; Output:
;; - The conjugate of p_v1 (imaginary part negated).
;;
;; Sources:
;; - [1].
;;
(define (grsp-complex-inv-imag p_v1)
  (let ((res1 0)
	(vr 0)
	(vi 0))

    (cond ((complex? p_v1)
	   (set! vr (real-part p_v1))
	   (set! vi (* -1 (imag-part p_v1)))
	   (set! res1 (make-rectangular vr vi)))
	  (else((set! res1 p_v1))))

    res1))


;; grsp-complex-inv-real - Calculates the inverse of the real component of a
;; complex number.
;;
;; Arguments:
;; - p_v1: complex number.
;;
;; Sources:
;; - [1].
;;
(define (grsp-complex-inv-real p_v1)
  (let ((res1 0)
	(vr 0)
	(vi 0))

    (cond ((complex? p_v1)
	   (set! vr (* -1 (real-part p_v1)))
	   (set! vi (imag-part p_v1))
	   (set! res1 (make-rectangular vr vi)))
	  (else((set! res1 (* -1 p_v1)))))

    res1))


;; grsp-complex-inv - Calculates various inverses of complex numbers.
;;
;; Arguments:
;; - p_s1: operation.
;;   - "#si": inverts the imaginary component only.
;;   - "#is": inverts the real component only.
;;   - "#ii": inverts both.
;; - p_v1: complex number.
;;
;; Sources:
;; - [1].
;;
(define (grsp-complex-inv p_s1 p_v1)
  (let ((res1 p_v1)
	(vr 0)
	(v 0))

    (cond ((equal? p_s1 "#si")
	   (set! res1 (grsp-complex-inv-imag res1)))
	  ((equal? p_s1 "#is")
	   (set! res1 (grsp-complex-inv-real res1)))
	  ((equal? p_s1 "#ii")
	   (set! res1 (grsp-complex-inv-imag res1))
	   (set! res1 (grsp-complex-inv-real res1))))	  

    res1))


;; grsp-complex-sign - Returns a list containing boolean values indicating the  
;; signs of the real and imaginary parts of a complex number.
;;
;; Arguments:
;; - p_n1: complex number.
;;
;; Output:
;; - (1 1) if both components are positive or real is positive and imaginary is
;;   zero.
;; - (-1 -1) if both components are negative.
;; - (-1 1) if the real component is negative and the imaginary positive or zero.
;; - (1 -1) if the real component is positive and the imaginary is negative.
;;
;; Sources:
;; - [1].
;;
(define (grsp-complex-sign p_v1)
  (let ((res1 '())
	(vr 0)
	(vi 0))

    (cond ((complex? p_v1)
	   (set! vr (grsp-sign (real-part p_v1)))
	   (set! vi (grsp-sign (imag-part p_v1))))	  
	  (else((set! vr (grsp-sign p_v1))
		(set! vi 1))))
    (set! res1 (list vr vi))
    
    res1))


;; grsp-complex-logistic - Logistic map equation. Pseudo-random number
;; generator.
;;
;; Arguments:
;; - p_r1: growth rate.
;; - p_x1
;;
;; Sources:
;; - [2][3].
;;
(define (grsp-complex-logistic p_r1 p_x1)
  (let ((res1 0))

    (set! res1 (* p_r1 (* p_x1 (- 1 p_x1))))

    res1))


;; grsp-complex-mandelbrot - Quadratic map function for the Mandelbrot set.
;;
;; Arguments:
;; - p_z1
;; - p_c1
;;
;; Sources:
;; - [2][3].
;;
(define (grsp-complex-mandelbrot p_z1 p_c1)
  (let ((res1 0))

    (set! res1 (+ (expt p_z1 2) p_c1))

    res1))


