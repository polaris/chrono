;;;; chrono.asd

(asdf:defsystem #:chrono
  :description "Describe chrono here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:chronicity)
  :components ((:file "package")
               (:file "chrono")))
