(defclass Command [])


(defmacro $ [name stat &rest methods]
  (import [PJD5132.commands [*command-map*]])
  (defn to-class-name [name]
    "Take a foo-bar name and make it FooBar"
    (.join "" (list-comp ((fn [chunk]
                            (+ (.upper (get chunk 0))
                               (get chunk (slice 1 nil)))) x)
                         [x (.split name "_")])))
  (setv command-class `(defclass ~(to-class-name name) [Command] []))
  (for [(, method op) methods]
    (command-class.append
      `(defn ~method [self]
         (print [~@(get *command-map* op)]))))
  command-class)

($ power power-status
  (on power-on)
  (off power-off))

($ reset nil
  (color reset-color-settings)
  (all reset))
