;; =============================================================================
;;
;; grsp0.scm
;;
;; Some useful, simple functions for GNU Guile Scheme programs created or   
;; adapted during the development of several other projects.
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
;; - Read at least the general notes of all scm files in this library before
;;   use.
;;
;; - Compilation:
;;   - (use-modules (grsp grsp0)(grsp grsp1)(grsp grsp2)(grsp grsp3)(grsp grsp4)(grsp grsp5)(grsp grsp6)(grsp grsp7)(grsp grsp8)(grsp grsp9)(grsp grsp10)(grsp grsp11)(grsp grsp12)(grsp grsp13)(grsp grsp14)(grsp grsp15))
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
;; - [7] En.wikipedia.org. 2022. Mathematics Subject Classification - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Mathematics_Subject_Classification
;;   [Accessed 16 June 2022].
;; - [8] En.wikipedia.org. 2022. ACM Computing Classification System -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/ACM_Computing_Classification_System
;;   [Accessed 16 June 2022].


(define-module (grsp grsp0)
  #:export (pline
	    ptit
	    newlines
	    clear
	    pres
	    pres2
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
	    grsp-ldl
	    grsp-cd
	    grsp-ask
	    grsp-askn
	    grsp-ask-etc
	    grsp-placebo
	    in
	    de
	    grsp-argtype
	    grsp-dstr
	    grsp-jstr
	    grsp-hw
	    grsp-gb
	    grsp-string-tlength
	    grsp-string-ltlength
	    grsp-string-ltrim
	    grsp-string-pjustify
	    grsp-string-repeat
	    grsp-string-lpjustify
	    grsp-ln2ls
	    grsp-ls2ln
	    grsp-ls2s
	    grsp-s2ln
	    grsp-ln2s))


;;;; pline - Displays string p_s1 p_l1 times in one line at the console.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: line character to display.
;; - p_l1: line length.
;;
;; Examples:
;; - example1.scm, example3.scm
;;
(define (pline p_s1 p_l1)
  (let ((s1 ""))

    ;; Cycle.
    (let loop ((i1 0))
      (if (= i1 p_l1)
	  (begin (newlines 1)
		 (display s1)
		 (newlines 1))
	  (begin (set! s1 (string-append s1 p_s1))
	         (loop (+ i1 1)))))))


;;;; ptit - Displays a console title with one or two lines.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: line string to display.
;; - p_l1: line length.
;; - p_n1: number of lines (1 or 2, defaults to 1 line above title).
;; - p_t1: title to display.
;;
;; Examples:
;; - example1.scm, example3.scm
;;
(define (ptit p_s1 p_l1 p_n1 p_t1)
  (if (<= p_n1 1)
      (pline p_s1 p_l1))
  
  (if (>= p_n1 2)
      (pline p_s1 p_l1))
  
  (display p_t1)
  
  (if (>= p_n1 2)
      (pline p_s1 p_l1))
  
  (newline))


;;;; newlines - Repeats function newline p_n1 times.
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
;; Examples:
;; - example3.scm
;;
(define (clear)
  (newlines 100))


;;;; pres - Display results with a reference string or title and an equal sign
;; preceeding the results string.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: reference, string.
;; - p_s2: result, string.
;;
;; Notes: 
;; -  See pres2.
;;
;; Examples: 
;; - example1.scm 
;;
(define (pres p_s1 p_s2)
  (let ((res1 " "))

    (set! res1 (string-append p_s1 (string-append " = " p_s2)))
      (display res1)
      (newline)))


;;;; pres2 - Display results. Does not require p_s2 to be a string.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: reference, string.
;; - p_s2: result.
;;
;; Notes: 
;; -  See pres.
;;
(define (pres2 p_s1 p_s2)
  (newline)
  (display p_s1)
  (display " = ")
  (display p_s2)
  (newline))


;;;; newspaces - Adds p_n blank spaces to string p_l1.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_n1: number of blanks to add.
;; - p_l1: string to display.
;; - p_s1: side where to add spaces,
;;   - 0 for left side.
;;   - 1 for right side.
;;
;; Examples: 
;; - example1.scm
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
;; Examples:
;; - example1.scm, example3.scm
;;
(define (strings-append p_l1 p_s1)
  (let ((res1 "")
	(elem #f))

    ;; Cycle.
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
;; Examples: 
;; - example1.scm
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
;; Examples:
;; - example3.scm
;;
(define (grsp-ld p_s1)
  (newline)
  (display p_s1))


;;;; grsp-ldl - Line, display. line. Displays p_n1 blank lines before
;; string p_s1 and p_n2 blank lines after p_s1.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string.
;; - p_n1: number of new lines preceeding the string.
;; - p_n2: number of new lines after the string.
;;
;; Examples:
;; - example3.scm
;;
(define (grsp-ldl p_s1 p_n1 p_n2)
  (let ((n1 0))

    (set! n1 (- p_n1 1))
    
    (cond ((< n1 0)
	   (set! n1 0)))
    
    (newlines n1)
    (display p_s1)
    (newlines p_n2)))


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


;;;; grsp-ask - Input query, string.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; p_s1: string representing the question to ask.
;;
;; Examples:
;; - example3.scm
;;
;; Output:
;; - Returns data from the user's input. You may need to use symbol->[type] in
;;   order to return the proper type variable for your needs.
;;
(define (grsp-ask p_s1)
  (let ((res1 " "))

    (newline)
    (grsp-ld p_s1)
    (set! res1 (read))

    res1))


;;;; grsp-askn - Input query for numbers.
;;
;; Keywords:
;; - console, numbers.
;;
;; Arguments:
;; p_s1: string representing the question to ask.
;;
;; Output:
;; - Returns data from the user's input as a number.
;;
(define (grsp-askn p_s1)
  (let ((res1 0))

    (newline)
    (grsp-ld p_s1)
    (set! res1 (read))

    res1))


;;;; grsp-ask-etc - Asks top press <ENT> to continue.
;;
;; Keywords:
;; - console, strings.
;;
;; Examples:
;; - example3.scm
;;
;; Output:
;; - A question asking to press <ENT> to continue.
;;
(define (grsp-ask-etc)
  (let ((res1 " "))

    (grsp-ask "Press <ENT> to continue.")
    
    res1))


;;;; grsp-placebo - This function is a placebo.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; p_s1: string or number.
;;
;; Output:
;; - Returns p_s1.
;;
(define (grsp-placebo p_s1)
  (let ((res1 p_s1))
    
    ;; Does nothing, which sometimes can be useful.
    
    res1))


;; in - Increments p_n1 by one.
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


;; de - Decrements p_n1 by one.
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


;;;; grsp-dstr - Duplicates string p_s1 by concatenationg it with itself so that
;; if from p_s1 is obtained p_s1+p_s1.
;;
;; Keywords:
;; - console, arguments, types.
;;
;; Arguments:
;; - p_s1: string.
;;
(define (grsp-dstr p_s1)
  (let ((res1 p_s1))

    (set! res1 (string-append res1 p_s1))

    res1))


;;;; grsp-jstr - Will form a string of p_n1 elements, including strings p_s1,
;; p_s2 and enough repetitions of string p_s3 in order to justify p_s1 to the
;; left and p_s2 to the right.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string.
;; - p_s2: string.
;; - p_s3: string (one element in length).
;; - p_n1: number. Should be greater than the length of p_s1, p_s2 and p_s3
;;   put together.
;;
(define (grsp-jstr p_s1 p_s2 p_s3 p_n1)
  (let ((res1 " ")
	(l1 0)
	(l2 0)
	(l3 0)
	(n1 0)
	(i1 0)
	(s3 ""))

    (set! l1 (string-length p_s1))
    (set! l2 (string-length p_s2))  
    (set! n1 (- p_n1 (+ l1 l2)))

    ;; Cycle.
    (while (< l3 n1)
	   (set! s3 (string-append s3 p_s3))
	   (set! l3 (string-length s3)))

    ;; Compose results.    
    (set! res1 (strings-append (list p_s1 s3 p_s2) 0))
    
    res1))


;;;; grsp-hw - Salutes the world. Sometimes this is all what is needed.
;;
;; Keywords:
;; - console, strings.
;;
(define (grsp-hw)
  (grsp-ldl "Hello world!" 1 1))


;;;; grsp-gb - Says goodbye.
;;
;; Keywords:
;; - console, strings.
;;
(define (grsp-gb)
  (grsp-ldl "Good bye!" 1 1))


;;;; grsp-string-tlength - Returns the length of trimmed string p_s2.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: sitring. Mode.
;;   - "#l": trim left.
;;   - "#r": trim right.
;;   - "#b": trim left and right.
;;   - "#n": do not trim.
;; - p_s2: string.
;;
(define (grsp-string-tlength p_s1 p_s2)
  (let ((res1 0)
	(res2 0))

    (cond ((equal? p_s1 "#l")
	   (set! res1 (string-length (string-trim p_s2))))
	  ((equal? p_s1 "#r")
	   (set! res1 (string-length (string-trim-right p_s2))))
	  ((equal? p_s1 "#b")
	   (set! res1 (string-length (string-trim-both p_s2))))
	  ((equal? p_s1 "#n")
	   (set! res1 (string-length p_s2))))
	  
    res1))


;;;; grsp-string-ltlength - Find the length of each string in a string list.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: sitring. Mode.
;;   - "#l": trim left.
;;   - "#r": trim right.
;;   - "#b": trim left and right.
;;   - "#n": do not trim.
;; - p_l1: list of strings.
;;
;; Notes:
;; - See grsp-string-tlength, grsp-string-ltrim.
;;
(define (grsp-string-ltlength p_s1 p_l1)
  (let ((res1 '())
	(res2 '())
	(j1 0)
	(n1 0)
	(s2 "")
	(hn (length p_l1)))    

    ;; Trim according to p_s1.
    (set! res2 (grsp-string-ltrim p_s1 p_l1))
    
    ;; Create results list.
    (set! res1 (make-list hn 0))

    ;; Cycle.
    (while (< j1 hn)

	   (set! s2 (list-ref res2 j1))
	   (set! n1 (string-length s2))
	   (list-set! res1 j1 n1)
	   
	   (set! j1 (+ j1 1)))
    
    res1))


;;;; grsp-string-ltrim - Trim spaces on all elements of list p_l1 according to
;; p_s1.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: sitring. Mode.
;;   - "#l": trim left.
;;   - "#r": trim right.
;;   - "#b": trim left and right.
;;   - "#n": do not trim.
;; - p_l1: list of strings.
;;
;; Notes:
;; - See grsp-string-tlength.
;;
(define (grsp-string-ltrim p_s1 p_l1)
  (let ((res1 '()))  

    (set! res1 p_l1)
    
    ;; Trim according to p_s1.
    (cond ((equal? p_s1 "#l")
	   (set! res1 (map string-trim res1)))
	  ((equal? p_s1 "#r")
	   (set! res1 (map string-trim-right res1)))
	  ((equal? p_s1 "#b")
	   (set! res1 (map string-trim-both res1))))
    
    res1))


;;;; grsp-string-pjustify - Pads with string p_s3 and justifies string p_s2
;; into a string of total length p_n1.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string. Mode.
;;   - "#l": p_s2 to the left.
;;   - "#r": p_s2 to the right.
;;   - "#b": center p_s2.
;; - p_s2: string.
;; - p_s3: string for padding (one char length).
;; - p_n1: numeric. Length of padded and justified string.
;;
(define (grsp-string-pjustify p_s1 p_s2 p_s3 p_n1)
  (let ((res1 p_s2)
	(s4 "")
	(s5 "")
	(j1 0)
	(n1 p_n1)
	(n2 (string-length p_s2))
	(n3 0)
	(n4 0))

    ;; n1 cannot be shorter than n2.
    (cond ((< n1 n2)
	   (set! n1 n2)))

    ;; If n1 equals n2 for whatever reason, there is no need to justify
    ;; anything because the resulting string will be of the same length
    ;; as p_s2, so the function returns the original p_s2.
    (cond ((> n1 n2)
	   ;; Find out how many characters should be padded using p_s3.
	   (set! n3 (- n1 n2))
	   
	   ;; Compose results.
	   (cond ((equal? p_s1 "#r")
		  (set! s4 (grsp-string-repeat p_s3 n3))
		  (set! res1 (strings-append (list s4 p_s2) 0)))
		 ((equal? p_s1 "#l")
		  (set! s4 (grsp-string-repeat p_s3 n3))
		  (set! res1 (strings-append (list p_s2 s4) 0)))
		 ((equal? p_s1 "#b")
		  
		  (cond ((odd? n3)
			 (set! n4 (/ (- n3 1) 2))
			 (set! s4 (grsp-string-repeat p_s3 n4))
			 (set! s5 (grsp-string-repeat p_s3 (+ n4 1))))			 
			((even? n3)
			 (set! n4 (/ n3 2))
			 (set! s4 (grsp-string-repeat p_s3 n4))
			 (set! s5 s4)))

		  (set! res1 (strings-append (list s5 p_s2 s4) 0))))))
    
    res1))


;;;; grsp-string-repeat - Concatenate p_n1 copies of string p_s1
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string.
;; - p_n1: number. How many times should p_s1 be repeated.
;;
(define (grsp-string-repeat p_s1 p_n1)
  (let ((res1 "")
	(j1 0))

    (while (< j1 p_n1)
	   (set! res1 (string-append res1 p_s1))
	   (set! j1 (in j1)))

    res1))


;;;; grsp-string-lpjustify - Applies grsp-string-pjustify to every element of
;; p_l1, producing a list of strings of equal length, padded with p_s3 and
;; lustified according to p_s1.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string. Mode.
;;   - "#l": p_s2 to the left.
;;   - "#r": p_s2 to the right.
;;   - "#b": center p_s2.
;; - p_l1: list of strings.
;; - p_s3: string for padding (one char length).
;; - p_n1: numeric. Length of padded and justified string.
;;
(define (grsp-string-lpjustify p_s1 p_l1 p_s3 p_n1)
  (let ((res1 '())
	(s2 "")
	(hn (length p_l1))
	(j1 0))

    ;; Create results list.
    (set! res1 (make-list hn s2))

    ;; Cycle.
    (while (< j1 hn)
	   (list-set! res1 j1 (grsp-string-pjustify p_s1 (list-ref p_l1 j1) p_s3 p_n1))
	   (set! j1 (in j1)))
    
    res1))


;;;; grsp-ln2ls - Casts a list of numbers as a list of strings that represent
;; numbers.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_l1: list of numbers to convert to strings.
;;
(define (grsp-ln2ls p_l1)
  (let ((res1 '()))

    (set! res1 (map grsp-n2s p_l1))
    
    res1))


;;;; grsp-ls2ln - Casts a list of strings representing numbers as a list of
;; numbers.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_l1: list of strings to convert to numbers.
;;
(define (grsp-ls2ln p_l1)
  (let ((res1 '()))

    (set! res1 (map grsp-s2n p_l1))
    
    res1))


;;;; grsp-ls2s - Casts a list of strings as single string.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_l1: list of strings to convert to a single string. 
;;
(define (grsp-ls2s p_l1)
  (let ((res1 "")
	(hn (length p_l1))
	(j1 0))

    ;; Cycle list and append.
    (while (< j1 hn)
	   (set! res1 (string-append res1 (list-ref p_l1 j1)))
	   (set! j1 (in j1)))

    res1))


;;;; grsp-s2ln - String to list of numbers representing the Unicode number of
;; each character in the original string.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_s1: string.
;;
(define (grsp-s2ln p_s1 p_s2)
  (let ((res1 '())
	(l1 '()))
	     
    (set! l1 (string->list p_s1))
    (set! res1 (map char->integer l1))
    
    res1))


;;;; grsp-ln2ls - List of numbers to string. The numbers in the list should
;; represent Unicode character.
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments:
;; - p_l1: list.
;;
(define (grsp-ln2s p_l1)
  (let ((res1 "")
	(l1 '()))

    (set! l1 (map integer->char p_l1))
    (set! res1 (list->string l1))
    
    res1))
