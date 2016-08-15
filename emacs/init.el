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

(defun ff-get-other-file-other-window ()
  (ff-get-other-file 'other-window))

;; colour scheme settings
(require 'color-theme)
(require 'color-theme-wombat)
(with-eval-after-load "color-theme"
  (color-theme-initialize)
  (load-theme 'wombat t t)
  (enable-theme 'wombat))

;; compilatation configuration
(require 'compile)
(with-eval-after-load "compile"
    (global-set-key (kbd "<f5>") 'compile)
    (global-set-key (kbd "M-n") 'next-error)
    (global-set-key (kbd "M-p") 'previous-error))

;; current line highlighting configuration
(require 'highlight-current-line)
(highlight-current-line-on t)
(set-face-background 'highlight-current-line-face "#3a444d")
(set-face-attribute 'region nil :background "#5d6a95")

;; powerline configuration
(use-package powerline
  :ensure powerline
  :init
  (progn
    (powerline-default-theme)))

;; smart tabs configuration - indents with tab, aligns with spaces
(use-package smart-tabs-mode
  :ensure smart-tabs-mode
  :init
  (progn
    (smart-tabs-insinuate 'c 'c++)))

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

;; general keybinds
(global-set-key (kbd "C-s") 'split-window-horizontally)
(global-set-key (kbd "C-S-s") 'split-window-vertically)

(global-set-key (kbd "<f4>") 'ff-get-other-file)
(global-set-key (kbd "S-<f4>") 'ff-get-other-file-other-window) 

;; give me back my escape key
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; vim-like keybindings for the packages menu
(define-key package-menu-mode-map (kbd "j") 'next-line)
(define-key package-menu-mode-map (kbd "k") 'previous-line)
(define-key package-menu-mode-map (kbd ":") 'evil-ex)
(define-key package-menu-mode-map (kbd "C-w") 'other-window)
(define-key package-menu-mode-map (kbd "C-f") 'isearch-forward)

;; custom faces
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-todo-face)

(modify-face 'font-lock-fixme-face "#ff0000" nil nil t nil t nil nil)
(modify-face 'font-lock-todo-face  "#00aa00" nil nil t nil t nil nil)

;; behaviour settings
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(custom-set-variables '(inhibit-startup-screen t))

(defvar cpp-other-file-alist
  '(("\\.cpp\\'" (".hpp" ".h")) 
    ("\\.c\\'" (".h"))
    ("\\.h\\'" (".c" ".cpp"))))

(setq-default
;; default to creating horizontal splits
 split-height-threshold nil
 split-width-threshold 0

 mouse-wheel-scroll-amount '(2 ((shift) . 2) ((control) . nil))
 mouse-wheel-progressive-speed nil

 ff-other-file-alist 'cpp-other-file-alist

 tab-width 4
 c-default-style "linux"
 c-basic-offset 4)

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
