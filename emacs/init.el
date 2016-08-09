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

;; built-in packages
(require 'compile)
(require 'whitespace)
(require 'frame-restore)
(require 'color-theme)
(require 'color-theme-wombat)

;; 3rd party packages
(use-package evil                   :ensure evil                   :init)
(use-package nlinum-relative        :ensure nlinum-relative        :init)
(use-package highlight-current-line :ensure highlight-current-line :init)

(evil-mode 1)

(nlinum-relative-setup-evil)
(add-hook 'prog-mode-hook 'nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0)
(setq nlinum-relative-current-symbol "")
(setq nlinum-relative-offset 0)

(color-theme-initialize)

(load-theme 'wombat t t)
(enable-theme 'wombat)

(global-whitespace-mode t)
(setq whitespace-style '(face empty tabs lines-tail trailing))


(highlight-current-line-on t)
(set-face-background 'highlight-current-line-face "#3a444d")
(set-face-attribute 'region nil :background "#5d6e95")

;; functions
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


;; behaviour settings
(tool-bar-mode -1)
(scroll-bar-mode -1)
(custom-set-variables '(inhibit-startup-screen t))

(setq
 split-height-threshold nil
 split-width-threshold 0)

;; make creating a new split switch the cursor to the new split
(defadvice split-window (after move-point-to-new-window activate)
  "Moves the cursor to the newly created window after splitting."
  (other-window 1))

;; evil mode keybinds
;; give me back my escape key
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; evil/vim key overrides
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

;; general keybinds
(global-set-key (kbd "C-s") 'split-window-horizontally)
(global-set-key (kbd "C-S-s") 'split-window-vertically)

;; compilation keybinds
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

