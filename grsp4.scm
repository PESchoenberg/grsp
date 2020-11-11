;; =============================================================================
;;
;; grsp4.scm
;;
;; Complex functions.
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
;; - [2] En.wikipedia.org. 2020. Mandelbrot Set. [online] Available at:
;;   https://en.wikipedia.org/wiki/Mandelbrot_set [Accessed 4 October 2020].
;; - [3] En.wikipedia.org. 2020. Feigenbaum Constants. [online] Available at:
;;   https://en.wikipedia.org/wiki/Feigenbaum_constants
;;   [Accessed 5 October 2020].

(define-module (grsp grsp4)
  #:use-module (grsp grsp1)  
  #:use-module (grsp grsp2)
  #:export (grsp-complex-inv-imag
	    grsp-complex-inv-real
	    grsp-complex-inv
	    grsp-complex-sign
	    grsp-complex-logistic
	    grsp-complex-mandelbrot
	    grsp-complex-binet
	    grsp-complex-dirichlet-eta
	    grsp-complex-f1))
  

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


;; grsp-complex-binet - Closed form expression of the Fibonacci sequence. It
;; provides as a result the p_n1th value of the Fibonnaci series. 
;;
;; - p_n1: ordinal of the desired Fibonacci number.
;;
;; Sources:
;; - En.wikipedia.org. 2020. Fibonacci Number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Fibonacci_number#Binet's_formula
;;   [Accessed 5 November 2020].
;;
(define (grsp-complex-binet p_n1)
  (let ((res1 0)
	(g1 (gconst "A001622")))

    (set! res1 (/ (- (expt g1 p_n1) (expt (- 1 g1) p_n1)) (sqrt 5)))

    res1))


;; grsp-complex-dirichlet-eta - Dirichlet eta function.
;;
;; Arguments:
;; - p_s1: s.
;; - p_l1: iterations.
;;
;; Sources:
;; - En.wikipedia.org. 2020. Dirichlet Eta Function. [online] Available at:
;;   https://en.wikipedia.org/wiki/Dirichlet_eta_function
;;   [Accessed 10 November 2020].
;;
(define (grsp-complex-dirichlet-eta p_s1 p_l1)
  (let ((res1 0)
	(n1 1))

    (while (< n1 p_l1)
	   (set! res1 (+ res1 (/ (expt -1 (- n1 1)) (expt n1 p_s1))))
	   (set! n1 (+ n1 1)))

    res1))


;; grsp-complex-f1 - Calculates (p_a1 * (p_x1 ** p_n1)) / (1 + (p_a2 (p_x1 ** p_b2)))
;;
;; Arguments:
;; - p_a1
;; - p_a2
;; - p_x1
;; - p_x2
;; - p_n1
;; - p_n2
;;
(define (grsp-complex-f1 p_a1 p_a2 p_x1 p_n1 p_n2)
  (let ((res1 0))

    (set! res1 (/ (* p_a1 (expt p_x1 p_n1)) (+ 1 (* p_a2 (expt p_x1 p_n2)))))

    res1))
