(import serial [flask [Flask request make-response]])

(setv app (Flask --name--))

(setv serial-line (serial.Serial  ; 115200 8N1
                      :port     "/dev/ttyUSB0"
                      :timeout  2
                      :bytesize serial.EIGHTBITS
                      :parity   serial.PARITY_NONE
                      :stopbits serial.STOPBITS_ONE
                      :baudrate 115200))



(defmacro defroute [name root &rest methods]
  (import os.path)

  (defn generate-method [path method status]

    `(with-decorator (app.route ~path) (fn []
       (import [PJD5132.api [~method ~(if status status method)]])

       (try (do (setv ret (~method serial-line))
               ~(if status `(setv ret (~status serial-line)))
                (repr ret))
       (except [e ValueError]
          (setv response (make-response (.format "Fatal Error: ValueError: {}" (str e))))
          (setv response.status-code 500)
          response)))))

  (setv path (.format "/projector/{}" name))
  (setv actions (dict methods))
  `(do ~(generate-method path root nil)
       ~@(list-comp (generate-method (os.path.join path method-path) method root)
                    [(, method-path method) methods])))


(defroute mute
  mute-status
  ("on"  mute)
  ("off" unmute))


(defroute power
  power-status
  ("on"  power-on)
  ("off" power-off))


(defroute aspect-ratio
  aspect-ratio-status
  ("auto"  aspect-ratio-auto)
  ("4:3"   aspect-ratio-4/3)
  ("16:9"  aspect-ratio-16/9)
  ("wide"  aspect-ratio-wide))


(defroute blank
  blank-status
  ("on"  blank-on)
  ("off" blank-off))


(defroute source
  input-source
  ("vga"       input-source-vga)
  ("vga2"      input-source-vga2)
  ("composite" input-source-composite)
  ("svideo"    input-source-svideo)
  ("hdmi"      input-source-hdmi))


(defroute volume
  volume
  ("increase" volume-increase)
  ("decrease" volume-decrease))


(defroute brightness
  brightness-status
  ("increase" brightness-increase)
  ("decrease" brightness-increase))


(defroute freeze
  freeze-status
  ("on"  freeze-on)
  ("off" freeze-off))
