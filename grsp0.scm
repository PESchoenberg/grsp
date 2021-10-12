;; =============================================================================
;;
;; grsp0.scm
;;
;; Some useful, simple functions for GNU Guile Scheme programs created or   
;; adapted during the development of several other projects.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2021 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; - Compilation:
;;   - (use-modules (grsp grsp0)(grsp grsp1)(grsp grsp2)(grsp grsp3)(grsp grsp4)(grsp grsp5)(grsp grsp6)(grsp grsp7)(grsp grsp8)(grsp grsp9)(grsp grsp10)(grsp grsp11)(grsp grsp12)(grsp grsp13))
;;
;; Sources:
;; - [1] Shido.info. (2019). 9. IO. [online] Available at:
;;   http://www.shido.info/lisp/scheme9_e.html [Accessed 15 Sep. 2019].
;; - [2] Gnu.org. (2019). File Ports (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/File-Ports.html
;;   [Accessed 15 Sep. 2019].
;; - [3] Edronkin, P. (2019). sqlp - Simple terminal query and .sql file
;;   processing for  Sqlite3. [online] sqlp. Available at:
;;   https://peschoenberg.github.io/sqlp/ [Accessed 5 Oct. 2019].
;; - [4] Gnu.org. 2021. Dynamic Types (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Dynamic-Types.html
;;   [Accessed 1 October 2021].
;; - [5] Gnu.org. 2021. Data Types (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Data-Types.html
;;   [Accessed 1 October 2021].
;; - [6] Academic.oup.com. 2021. How the strengths of Lisp-family languages
;;   facilitate building complex and flexible bioinformatics applications.
;;   Bohdan B Khomtchouk, Edmund Weitz, Peter D Karp, Claes Wahlestedt.
;;   [online] Available at:
;;   https://academic.oup.com/bib/article-pdf/19/3/537/25603287/bbw130.pdf
;;   [Accessed 11 October 2021].


(define-module (grsp grsp0)
  #:export (pline
	    ptit
	    newlines
	    clear
	    pres
	    newspaces
	    strings-append
	    read-file-as-string
	    grsp-lang-effective-version
	    grsp-test
	    grsp-save-to-file
	    grsp-delete-file
	    grsp-n2s
	    grsp-s2n
	    grsp-sqlp
	    grsp-ld
	    grsp-cd
	    grsp-ask
	    grsp-placebo
	    in
	    de
	    grsp-argtype))


;;;; pline - Displays character p_n p_m times in one line at the console.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_c1: line character to display.
;; - p_l1: line length.
;;
(define (pline p_c1 p_l1)
  (let ((s1 ""))

    (let loop ((i1 0))
      (if (= i1 p_l1)
	  (begin (newlines 1)
		 (display s1)
		 (newlines 1))
	  (begin (set! s1 (string-append s1 p_c1))
	         (loop (+ i1 1)))))))


;;;; ptit - Displays a console title with one or two lines.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_c1: line character to display.
;; - p_l1: line length.
;; - p_n1: number of lines (1 or 2, defaults to 1 line above title).
;; - p_t1: title to display.
;;
(define (ptit p_c1 p_l1 p_n1 p_t1)
  (if (<= p_n1 1)
      (pline p_c1 p_l1))
  (if (>= p_n1 2)
      (pline p_c1 p_l1))
  (display p_t1)
  (if (>= p_n1 2)
      (pline p_c1 p_l1))
  (newline))


;;;; newlines - Repeats function newline p_n times.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_n: number of iterations.
;;
(define (newlines p_n1)
  (let loop ((i1 0))
    (if (<= i1 p_n1)
	(begin (newline)
	       (loop (+ i1 1))))))


;;;; clear - Clears the shell by inserting 100 blank lines.
;;
;; Keywords:
;; - console, strings.
;;
(define (clear)
  (newlines 100))


;;;; pres - Display results.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: reference, string.
;; - p_s2: result, string.
;;
(define (pres p_s1 p_s2)
  (let ((res1 " "))

    (set! res1 (string-append p_s1 (string-append " = " p_s2)))
      (display res1)
      (newline)))


;;;; newspaces - Adds p_n blank spaces to string p_l.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_n: number of blanks to add.
;; - p_l: string to display.
;; - p_s: side where to add spaces,
;;   - 0 for left side.
;;   - 1 for right side.
;;
(define (newspaces p_n1 p_l1 p_s1)
  (let ((res1 " ")
	(s1 ""))

    (let loop ((i1 0))
      
      ;; Create a string of blanks.
      (if (< i1 p_n1)
	  (begin (set! s1 (string-append s1 " "))
		 (loop (+ i1 1)))))
      
      ;; Add the blank string.
      (if (= p_s1 0)
  	  (set! res1 (string-append s1 p_l1)))
      (if (= p_s1 1)
	  (set! res1 (string-append p_l1 s1)))

      res1))


;;;; strings-append - Appends strings entered in a list as one larger string.
;; Use it to avoid complex, nested calls to string-append when you have to join 
;; several strings into one.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_l1: list of strings.
;; - p_s1: add a blank space after each list element.
;;   - 0 for no spaces.
;;   - 1 to add one blank space.
;;
(define (strings-append p_l1 p_s1)
  (let ((res1 "")
	(elem #f))

    (set! elem (car p_l1))
    (while (not (equal? elem #f))
	   (if (equal? p_s1 1)
	       (set! elem (string-append elem " ")))
	   (set! res1 (string-append res1 elem))
	   (set! p_l1 (cdr p_l1))
	   (if (> (length p_l1) 0)
	       (set! elem (car p_l1)))
	   (if (= (length p_l1) 0)
	       (set! elem #f)))

    res1))


;;;; read-file-as-string - Reads a file as a string; adapted from an example 
;; from sources indicated below. The string will be formatted and include 
;; characters such as \n and \r. What this does in practice is to read a 
;; file and return it as one single string. 
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_f1: file name.
;;
;; Sources:
;; - [1].
;;
(define (read-file-as-string p_f1)
  (call-with-input-file p_f1
    (lambda (p1)
      (let loop((ls1 '()) (c1 (read-char p1)))
	(if (eof-object? c1)
	    (begin
	      (close-input-port p1)
	      (list->string (reverse ls1)))
	    (loop (cons c1 ls1) (read-char p1)))))))


;;;; grsp-lang-effective-version - Checks if currently instaled GNU Guile's
;; effective version is less, equal or higher than value of the version
;; argument vakue.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: enter the one of the following strings.
;;   - "lt" less than.
;;   - "eq" equal to.
;;   - "ht" higher than.
;; - p_v1: version number to check against.
;;
;; Output:
;; - Boolean. Defaults to #f if p_s1 is entered incorrectly.
;;
(define (grsp-lang-effective-version p_s1 p_v1)
  (let ((res1 #f)
	(ev (string->number (effective-version))))

    (if (equal? p_s1 "lt")
	(set! res1 (< ev p_v1)))
    (if (equal? p_s1 "eq")
	(set! res1 (= ev p_v1)))
    (if (equal? p_s1 "ht")
	(set! res1 (> ev p_v1)))

    res1))


;;;; grsp-test - A simple test function.
;;
;; Keywords:
;; - console, strings.
;;
(define (grsp-test)
  (grsp-ld "grsp-test"))
	      

;;;; grsp-save-to-file - Saves a string to file p_f1.   
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments: 
;; - p_s1: string to save.
;; - p_f1: file.
;; - p_m1: save mode.
;;  - "w": open for input. Rewrite if exists.
;;  - "a": open for append. Create if does not exist.
;;
;; Sources;
;; - [2].
;;
(define (grsp-save-to-file p_s1 p_f1 p_m1)
  (let ((output-port (open-file p_f1 p_m1)))    

    (display p_s1 output-port)
    (newline output-port)
    (close output-port)))


;;;; grsp-delete-file - Deletes file p_f1.   
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: mode:
;;   - "#f": equivalent to rm -f, without confirmation.
;;   - "#c": eqivalent to rm, with confirmation.
;; - p_f1: file name.
;;
(define (grsp-delete-file p_s1 p_f1)
  (let ((s1 p_s1)
	(s2 "rm")
	(s3 ""))

    (cond ((equal? p_s1 "#f")
	   (set! s3 "-f")))
	
    (system (strings-append (list s2 s3 p_f1) 1))))


;; grsp-n2s - A convenience function, shorter to write than number->string that
;; performs the same function. That is, to convert a number to a string.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_n1: number to convert.
;;
(define (grsp-n2s p_n1)
  (let ((res1 ""))

    (set! res1 (number->string p_n1))

    res1))


;;;; grsp-s2n - A convenience function, shorter to write than string->number 
;; that performs the same function. That is, to convert a string to a number.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; p_s1: string to convert.
;;
(define (grsp-s2n p_s1)
  (let ((res1 0.0))

    (set! res1 (string->number p_s1))

    res1))


;;;; grsp-sqlp - Calls sqlp to access Sqlite3 or HDF5 databases from within a  
;; Guile program. Requires sqlp to be installed.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_p1: path to the sqlp executable.
;; - p_d1: database file, with path.
;; - p_s1: SQL or HDFQL snippet or file, with path.
;; - p_a1: sqlp macro (see sqlp's documentation for more on this).
;;
;; Sources: 
;; - [3].
;;
(define (grsp-sqlp p_p1 p_d1 p_s1 p_a1)
  (system (strings-append (list p_p1 p_d1 p_s1 p_a1) 1)))


;;;; grsp-ld - Line and display. Displays a string after a newline.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string.
;;
(define (grsp-ld p_s1)
  (newline)
  (display p_s1))


;;;; grsp-cd - Same as grsp-ld, but performs a clear instead of newline, meaning
;; that it clears the screen or console instead of just adding a line break.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string.
;;
(define (grsp-cd p_s1)
  (clear)
  (display p_s1))


;;;; grsp-ask - Input query.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; p_s1: string representing the question to ask.
;;
;; Output:
;; - Returns a string with the user's input.
;;
(define (grsp-ask p_s1)
  (let ((res1 " "))

    (newline)
    (grsp-ld p_s1)
    (set! res1 (read))

    res1))

  
;;;; grsp-placebo - This function is a placebo.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; p_s1: strng or number.
;;
;; Output:
;; - Returns p_s1.
;;
(define (grsp-placebo p_s1)
  (let ((res1 p_s1))
    
    ;; Does nothing, which sometimes can be useful.
    
    res1))


;; in - Increment p_n1 by one.
;;
;; Keywords:
;; - console, numbers.
;;
;; Arguments:
;; - p_n1: number.
;;
(define (in p_n1)
  (let ((res1 0))

    (set! res1 (+ p_n1 1))

    res1))


;; de - Decrement p_n1 by one.
;;
;; Keywords:
;; - console, numbers.
;;
;; Arguments:
;; - p_n1: number.
;;
(define (de p_n1)
  (let ((res1 0))

    (set! res1 (- p_n1 1))

    res1))


;;;; grsp-argtype - Finds the type of p_a1.
;;
;; Keywords:
;; - console, arguments, types.
;;
;; Arguments:
;; - p_a1: argument.
;;
;; Output:
;; - 0: undefined.
;; - 1: list.
;; - 2: string.
;; - 3: array.
;; - 4: boolean.
;; - 5: char.
;; - 6: integer.
;; - 7: real.
;; - 8: complex.
;; - 9: inf.
;; - 10: nan.
;;
;; Sources:
;; - [4][5].
;;
(define (grsp-argtype p_a1)
  (let ((res1 0)
	(a1 0))

    (cond ((list? p_a1)
	   (set! res1 1))
	  ((string? p_a1)
	   (set! res1 2))	  
	  ((array? p_a1)
	   (set! res1 3))	  
	  ((boolean? p_a1)
	   (set! res1 4))
	  ((char? p_a1)
	   (set! res1 5))	  
	  ((integer? p_a1)
	   (set! res1 6))
	  ((real? p_a1)
	   (set! res1 7))
	  ((complex? p_a1)
	   (set! res1 8)))

    ;; This should be processed separatedly.
    (cond ((< res1 8)
	   (cond ((inf? p_a1)
		  (set! res1 9))
		 ((nan? p_a1)
		  (set! res1 10)))))		 
    
    res1))
