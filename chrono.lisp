;;;; chrono.lisp

;(eval-when (:compile-toplevel :load-toplevel :execute)
;  (ql:quickload '(:with-user-abort :chronicity :adopt) :silent t))

(in-package :chrono)

;;;; Configuration -----------------------------------------------
(defparameter *whatever* 123)

;;;; Errors ------------------------------------------------------
(define-condition user-error (error) ())

(define-condition missing-foo (user-error) ()
  (:report "A foo is required, but none was supplied."))

;;;; Functionality -----------------------------------------------
(defun handle-input-string (string)
  (let ((time (chronicity:parse string)))
    (format t "~d~%" (local-time:format-timestring nil time :format local-time:+rfc-1123-format+))))

;;;; Run ---------------------------------------------------------
(defun run (arguments)
  (map nil #'handle-input-string arguments))

;;;; User Interface ----------------------------------------------
(defmacro exit-on-ctrl-c (&body body)
  `(handler-case (with-user-abort:with-user-abort (progn ,@body))
     (with-user-abort:user-abort () (sb-ext:exit :code 130))))

(defparameter *option-help*
  (adopt:make-option 'help
    :long "help"
    :short #\h
    :help "Display help and exit."
    :reduce (constantly t)))

(defparameter *option-version*
  (adopt:make-option 'version
    :long "version"
    :short #\v
    :help "Display version and exit."
    :reduce (constantly t)))

(defparameter *ui*
  (adopt:make-interface
    :name "chrono"
    :summary "yada yada yada"
    :usage "hello, world"
    :help "help me!"
    :contents (list *option-help*
                    *option-version*)))

(defun toplevel (args)
  (sb-ext:disable-debugger)
  (exit-on-ctrl-c
    (multiple-value-bind (arguments options) (adopt:parse-options-or-exit *ui* (cdr args))
      ; Handle options.
      (when (gethash 'help options)
        (adopt:print-help-and-exit *ui*))
      (when (gethash 'version options)
        (format t "1.0.0~%")
        (adopt:exit))
      (handler-case (run arguments)
        (user-error (e) (adopt:print-error-and-exit e))))))
