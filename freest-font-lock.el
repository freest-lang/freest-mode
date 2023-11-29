;;;;;;;;;;;;;;;;;;;;
;;    GROUP       ;;
;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(defgroup freest-appearance nil
  "FreeST Appearance"
  :group 'freest ; TODO: Later
  )

;;;;;;;;;;;;;;;;;;;;
;;     FACES      ;;
;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(defface freest-keyword-face ;; keywords
  '((t :inherit font-lock-keyword-face))
  "FreeST keyword face"
  :group 'freest-appearance
  )

;;;###autoload
(defface freest-funName-face
  '((t :inherit font-lock-function-name-face))
  "FreeST function names face"
  :group 'freest-appearance)


;;;###autoload
(defface freest-constructor-face
  '((t :inherit font-lock-type-face ))
  "FreeST constructors face"
  :group 'freest-appearance)

;;;###autoload
(defface freest-operator-face
  '((t :inherit font-lock-variable-name-face))
  "FreeST operators face"
  :group 'freest-appearance)

;;;###autoload
(defface freest-string-face
  '((t :inherit font-lock-string-face))
  "FreeST strings and chars face"
  :group 'freest-appearance)

;;;;;;;;;;;;;;;;;;;;
;;    KEYWORDS    ;;
;;;;;;;;;;;;;;;;;;;;

(defconst freest-def-kinds
  '("1S" "*S" "1T" "*T" "1A" "*A")
  "freest kinds"
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Font lock definitions   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; KINDS

(rx-define lower-name
  (seq bow
       (in "a-z")
       (zero-or-more (or (in "A-Z") (in "a-z") (in "0-9") "'"))
       eow
       )
  )

(rx-define lower-name-not-bounded
  (seq
       (in "a-z")
       (zero-or-more (or (in "A-Z") (in "a-z") (in "0-9") "'"))      
       )
  )

(rx-define upper-name
  (seq (in "A-Z")
       (zero-or-more (or (in "A-Z") (in "a-z") (in "0-9") "'"))))

(rx-define arg-pattern-match
  (seq "(" upper-name (zero-or-more space lower-name) ")"))


(defconst freest-font-lock-kinds
  (list
    (rx-to-string `(: word-start (or ,@freest-def-kinds) word-end))
    '(0 'freest-keyword-face))
  "FreeST operators.")

;; INFIX (&) freest doesnt really support this yet (only for a few selected ops)
(defconst freest-font-lock-fun-type
  (list  
   (rx bol       
       (group (zero-or-more "_") lower-name-not-bounded)
       (zero-or-more space)
       ":"
       (not ":")
       )
   '(1 'freest-funName-face))
  "FreeST function type names")

(defconst freest-font-lock-funbody-name
  (list
   (rx bol
       (group (zero-or-more "_") lower-name-not-bounded)
       (zero-or-more (or space lower-name upper-name arg-pattern-match))
       "="
       )
   '(1 'freest-funName-face))
  "FreeST function definition name.")

(defconst freest-font-lock-types
  (list
   (rx bow
       (or "forall" "rec" "dualof")
       eow
      )
        '(0 'freest-constructor-face))
  "FreeST operators.")


(defconst freest-font-lock-constructors-types
  (list (rx bow upper-name eow)
        '(0 'freest-constructor-face)
        )
  "FreeST operators.")

;; constructors with symbols

(defconst freest-font-lock-constructors-types-preceded
  (list
   (rx ; symbol-start
       (or "!" "{" "?" "," ":" ";" space)
       ; symbol-end
       (group upper-name)
    )
    '(1 'freest-constructor-face))
  "FreeST operators.")

(defconst freest-font-lock-exps
  (list
   (rx bow
       (or "case" "of"
           "let" "in"
           "match" "with" "select"
           "if" "then" "else"
           "new" "fork" "forkWith"
           "send" ; "sendAndClose" "sendAndWait"
           "receive" ; "receiveAndClose" "receiveAndWait"
           "close" "wait")
       eow
       )
        '(0 'freest-keyword-face))
  "FreeST operators.")

(defconst freest-font-lock-defs
  (list
   (rx bow
       (or "data" "type" "module" "import" "where")
       eow
    )
   '(0 'freest-keyword-face))
  "FreeST operators.")


(defconst freest-font-lock-ops
  (list
   (rx ; symbol-start
       (one-or-more (or "1->" ":" "=" "/" "<" ">" "+" "-" "*" "^"
                    "&" "|" "→"  "$" ";" "." "\\"
                    "λ" "Λ" "⇒" ";" "@"
                    "_" "∧" "∨" "!" "?" "\{" "\}"))
;       symbol-end
    )
   '(0 'freest-operator-face))
  "FreeST operators.")

(defconst freest-font-lock-types-symbol
  (list
   (rx ; symbol-start
       (or "∀" "μ" "()"))
;       symbol-end    
   '(0 'freest-constructor-face))
  "FreeST operators.")

(defconst freest-font-lock-char
  (list
   (rx ;symbol-start
       (seq "'" alphanumeric "'"))
       ;symbol-end    
   '(0 'freest-string-face))
  "FreeST operators.")

;; Floats ops


;; Join all the font lock definitions
;; Please notice the ordering (it is important)

(defconst
  freest-font-lock-all
  (list
   freest-font-lock-defs
   freest-font-lock-kinds
   freest-font-lock-fun-type
   freest-font-lock-funbody-name
   freest-font-lock-types
   freest-font-lock-constructors-types
   freest-font-lock-constructors-types-preceded
   freest-font-lock-ops
   freest-font-lock-types-symbol
   freest-font-lock-exps
   freest-font-lock-char
   )
  "All FreeST font lock keywords.")


(provide 'freest-font-lock)
