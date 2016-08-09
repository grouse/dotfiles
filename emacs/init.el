; packages configuration
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/themes")

(require 'compile)

(require 'evil)
(evil-mode 1)

(require 'nlinum-relative)
(nlinum-relative-setup-evil)
(add-hook 'prog-mode-hook 'nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0) 
(setq nlinum-relative-current-symbol "") 
(setq nlinum-relative-offset 0)

(require 'color-theme)
(color-theme-initialize)

(require 'color-theme-wombat)
(load-theme 'wombat t t)
(enable-theme 'wombat)

(require 'whitespace)
(global-whitespace-mode t)
(setq whitespace-style '(face empty tabs lines-tail trailing))

(require 'frame-restore)
(progn (require 'desktop) (customize-set-variable 'desktop-enable t) (require 'frame-restore))

(require 'highlight-current-line)
(highlight-current-line-on t)
(set-face-background 'highlight-current-line-face "#3a444d")

; functions
(defun open-project (directory)
  (interactive (list (read-directory-name "project path:")))
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


; behaviour settings
(tool-bar-mode -1)
(scroll-bar-mode -1)
(custom-set-variables '(inhibit-startup-screen t))

(setq
 split-height-threshold nil
 split-width-threshold 0)

; make creating a new split switch the cursor to the new split
(defadvice split-window (after move-point-to-new-window activate)
  "Moves the cursor to the newly created window after splitting."
  (other-window 1))

; evil mode keybinds
; give me back my escape key
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

; evil/vim key overrides
(eval-after-load "evil-maps" (dolist (
	map '(evil-motion-state-map
	      evil-insert-state-map 
	      evil-emacs-state-map))

	(define-key (eval map) "\C-f" nil)
	(global-set-key (kbd "C-f") 'isearch-forward)

	(define-key (eval map) "\C-n" nil)
	(define-key (eval map) "\C-p" nil)
	(define-key isearch-mode-map (kbd "C-n") 'isearch-repeat-forward)
	(define-key isearch-mode-map (kbd "C-p") 'isearch-repeat-backward)

	(define-key (eval map) "\C-w" nil)
	(global-set-key (kbd "C-w") 'other-window)))

; general keybinds
(global-set-key (kbd "C-s") 'split-window-horizontally)
(global-set-key (kbd "C-S-s") 'split-window-vertically)

(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

