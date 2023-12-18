;Read a date D and a number N and determine what day/month/year it would be if N days pass from date D.
;	In: 4/4/2023 100 Out: 13/07/2023

;Read a date D and a number N and determine what day/month/year it would be if N days pass from date D.
;	In: 4/4/2023 100 Out: 13/07/2023

(deftemplate date
  (slot day (type INTEGER))
  (slot month (type INTEGER))
  (slot year (type INTEGER))
  (slot stopNumber (type INTEGER))
)

(deffacts init
  (date (day 24) (month 12) (year 1987) (stopNumber 40000))
  (lean 0)
)

(defrule newYear
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  ?b <- (lean ?l)
  (test (eq ?m 12))
  (test (eq ?d 31))
  (test (<> ?s 0))
  =>
  (retract ?b)
  (assert (lean 0))
  (modify ?a (day 1))
  (modify ?a (month 1))
  (modify ?a (year (+ ?y 1)))
  (modify ?a (stopNumber (- ?s 1)))
)

(defrule leanYearY
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  ?b <- (lean 0)
  (test (or (= (mod ?y 4) 0) (and (= (mod ?y 100) 0) (= (mod ?y 400) 0))))
  =>
  (retract ?b)
  (assert (lean 1))
)

(defrule leanYearN
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  ?b <- (lean 0)
  (test (<> (mod ?y 4) 0))
  (test (<> (mod ?y 100) 0))
  (test (<> (mod ?y 400) 0))
  =>
  (retract ?b)
  (assert (lean 2))
)

(defrule 29days
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  (lean 1)
  (test (= ?d 29))
  (test (= ?m 2))
  (test (<> ?s 0))
  =>
  (modify ?a (day 1))
  (modify ?a (month (+ ?m 1)))
  (modify ?a (stopNumber (- ?s 1)))
)

(defrule 28days
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  (lean 2)
  (test (= ?d 28))
  (test (= ?m 2))
  (test (<> ?s 0))
  =>
  (modify ?a (day 1))
  (modify ?a (month (+ ?m 1)))
  (modify ?a (stopNumber (- ?s 1)))
)

(defrule 30days
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  (test (or (eq ?m 4) (eq ?m 6) (eq ?m 9) (eq ?m 11)))
  (test (eq ?d 30))
  (test (<> ?s 0))
  =>
  (modify ?a (day 1))
  (modify ?a (month (+ ?m 1)))
  (modify ?a (stopNumber (- ?s 1)))
)

(defrule 31days
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  (test (or (eq ?m 1) (eq ?m 3) (eq ?m 5) (eq ?m 7) (eq ?m 8) (eq ?m 10)))
  (test (eq ?d 31))
  (test (<> ?s 0))
  =>
  (modify ?a (day 1))
  (modify ?a (month (+ ?m 1)))
  (modify ?a (stopNumber (- ?s 1)))
)

(defrule nomalDays
  ?a <- (date (day ?d) (month ?m) (year ?y) (stopNumber ?s))
  (test (<> ?d 100))
  (test (<> ?s 0))
  =>
  (modify ?a (day (+ ?d 1)))
  (modify ?a (stopNumber (- ?s 1)))
)
