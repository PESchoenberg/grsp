; ==============================================================================
;
; grsp0.scm
;
; Some useful, simple functions for GNU Guile Scheme programs created or   
; adapted during the development of several other projects.
;
; ==============================================================================
;
; Copyright (C) 2018 - 2019  Pablo Edronkin (pablo.edronkin at yahoo.com)
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


(define-module (grsp grsp0)
  #:export (pline
	    ptit
	    newlines
	    pres
	    newspaces
	    strings-append
	    read-file-as-string
	    grsp-lang-effective-version
	    grsp-test
	    grsp-save-to-file
	    grsp-n2s))


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
	         (loop (+ i 1)))))))


; ptit - displays a console title with one or two lines.
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
  (newline))


; newlines - repeats function newline p_n times.
;
; Arguments:
; - p_n: number of iterations.
;
(define (newlines p_n)
  (let loop ((i 0))
    (if (<= i p_n)
	(begin (newline)
	       (loop (+ i 1))))))


; pres - dispay results.
;
; Arguments:
; - p_s1: reference, string.
; - p_s2: result, string
;
(define (pres p_s1 p_s2)
  (let ((res " "))
    (set! res (string-append p_s1 (string-append " = " p_s2)))
      (display res)
      (newline)))


; newspaces - adds p_n blank spaces to string p_l.
;
; Arguments:
; - p_n: number of blanks to add.
; - p_l: string to display.
; - p_s: side where to add spaces
;   - 0 for left side.
;   - 1 for right side.
;
(define (newspaces p_n p_l p_s)
  (let ((res " ")
	(sp ""))
    (let loop ((i 0))
      
      ; Create a string of blanks.
      (if (< i p_n)
	  (begin (set! sp (string-append sp " "))
		 (loop (+ i 1)))))
      
      ; Add the blank string.
      (if (= p_s 0)
  	  (set! res (string-append sp p_l)))
      (if (= p_s 1)
	  (set! res (string-append p_l sp)))
      res))


; strings-append - appends strings entered in a list as one larger string. Use 
; it to avoid complex, nested calls to string-append when you have to join 
; several strings into one.
;
; Arguments:
; - p_l: list of strings.
; - p_s: add a blank space after each list element.
;   - 0 for no spaces.
;   - 1 to add one blank space.
;
(define (strings-append p_l p_s)
  (let ((res "")
	(elem #f))
    (set! elem (car p_l))
    (while (not (equal? elem #f))
	   (if (equal? p_s 1)(set! elem (string-append elem " ")))
	   (set! res (string-append res elem))
	   (set! p_l (cdr p_l))
	   (if (> (length p_l) 0)(set! elem (car p_l)))
	   (if (= (length p_l) 0)(set! elem #f)))
    res))


; read-file-as-string - reads a file as a string; adapted from an example 
; from sources indicated below. The string will be formatted and include 
; characters such as \n and \r. What this does in practice is to read a 
; file and return it as one single string. 
;
; Arguments:
; - p_f: file name.
;
; Sources:
; - http://www.shido.info/lisp/scheme9_e.html
;
(define (read-file-as-string p_f)
  (call-with-input-file p_f
    (lambda (p)
      (let loop((ls1 '()) (c (read-char p)))
	(if (eof-object? c)
	    (begin
	      (close-input-port p)
	      (list->string (reverse ls1)))
	    (loop (cons c ls1) (read-char p)))))))


; Checks if currently instaled GNU Guile's effective version is less, equal or 
; higher than value of the version argument vakue.
;
; Arguments:
; - p_s: enter the one of the following strings.
;   - "lt" less than.
;   - "eq" equal to.
;   - "ht" higher than.
; - p_v: version number to check against.
;
; Output:
; - Boolean. Defaults to #f if p_s is entered incorrectly.
;
(define (grsp-lang-effective-version p_s p_v)
  (let ((res #f)
	(ev (string->number (effective-version))))
    (if (equal? p_s "lt")(set! res (< ev p_v)))
    (if (equal? p_s "eq")(set! res (= ev p_v)))
    (if (equal? p_s "ht")(set! res (> ev p_v)))
    res))


; grsp-test - a simple test function.
;
(define (grsp-test)
  (display "grsp-test"))
	      

; grsp-save-to-file - saves a string to file p_f.   
;	   
; Arguments: 
; - p_s: string to save.
; - p_f: file.
; - p_m: save mode.
;  - "w": open for input. Rewrite if exists.
;  - "a": open for append. Create if does not exist.
;
; Sources;
; - https://www.gnu.org/software/guile/manual/html_node/File-Ports.html
;
(define (grsp-save-to-file p_s p_f p_m)
  (let ((output-port (open-file p_f "a")))
    (display p_s output-port)
    (newline output-port)
    (close output-port)))

; grsp-n2s - a convenience function, shorter to write than number->string that
; performs the same function. That is, to convert a number to a string.
;
; Arguments:
; p_n: number to convert.
;
(define (grsp-n2s p_n)
  (let ((res ""))
    (set! res (number->string p_n))))


