;; =============================================================================
;;
;; grsp14.scm
;;
;; Date and time related functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2021 - 2023 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;
;; - Read sources for limitations on function parameters.


(define-module (grsp grsp14)
  #:use-module (grsp grsp0)
  #:use-module (srfi srfi-19)  
  #:export (grsp-date-is-m29
	    grsp-date-is-m31
	    grsp-date-dl
	    grsp-date-nextm
	    grsp-date-eot-calc
	    grsp-date-ldm3m))


;;;; grsp-date-is-m29 - See if february has 29 days the year of query.
;;
;; Keywords:
;;
;; - date, time, calendar, chronology, strings
;;
;; Parameters:
;;
;; - p_y1: year.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-date-is-m29 p_y1)
  (let ((res1 #f)
	(bis 2020)
	(dif 0))

    (set! dif (abs (- p_y1 bis)))
    (cond ((integer? (/ dif 4))
	   (set! res1 #t)))

    res1))


;;;; grsp-date-is-m31 - Returns #t if month p_m1 has 31 days, #f otherwise.
;;
;; Keywords:
;;
;; - date, time, calendar, chronology, strings
;;
;; Parameters:
;;
;; - p_y1: year.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-date-is-m31 p_m1)
  (let ((res1 #f))
    (cond ((or (= p_m1 1)
	       (= p_m1 3)
	       (= p_m1 5)
	       (= p_m1 7)
	       (= p_m1 8)
	       (= p_m1 10)
	       (= p_m1 12))
	   (set! res1 #t)))

    res1))


;;;; grsp-date-dl - Calculates the number of days in month p_m1 of year p_y1.
;;
;; Keywords:
;;
;; - date, time, calendar, chronology, strings
;;
;; Parameters:
;;
;; - p_m1: month.
;; - p_y1: year.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-date-dl p_m1 p_y1)
  (let ((res1 30))

    (cond ((equal? (grsp-date-is-m31 p_m1) #t)
	   (set! res1 31)))
    
    (cond ((equal? p_m1 2)
	   
	   (cond ((equal? (grsp-date-is-m29 p_y1) #t)
		  (set! res1 29))
		 (else (set! res1 28)))))

    res1))


;;;; grsp-date-nextm - Calculates the next month of month p_m1 in the same or
;; next year, if applicable.
;;
;; Keywords:
;;
;; - date, time, calendar, chronology, strings
;;
;; Parameters:
;;
;; - p_m1: month.
;; - p_y1: year.
;;
;; Output:
;;
;; - A list containing the next month and its applicable year
;;
;;   - Elem 0: month.
;;   - Elem 1: year.
;;
(define (grsp-date-nextm p_m1 p_y1)
  (let ((res1 '())
	(nm p_m1)
	(ny p_y1))

    (cond ((= nm 12)
	   (set! nm 1)
	   (set! ny (+ ny 1)))
	  (else (set! nm (+ nm 1))))

    ;; Compose results.
    (set! res1 (list nm ny))
    
    res1))


;;;; grsp-date-calc - Calculates dates corresponding to the last days of each
;; month of the current trimester.
;;
;; Keywords:
;;
;; - date, time, calendar, chronology, strings
;;
;; Output:
;;
;; - A list of three lists corresponding to the present month, the next one and
;;   the one following the next. Each one of hese lists contains:
;;
;;   - Elem 0: The number representing the month.
;;   - Elem 1: The year to which the month belongs to.
;;   - Elem 2: The number of days of the month.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-date-eot-calc)
  (let ((res1 '())
	(res2 '())
	(res3 '())
	(res4 '())
	(date1 (current-date))
	(d1 0)
	(m1 0)
	(y1 0)
	(dm1 0))
       
    ;; Current date.
    (set! d1 (date-day date1))
    (set! m1 (date-month date1))
    (set! y1 (date-year date1))

    ;; Find the number of days of current month.
    (set! dm1 (grsp-date-dl m1 y1))

    ;; Compose this mont data as a list.
    (set! res1 (list m1 y1 dm1))
    
    (let loop ((i1 2))
      (if (<= i1 3)
	  (begin (set! m1 (+ m1 1))
		 
		 (cond ((= m1 13)
			(set! m1 1)
			(set! y1 (+ y1 1))))
		 (set! dm1 (grsp-date-dl m1 y1))
		 
		 (cond ((= i1 2)
			(set! res2 (list m1 y1 dm1))))
		 
		 (cond ((= i1 3)
			(set! res3 (list m1 y1 dm1))))
		 
		 (loop (+ i1 1)))))
    
    ;; Compose results.
    (set! res4 (list res1 res2 res3))
	   
    res4))


;;;; grsp-date-ldm3m - For the current date, finds the same day numbers of the
;; two next months
;;
;; Keywords:
;;
;; - date, time, calendar, chronology, strings
;;
;; Output:
;;
;; - A list of three strings with dates for the present and two subsequent
;;   months.
;;
;;   - Elem 0: first trimestral date.
;;   - Elem 1: second trimestral date.
;;   - Elem 2: third trimestral date.
;;
(define (grsp-date-ldm3m)
  (let ((eot '())
	(t1 '())
	(t2 '())
	(t3 '())
	(d0 0)
	(d1 0)
	(d2 0)
	(d3 0)
	(m1 0)
	(m2 0)
	(m3 0)
	(y1 0)
	(y2 0)
	(y3 0)
	(s1 "/")
	(date1 (current-date))
	(res1 "")
	(res2 "")
	(res3 "")
	(res4 '()))

    ;; Current date.
    (set! d0 (date-day date1))
    
    ;; Find the last days of the trimester.
    (set! eot (grsp-date-eot-calc))

    ;; Extract each element from eot.
    (set! t1 (car eot))
    (set! t2 (cadr eot))
    (set! t3 (caddr eot))

    ;; Extract the limits of the two following months from the
    ;; respective eot elements.
    (set! d2 (caddr t2))
    (set! d3 (caddr t3))

    ;; Extract month numbers.
    (set! m1 (car t1))
    (set! m2 (car t2))
    (set! m3 (car t3))    

    ;; Extract years.
    (set! y1 (cadr t1))
    (set! y2 (cadr t2))
    (set! y3 (cadr t3))

    ;; Compare current day number to the limits of the two following
    ;; months.
    (set! d1 d0)
    
    (cond ((<= d0 d2)
	   (set! d2 d0)))
    
    (cond ((<= d0 d3)
	   (set! d3 d0)))

    ;; Create date strings.
    (set! res1 (strings-append (list (grsp-n2s d1)
				     s1
				     (grsp-n2s m1)
				     s1
				     (grsp-n2s y1))
			       0))
    (set! res2 (strings-append (list (grsp-n2s d2)
				     s1
				     (grsp-n2s m2)
				     s1
				     (grsp-n2s y2))
			       0))
    (set! res3 (strings-append (list (grsp-n2s d3)
				     s1
				     (grsp-n2s m3)
				     s1
				     (grsp-n2s y3))
			       0))    
 
    ;; Compose results.
    (set! res4 (list res1 res2 res3))
    
    res4))

