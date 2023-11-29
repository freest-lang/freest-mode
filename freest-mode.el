
(require 'freest-font-lock)
;; ; (require  'freest-repl)
; (require  'freest-inferior)

;;;###autoload
(defgroup freest nil
  "FreeST group"
)

;;; Syntax
;;;; Syntax Table

(defconst freest-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; List-likes
    (modify-syntax-entry ?\{ "(}" table)
    (modify-syntax-entry ?\} "){" table)
    (modify-syntax-entry ?\[ "(]" table)
    (modify-syntax-entry ?\] ")[" table)
    
    ;; Comments
    (modify-syntax-entry ?\{  "(}1nb" table)
    (modify-syntax-entry ?\}  "){4nb" table)
    (modify-syntax-entry ?-   "_ 123" table)
    (modify-syntax-entry ?\n ">" table)
    
    (modify-syntax-entry ?\, "_" table)

    table)
  "The `freest-mode' syntax table.")


(defun freest-mode-setup-syntax ()
  "Setup syntax, indentation, and other core components of major modes."
  ;; We explictly set it for tests that only call this setup-fn
  (set-syntax-table freest-mode-syntax-table)

  ;; AutoHighlightSymbol needs adjustment for symbol recognition
  ; (setq-local ahs-include "^[0-9A-Za-z/_.,:;*+=&%|$#@!^?-~\-]+$")
  
  )

(defun freest-mode-setup-font-lock ()
  "Setup `font-lock-defaults' and others for `freest-mode.'"
  (setq-local font-lock-multiline t)
       
  (setq font-lock-defaults ; '(freest-font-lock-all nil nil nil nil nil)
        '(freest-font-lock-all nil nil
          (("|+*/.<>=!?$%_&~^:∀→⊸Λ⇒;_∧∨\\'" . "w"))  ; syntax alist
          nil
          (font-lock-mark-block-function . mark-defun)
          (parse-sexp-lookup-properties . t)
          )
        )
  )



;; (defvar freest-comint-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "C-c C-l") 'freest-load-file)
;;     ;; (define-key map (kbd "C-c C-k") 'freest-mode-clear)
;;     ;; (define-key map (kbd "C-c C-z") 'freest-interactive-switch)
;;     ;; (define-key map (kbd "C-x C-k") 'freest-shell--kill)
;;     map)
;;   "Freest mode map")


;;;###autoload
(define-derived-mode freest-mode prog-mode "Freest"
  "Major mode for editing Freest files."
  (freest-mode-setup-font-lock)
  (setq-local comment-start "--")
  (setq-local comment-padding 1)
  (setq-local comment-start-skip "[-{]-[ \t]*")
  (setq-local comment-end "")
  (setq-local comment-end-skip "[ \t]*\\(-}\\|\\s>\\)")
  (freest-mode-setup-syntax)
  ;; (use-local-map freest-comint-mode-map)
)


;;; Provide:

(provide 'freest-mode)
