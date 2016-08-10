;; packages configuration
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/themes")

;; functions
(defun open-project (directory)
  (interactive (list (read-directory-name "project path:")))

  (cd directory)
  (setq compile-command (concat directory "/build.sh")))

(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
 In Delete Selection mode, if the mark is active, just deactivate it;
 then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

;; general keybinds
(global-set-key (kbd "C-s") 'split-window-horizontally)
(global-set-key (kbd "C-S-s") 'split-window-vertically)

;; give me back my escape key
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; colour scheme settings
(require 'color-theme)
(require 'color-theme-wombat)
(with-eval-after-load "color-theme"
  (color-theme-initialize)
  (load-theme 'wombat t t)
  (enable-theme 'wombat))

;; custom faces
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-todo-face)

(modify-face 'font-lock-fixme-face "#ff0000" nil nil t nil t nil nil)
(modify-face 'font-lock-todo-face  "#00aa00" nil nil t nil t nil nil)

;; compilatation configuration
(require 'compile)
(with-eval-after-load "compile"
    (global-set-key (kbd "<f5>") 'compile)
    (global-set-key (kbd "M-n") 'next-error)
    (global-set-key (kbd "M-p") 'previous-error))

;; powerline configuration
(use-package powerline
  :ensure powerline
  :init
  (progn
    (powerline-default-theme)))

;; current line hightlighting configuration
(use-package highlight-current-line
  :ensure highlight-current-line
  :init
  (progn
    (highlight-current-line-on t)
    (set-face-background 'highlight-current-line-face "#3a444d")
    (set-face-attribute 'region nil :background "#5d6e95")))


;; evil mode configuration
(use-package evil
  :ensure evil
  :init
  (progn
    (evil-mode 1)

    (define-key evil-normal-state-map [escape] 'keyboard-quit)
    (define-key evil-visual-state-map [escape] 'keyboard-quit)

    ;; incremental search keybinds
    ;; TODO: look into converging vim and emacs style incremental search to free up
    ;; keybinds, I like the vim-style "/" keybind but I was having issues with getting emacs
    ;; to play nicely with this.
    (define-key evil-motion-state-map (kbd "C-f") 'isearch-forward)
    (define-key evil-insert-state-map (kbd "C-f") 'isearch-forward)

    (define-key isearch-mode-map (kbd "C-n") 'isearch-repeat-forward)
    (define-key isearch-mode-map (kbd "C-p") 'isearch-repeat-backward)

    ;; window/buffer navigation keybinds
    (define-key evil-motion-state-map (kbd "C-w") 'other-window)
    (define-key evil-insert-state-map (kbd "C-w") 'other-window)))

;; relative line numbers
(use-package nlinum-relative
  :ensure nlinum-relative
  :init
  (progn
    (nlinum-relative-setup-evil) ; setup relative line numbers with evil
    (add-hook 'prog-mode-hook 'nlinum-relative-mode)

    (setq nlinum-relative-redisplay-delay 0
	  nlinum-relative-current-symbol "" ; display absolute line number on current line
	  nlinum-relative-offset 0)))


;; behaviour settings
(tool-bar-mode -1)
(scroll-bar-mode -1)
(custom-set-variables '(inhibit-startup-screen t))

;; default to creating horizontal splits
(setq
 split-height-threshold nil
 split-width-threshold 0)

;; add custom words to highlight
(mapc (lambda (mode)
	(font-lock-add-keywords
	 mode
	 '(("\\<\\(TODO\\):"  1 'font-lock-todo-face  t)
	   ("\\<\\(FIXME\\):" 1 'font-lock-fixme-face t))))
      '(c++-mode c-mode emacs-lisp-mode))

;; make creating a new split switch the cursor to the new split
(defadvice split-window (after move-point-to-new-window activate)
  "Moves the cursor to the newly created window after splitting."
  (other-window 1))
