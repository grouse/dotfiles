;; Jesper Stefansson (jesper.stefansson@gmail.com)
;;==============================================================================
;;= Table of Contents
;;==============================================================================
;;  a) Plugins
;;  b) Appearance
;;  c) Core behaviour
;;  d) Custom behaviour
;;  e) Keybindings
;;  f) Hooks
;;
;;==============================================================================
;;= a) Plugins
;;==============================================================================
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; compilatation configuration
(require 'compile)
(with-eval-after-load "compile"
  (global-set-key (kbd "<f5>") 'my-compile)
  (global-set-key (kbd "M-n") 'next-error)
  (global-set-key (kbd "M-p") 'previous-error))

;; smart tabs configuration - indents with tab, aligns with spaces
(use-package smart-tabs-mode
  :ensure smart-tabs-mode
  :init
  (progn
    (smart-tabs-insinuate 'c 'c++)))

(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/themes")

(use-package flx-ido
  :ensure flx-ido
  :init
  (progn
	(ido-mode 1)
	(ido-everywhere 1)
	(flx-ido-mode 1)

	(setq ido-enable-flex-matching t)
	(setq ido-use-faces nil)))

(use-package projectile
  :ensure projectile
  :init
  (progn
	(projectile-global-mode)
	(setq projectile-tags-command "ctags-exuberant --extra=+q -Re -f \"%s\" %s")

	(global-set-key (kbd "C-l") 'projectile-find-file)
	(global-set-key (kbd "<f2>") 'projectile-find-tag)))

(use-package smooth-scrolling
  :ensure smooth-scrolling
  :init
  (progn
    (smooth-scrolling-mode 1)))

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

    (define-key evil-motion-state-map (kbd ";") 'evil-ex)

    (define-key isearch-mode-map (kbd "C-n") 'isearch-repeat-forward)
    (define-key isearch-mode-map (kbd "C-p") 'isearch-repeat-backward)

    ;; window/buffer navigation keybinds
    (define-key evil-motion-state-map (kbd "C-w") 'other-window)
    (define-key evil-insert-state-map (kbd "C-w") 'other-window)))

;;==============================================================================
;;= b) Appearance
;;==============================================================================
;; custom faces and colours
(make-face 'font-lock-note-face)
(make-face 'font-lock-todo-face)

;; custom highlights
(setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))

(mapc (lambda (mode)
       (font-lock-add-keywords
        mode
        '(("\\<\\(TODO\\)"  1 'font-lock-todo-face  t)
          ("\\<\\(note\\)" 1 'font-lock-note-face t))))
 '(c++-mode c-mode emacs-lisp-mode))


(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'grouse t)

;; visualise tabs
(setq whitespace-style '(tabs tab-mark))
(global-whitespace-mode t)

;;==============================================================================
;;= c) Core behaviour
;;==============================================================================
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(setq
 auto-save-default nil
 make-backup-files nil)

(setq ring-bell-function 'ignore)

(defun my-tab-settings ()
 (setq
  tab-width 4
  c-default-style "linux"
  c-basic-offset 'tab-width))

(defadvice split-window (after move-point-to-new-window activate)
  "Moves the cursor to the newly created window after splitting."
  (other-window 1))


;; scrolling
(setq
 scroll-step 1
 mouse-wheel-scroll-amount '(2 ((shift) . 2) ((control) . nil))
 mouse-wheel-progressive-speed nil)

;;==============================================================================
;;= d) Custom behaviour
;;==============================================================================
(defun open-project ()
  (interactive)
  (projectile-switch-project)
  (let ((project-root (projectile-project-root)))
	(setq compile-command (concat project-root "build.sh"))))

(defun my-compile ()
  (interactive)

  (let ((project-root (projectile-project-root)))
	(setq compile-command (concat project-root "build.sh")))

  (if (not (get-buffer-window "*compilation*"))
	  (progn
		(split-window-vertically -10)

		(switch-to-buffer "*compilation*")
		(call-interactively 'compile)
		(other-window -1))
	(progn
	  (call-interactively 'recompile))))

(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
 In Delete Selection mode, if the mark is active, just deactivate it;
 then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(defvar cpp-other-file-alist
  '(("\\.cpp\\'" (".hpp" ".h"))
    ("\\.c\\'" (".h"))
    ("\\.h\\'" (".c" ".cpp"))))

(setq ff-other-file-alist 'cpp-other-file-alist)
(defun ff-get-other-file-other-window ()
  (ff-get-other-file 'other-window))

;;==============================================================================
;;= e) Keybindings
;;==============================================================================
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

;;==============================================================================
;;= f) Hooks
;;==============================================================================
(add-hook 'text-mode-hook 'my-tab-settings)
(add-hook 'prog-mode-hook 'my-tab-settings)

