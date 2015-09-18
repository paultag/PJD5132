;;
;;

(import serial)


(defclass Command [] []
  (defn --init-- [self] (setv self.serial (serial.Serial "/dev/ttyACM0" 115200)) nil)
  (defn send-command [self command]
    (self.serial.write (bytearray command))
    (self.serial.flush)))

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
    (if (is operator nil)
      `(do)
      `(defn ~name [self] (self.send-command [~@(.get *command-map* op)]))))

  `(defclass ~(to-class-name name) [Command]
    "This class was autogenerated from the API defs."
    [] ~@(list-comp (make-method method op)
                    [(, method op) (itertools.chain methods [['status stat]])])))

;;;;

($ power power-status
  (on power-on)
  (off power-off))

($ reset nil
  (lamp lamp-usage-reset)
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

($ high-altitude high-altitude-status
  (on high-altitude-on)
  (off high-altitude-off))

($ lamp-mode lamp-mode-status
  (normal lamp-mode-normal)
  (economic lamp-mode-economic))

($ message message-status
  (on message-on)
  (off message-off))

($ position position-status
  (front-table position-front-table)
  (rear-table position-front-table)
  (rear-ceiling position-rear-ceiling)
  (front-ceiling position-front-ceiling))

($ contrast contrast-ratio
  (increase contrast-increase)
  (decrease contrast-decrease))

($ brightness brightness-status
  (increase brightness-increase)
  (decrease brightness-decrease))

($ aspect-ratio aspect-ratio-status
  (four-three aspect-ratio-4/3)
  (sixteen-nine aspect-ratio-16/9)
  (sixteen-ten aspect-ratio-16/10)
  (wide aspect-ratio-wide))

($ auto-adjust nil (adjust auto-adjust))

($ shift nil
  (right position-shift-right)
  (left position-shift-left)
  (up position-shift-up)
  (down position-shift-down)
  (horizontal-position horizontal-position-status)
  (vertical-position vertical-position-status))

($ color-temperature color-temperature-status
  (T1 color-temperature-T1)
  (T2 color-temperature-T2)
  (T3 color-temperature-T3)
  (T4 color-temperature-T4))

($ blank blank-status
  (on blank-on)
  (off blank-off))

($ keystone keystone-status
  (increase keystone-increase)
  (decrease keystone-decrease))

($ color-mode color-mode-preset-mode-status
  (brightest     color-mode-brightest)
  (movie         color-mode-movie)
  (user-1        color-mode-user-1)
  (user-2        color-mode-user-2)
  (pc-gaming     color-mode-pc-gaming)
  (viewmatch     color-mode-viewmatch)
  (dynamic-pc    color-mode-dynamic-pc)
  (dynamic-movie color-mode-dynamic-movie))

($ primary-color primary-color-status
  (R primary-color-R)
  (G primary-color-G)
  (B primary-color-B)
  (C primary-color-C)
  (M primary-color-M)
  (Y primary-color-Y))

($ hue hue
  (increase hue-increase)
  (decrease hue-decrease))

($ saturation saturation
  (increase saturation-increase)
  (decrease saturation-decrease))

($ gain gain
  (increase gain-increase)
  (decrease gain-decrease))

($ freeze freeze-status
  (on freeze-on)
  (off freeze-off))

($ input-source input-source
  (vga       input-source-vga)
  (vga2      input-source-vga2)
  (composite input-source-composite)
  (svideo    input-source-svideo)
  (hdmi      input-source-hdmi))

($ quick-auto-search quick-auto-search-status
  (on quick-auto-search-on)
  (off quick-auto-search-off))

($ hdmi-format hdmi-format
  (rgb hdmi-format-rgb)
  (yuv hdmi-format-yuv)
  (auto hdmi-format-auto))

($ hdmi-range hdmi-range-status
  (enhanced hdmi-range-enhanced)
  (normal hdmi-range-normal))

($ mute mute-status
  (on mute)
  (off unmute))

($ volume volume
  (increase volume-increase)
  (decrease volume-decrease))

($ lamp lamp-usage-hours)
($ error error-status)
