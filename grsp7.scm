;; =============================================================================
;;
;; grsp7.scm
;;
;; Geometry.
;;
;; =============================================================================
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
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public License
;;   along with this program. If not, see <https://www.gnu.org/licenses/>.
;;
;; =============================================================================


;;;; General notes:
;; - Read sources for limitations on function parameters.
;;
;; Sources:
;; - [1] En.wikipedia.org. 2021. Approximations of π - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Approximations_of_%CF%80
;;   [Accessed 6 September 2021].
;; - [2] En.wikipedia.org. 2021. Plücker's conoid - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Pl%C3%BCcker%27s_conoid
;;   [Accessed 21 November 2021].
;; - [3] En.wikipedia.org. 2021. Saddle point - Wikipedia. [online] Available
;;   at: https://en.wikipedia.org/wiki/Saddle_point [Accessed 21 November 2021].
;; - [4] En.wikipedia.org. 2021. List of complex and algebraic surfaces -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_complex_and_algebraic_surfaces
;;   [Accessed 21 November 2021].
;; - [5] En.wikipedia.org. 2021. Dupin cyclide - Wikipedia. [online] Available
;;   at: https://en.wikipedia.org/wiki/Dupin_cyclide [Accessed 21 November 2021].


(define-module (grsp grsp7)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:export (grsp-geo-circle
	    grsp-geo-spherev
	    grsp-geo-triangle
	    grsp-geo-rectangle
	    grsp-geo-line
	    grsp-geo-slope
	    grsp-geo-cylinder
	    grsp-geo-cylinderv
	    grsp-geo-pyramid
	    grsp-geo-pyramidv
	    grsp-geo-pi-machin
	    grsp-geo-pi-shanks1
	    grsp-geo-pi-shanks2
	    grsp-geo-pi-atan
	    grsp-geo-pluecker-conoid
	    grsp-geo-hyperbolic-paraboloid
	    grsp-geo-monkey-saddle
	    grsp-geo-conev
	    grsp-ellyptic-cyclide))


;;;; grsp-geo-circle - Area of a circle.
;;
;; Keywords:
;; - geometry, curves.
;;
;; Arguments:
;; - p_r1: radius.
;;
(define (grsp-geo-circle p_r1)
  (let ((res1 0))

    (set! res1 (* (grsp-pi) (expt p_r1 2)))

    res1))


;;;; grsp-geo-spherev - Volume of a sphere.
;;
;; Keywords:
;; - geometry, curves, volume.
;;
;; Arguments:
;; - p_r1: radius.
;;
(define (grsp-geo-spherev p_r1)
  (let ((res1 0))

    (set! res1 (* (/ 4 3)
		  (grsp-pi) (expt p_r1 3)))

    res1))


;;;; grsp-geo-triangle - Area of a triangle.
;;
;; Keywords:
;; - geometry.
;;
;; Arguments:
;; - p_x1: base.
;; - p_y1: height.
;;
(define (grsp-geo-triangle p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (* p_x1 p_y1 (/ 1 2)))
    
    res1))


;;;; grsp-geo-rectangle - Area of a rectangle.
;;
;; Arguments:
;; - p_x1: base.
;; - p_y1: height.
;;
(define (grsp-geo-rectangle p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (* p_x1 p_y1))
    
    res1))


;;;; grsp-geo-line - Length of a segment (hypotenuse).
;;
;; Keywords:
;; - geometry.
;;
;; Arguments:
;; - p_x1.
;; - p_y1.
;; - p_x2.
;; - p_y2.
;;
(define (grsp-geo-line p_x1 p_y1 p_x2 p_y2)
  (let ((res1 0))

    (set! res1 (sqrt (+ (expt (- p_x2 p_x1) 2) (expt (- p_y2 p_y1) 2))))
    
    res1))


;;;; grsp-geo-slope - Slope of a line. 
;;
;; Keywords:
;; - geometry.
;;
;; Arguments:
;; - p_x1.
;; - p_y1.
;; - p_x2.
;; - p_y2.
;;
;; Notes:
;; - If dx is zero, it returns +/- inf.
;;
(define (grsp-geo-slope p_x1 p_y1 p_x2 p_y2)
  (let ((res1 0)
	(dx 0)
	(dy 0))

    (set! dx (- p_x2 p_x1))
    (set! dy (- p_y2 p_y1))
    (cond ((= dx 0)
	   (cond ((>= dy 0)
		  (set! res1 +inf.0))
		 ((< dy 0)
		  (set! res1 -inf.0))))
	  (else (set! res1 (/ dy dx))))

    res1))


;;;; grsp-geo-cylinder - Surface area of a cylinder.
;;
;; Keywords:
;; - geometry.
;;
;; Arguments:
;; - p_x1: base radius.
;; - p_y1: height.
;;
(define (grsp-geo-cylinder p_x1 p_y1)
  (let ((res1 0))

	(set! res1 (+ (* 2 (grsp-geo-circle p_x1)) (* 2 (grsp-pi) p_x1 p_y1)))
    
	res1))


;;;; grsp-geo-cylinderv - Volume of a cylinder.
;;
;; Keywords:
;; - geometry.
;;
;; Arguments:
;; - p_x1: base radius.
;; - p_y1: height.
;;
(define (grsp-geo-cylinderv p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (* (grsp-geo-circle p_x1) p_y1))
    
    res1))


;;;; grsp-geo-pyramid - Surface area of a pyramid.
;;
;; Keywords:
;; - geometry.
;;
;; Arguments:
;; - p_a1: base area.
;; - p_y1: height.
;;
(define (grsp-geo-pyramid p_a1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (expt p_a1 2) (* 4 (/ (* p_a1 p_y1) 2))))
    
    res1))


;;;; grsp-geo-pyramidv - Volume of a pyramid.
;;
;; Keywords:
;; - geometry.
;;
;; Arguments:
;; - p_a1: base area.
;; - p_y1: height.
;;
(define (grsp-geo-pyramidv p_a1 p_y1)
  (let ((res1 0))

    (set! res1 (* (/ 1 3) p_a1 p_y1))
    
    res1))

;;;; grsp-geo-pi-machin - Approximates pi using the original John Machin's
;; formula.
;;
;; Keywords:
;; - geometry, pi.
;;
;; Sources:
;; - [1].
;;
(define (grsp-geo-pi-machin)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    (set! res2 (* 4 (atan (/ 1 5))))
    (set! res3 (atan (/ 1 239)))

    ;; Compose result.
    (set! res1 (* 4 (- res2 res3)))

    res1))


;;;; grsp-geo-pi-shanks1 - Approximates pi using the original Shanks' formula.
;;
;; Keywords:
;; - geometry, pi.
;;
;; Sources:
;; - [1].
;;
(define (grsp-geo-pi-shanks1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))

    (set! res2 (* 6 (atan (/ 1 8))))
    (set! res3 (* 2 (atan (/ 1 57))))
    (set! res4 (atan (/ 1 239)))

    ;; Compose result.
    (set! res1 (* 4 (+ res2 res3 res4)))

    res1))


;;;; grsp-geo-pi-shanks2 - Approximates pi using Shanks' control formula.
;;
;; Keywords:
;; - geometry, pi.
;;
;; Sources:
;; - [1].
;;
(define (grsp-geo-pi-shanks2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))

    (set! res2 (* 12 (atan (/ 1 18))))
    (set! res3 (* 8 (atan (/ 1 57))))
    (set! res4 (* 5 (atan (/ -1 239))))

    ;; Compose result.
    (set! res1 (* 4 (+ res2 res3 res4)))

    res1))


;;;; grsp-geo-pi-atan - Approximates pi as a simple atan product.
;;
;; Keywords:
;; - geometry, pi.
;;
;; Sources:
;; - [1].
;;
(define (grsp-geo-pi-atan)
  (let ((res1 0.0))

    (set! res1 (* 4.0 (atan 1.0)))

    res1))


;;;; grsp-geo-pluecker-conoid - Pluecker's conoid function.
;;
;; Keywords:
;; - geometry, conoids.
;;
;; Arguments:
;; - p_x1: x
;; - p_y1: y.
;;
;; Sources:
;; - [2].
;;
(define (grsp-geo-pluecker-conoid p_x1 p_y1)
  (let ((res1 0.0))

    (set! res1 (/ (* 2.0 p_x1 p_y1) (+ (expt p_x1 2) (expt p_y1 2))))
    
    res1))


;;;; grsp-geo-hyperbolic-paraboloid - Hyperbolic paraboloid function.
;;
;; Keywords:
;; - geometry, saddle, surface, hyperbolic, paraboloid.
;;
;; Arguments:
;; - p_x1: x
;; - p_y1: y.
;;
;; Sources:
;; - [3][4].
;;
(define (grsp-geo-hyperbolic-paraboloid p_x1 p_y1)
  (let ((res1 0.0))

    (set! res1 (grsp-opz (- (expt p_x1 2) (expt p_y1 2))))
    
    res1))


;;;; grsp-geo-monkey-saddle - Monkey saddle function.
;;
;; Keywords:
;; - geometry, saddle, surface, hyperbolic, paraboloid.
;;
;; Arguments:
;; - p_x1: x
;; - p_y1: y.
;;
;; Sources:
;; - [3][4].
;;
(define (grsp-geo-monkey-saddle p_x1 p_y1)
  (let ((res1 0.0))

    (set! res1 (grsp-opz (- (expt p_x1 3) (* 3 p_x1 (expt p_y1 2)))))
    
    res1))


;;;; grsp-geo-conev - Volume of a cone.
;;
;; Keywords:
;; - geometry, volume.
;;
;; Arguments:
;; - p_ab: base area.
;; - p_h1: height.
;;
(define (grsp-geo-conev p_ab p_h1)
  (let ((res1 0))

    (set! res1 (* (grsp-1n 3.0) p_ab p_h1))
    
    res1))


;;;; grsp-geo-ellyptic-cyclide - Calculates x, y and y values for an ellyptic
;; cyclide.
;;
;; Keywords:
;; - geometry, topology.
;;
;; Arguments:
;; - p_a1: a. Axis.
;; - p_b1: b. Axis.
;; - p_c1: c. Linear eeccentricity.
;; - p_d1: d. Axis.
;; - p_u1: u. [0, 2Pi).
;; - p_v1: v. [0, 2Pi).
;;
;; Notes:
;; - TODO: more testing.
;;
;; Output:
;; - A list containing x, y, z values.
;;
;; Sources:
;; - [5].
;;
(define (grsp-ellyptic-cyclide p_a1 p_b1 p_c1 p_d1 p_u1 p_v1)
  (let ((res1 '())
	(x1 0)
	(y1 0)
	(z1 0)
	(c1 0)
	(c2 0)
	(c3 0))

    (set! c2 (* (cos p_u1) (cos p_v1)))
    (set! c3 (- p_a1 c2))

    ;; x.
    (set! x1 (/ (+ (* p_d1 (- p_c1 (* p_a1 c2)))
		   (* (expt p_b1 2) (cos p_u1))) c3))
    
    ;; y.
    (set! y1 (/ (- p_b1 (sin (* p_u1 (- p_a1 (- p_d1 (cos p_v1)))))) c3))
    
    ;; z.
    (set! z1 (/ (* p_b1 (sin (* p_v1 (- (* p_c1 (cos p_u1)) p_d1)))) c3))

    ;; Compose results.
    (set! res1 (list x1 y1 z1))

    res1))
