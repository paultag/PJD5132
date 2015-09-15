;;
;;

(defclass Command [])

;; 
(defmacro $ [name stat &rest methods]
  "Generate a clas from the opmap"

  (import itertools [PJD5132.commands [*command-map*]])

  (defn to-class-name [name]
    "Take a foo-bar name and make it FooBar"
    (.join "" (list-comp
      ((fn [chunk]
         (+ (.upper (get chunk 0))
            (get chunk (slice 1 nil)))) x)
      [x (.split name "_")])))

  (defn make-method [name op]
    (setv operator (.get *command-map* op))
    (if (is operator nil) `(do)
                          `(defn ~name [self] (print [~@(.get *command-map* op)]))))

  `(defclass ~(to-class-name name) [Command] []
     ~@(list-comp (make-method method op)
                  [(, method op) (itertools.chain methods [['status stat]])])))

;;;;

($ power power-status
  (on power-on)
  (off power-off))

($ reset nil
  (color reset-color-settings)
  (all reset))

($ splash-screen splash-screen-status
  (black splash-screen-black)
  (blue  splash-screen-blue)
  (viewsonic splash-screen-viewsonic)
  (off splash-screen-off))

($ quick-power-off quick-power-off-status
  (on quick-power-off-on)
  (off quick-power-off-off))
