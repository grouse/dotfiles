(deftheme grouse "Grouse's custom color theme")


;; backgrounds
(defvar grouse-base00 "#232123") ; darker
(defvar grouse-base01 "#2a282a") ; normal
(defvar grouse-base02 "#353335") ; lighter

;; foregrounds
(defvar grouse-base03 "#6e6d6e") ; comments, disabled code
(defvar grouse-base04 "#948068") ; preprocessor, include, module, etc

(defvar grouse-base05 "#c6b391") ; normal

(defvar grouse-base06 "#a09066") ; code keywords, statements, etc
(defvar grouse-base07 "#ece6d6") ; number, boolean, null, etc

;; special colours
(defvar grouse-black  "#131313")
(defvar grouse-red    "#E5786D")
(defvar grouse-orange "#f99157")
(defvar grouse-yellow "#c3cd3b")
(defvar grouse-green  "#7dba6d")
(defvar grouse-cyan   "#5fb3b3")
(defvar grouse-blue   "#94AFCC")

(custom-theme-set-faces
 'grouse
 `(default                             ((t (:foreground ,grouse-base05 :background ,grouse-base01))))

 `(font-lock-comment-face              ((t (:foreground ,grouse-base03))))
 `(font-lock-comment-delimiter-face    ((t (:foreground ,grouse-base03))))

 `(font-lock-preprocessor-face         ((t (:foreground ,grouse-base04))))

 `(font-lock-builtin-face              ((t (:foreground ,grouse-base05))))
 `(font-lock-doc-face                  ((t (:foreground ,grouse-base05))))
 `(font-lock-function-name-face        ((t (:foreground ,grouse-base05))))

 `(font-lock-keyword-face              ((t (:foreground ,grouse-base06))))
 `(font-lock-type-face                 ((t (:foreground ,grouse-base06))))

 `(font-lock-constant-face             ((t (:foreground ,grouse-base07))))


 `(font-lock-string-face               ((t (:foreground ,grouse-green))))


 `(font-lock-negation-char-face        ((t (:foreground ,grouse-base05))))
 `(font-lock-regexp-grouping-construct ((t (:foreground ,grouse-base05))))
 `(font-lock-regexp-grouping-backslash ((t (:foreground ,grouse-base05))))
 `(font-lock-variable-name-face        ((t (:foreground ,grouse-base05))))
 `(font-lock-warning-face              ((t (:foreground ,grouse-base05))))

 `(font-lock-todo-face                 ((t (:foreground ,grouse-red))))
 `(font-lock-fixme-face                ((t (:foreground ,grouse-yellow))))


 `(diff-added                          ((t (:foreground ,grouse-green))))
 `(diff-changed                        ((t (:foreground ,grouse-yellow))))
 `(diff-removed                        ((t (:foreground ,grouse-red))))

 `(compilation-warning-face            ((t (:foreground ,grouse-base05))))
 `(compilation-column-face             ((t (:foreground ,grouse-base05))))
 `(compilation-enter-directory-face    ((t (:foreground ,grouse-base05))))
 `(compilation-error-face              ((t (:foreground ,grouse-base05))))
 `(compilation-face                    ((t (:foreground ,grouse-base05))))
 `(compilation-info-face               ((t (:foreground ,grouse-base05))))
 `(compilation-info                    ((t (:foreground ,grouse-base05))))
 `(compilation-leave-directory-face    ((t (:foreground ,grouse-base05))))
 `(compilation-line-face               ((t (:foreground ,grouse-base05))))
 `(compilation-line-number             ((t (:foreground ,grouse-base05))))
 `(compilation-message-face            ((t (:foreground ,grouse-base05))))
 `(compilation-warning-face            ((t (:foreground ,grouse-base05))))
 `(compilation-mode-line-exit          ((t (:foreground ,grouse-base05))))
 `(compilation-mode-line-fail          ((t (:foreground ,grouse-base05))))
 `(compilation-mode-line-run           ((t (:foreground ,grouse-base05))))
 )

(when load-file-name
  (add-to-list 'custom-theme-load-path
   (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'grouse)

