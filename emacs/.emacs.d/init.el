;; init.el -- -*- lexical-binding: t; -*-


;;; CODE:

;;; STRAIGHT
(defvar bootstrap-version)
(let ((bootstrap-file
	   (expand-file-name
		"straight/repos/straight.el/bootstrap.el"
		(or (bound-and-true-p straight-base-dir)
			user-emacs-directory)))
	  (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
	(with-current-buffer
		(url-retrieve-synchronously
		 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
		 'silent 'inhibit-cookies)
	  (goto-char (point-max))
	  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
;;;(setq straight-use-package-by-default t)

;;; EMACS
(use-package emacs
  :ensure nil
  :bind (("M-o" . other-window)
	 ("M-j" . duplicate-dwim)
	 ("M-g r" . recentf)
	 ("M-s g" . grep)
	 ("M-s f" . find-name-dired)
	 ("<escape>" . keyboard-escape-quit)
	 ("C-z" . nil)
	 ("C-x C-z" . nil)
	 ("C-x C-k RET" . nil))
  :custom
  (ad-has-redefining-advice 'accept)
  (delete-by-moving-to-trash t)
  (display-line-numbers-width 3)
  (display-line-numbers-widen t)
  (enable-recursive-minibuffers t)
  (find-ls-option '("-exec ls -ldh {} +" . "-ldh"))  ; find-dired results with human readable sizes
  (frame-resize-pixelwise t)
  (global-auto-revert-non-file-buffers t)
  (help-window-select t)
  (history-lenght 300)
  (inhibit-startup-message t)
  ;;(initial-scratch-message "")
  (ispell-dictionary "es")
  (kill-do-not-save-duplicates t)
  (create-lockfiles nil)
  (make-backup-files nil)
  (backup-inhibited t)
  (ring-bell-function 'ignore)
  (visible-bell nil)
  (read-answer-short t)
  (recentf-max-saved-items 300) ; default is 20
  (recentf-max-menu-items 15)
  (recentf-auto-cleanup (if (daemonp) 300 'never))
  (recentf-exclude (list "^/\\(?:ssh\\|su\\|sudo\\)?:"))
  (remote-file-name-inhibit-delete-by-moving-to-trash t)
  (remote-file-name-inhibit-auto-save t)
  (resize-mini-windows 'grow-only)
  (scroll-conservatively 8)
  (scroll-margin 5)
  (save-place-file (expand-file-name "saveplace" user-emacs-directory))
  (save-place-limit 600)
  (split-width-threshold 170)     ; So vertical splits are preferred
  (split-height-threshold nil)
  (switch-to-buffer-obey-display-actions t)
  (tab-always-indent 'complete)
  (tab-first-completion 'word-or-paren-or-punct)
  (tab-width 4)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-hints t)
  (treesit-font-lock-level 4)
  (truncate-lines t)
  (undo-limit (* 13 160000))
  (undo-strong-limit (* 13 240000))
  (undo-outer-limit (* 13 24000000))
  (use-dialog-box nil)
  (use-file-dialog nil)
  (use-short-answers t)
  (window-combination-resize t)
  (window-resize-pixelwise nil)
  (xref-search-program 'ripgrep)
  (grep-command "rg -nS --no-heading ")
  (grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "build" "dist"))
  (read-extended-command-predicate #'command-completion-default-include-p)
  (left-fringe-width  8)
  (right-fringe-width 8)
  (indicate-buffer-boundaries nil)
  (indicate-empty-lines nil)
  (comment-multi-line t)
  (comment-empty-lines t)
  (fill-column 80)
  (sentence-end-double-space nil)
  (require-final-newline t)
  (xref-show-definitions-function 'xref-show-definitions-completing-read)
  (xref-show-xrefs-function 'xref-show-definitions-completing-read)

  :config
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 100)

  (setq display-line-numbers-type 'relative)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)

  :init
  (global-auto-revert-mode 1)
  (indent-tabs-mode -1)
  (recentf-mode 1)
  (repeat-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (winner-mode))


;;; THEME
(use-package doom-themes
  :straight t
  :config
  (load-theme 'doom-gruvbox t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;;; SOLAIRE-MODE
(use-package solaire-mode
  :straight t
  :init (solaire-global-mode +1))

;;; MODELINE
(use-package mood-line
  :straight t
  :config
  (mood-line-mode)

  :custom
  (mood-line-glyph-alist mood-line-glyphs-fira-code))

;;; NERDICONS
(use-package nerd-icons
  :straight t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

;;; COMPILATION
(use-package compile
  :ensure nil
  :hook
  (;; Not ideal, but I do not want this poluting the modeline
   (compilation-start . (lambda () (setq compilation-in-progress nil))))
  :custom
  (compilation-always-kill t)
  (compilation-scroll-output t)
  (ansi-color-for-compilation-mode t)
  :config
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter))


;;; WINDOW
(use-package window
  :ensure nil
  :custom
  (display-buffer-alist
   '(
	 ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Messages\\|Bookmark List\\|Occur\\|eldoc\\)\\*"
	  (display-buffer-in-side-window)
	  (window-height . 0.25)
	  (side . bottom)
	  (slot . 0))
	 ("\\*\\([Hh]elp\\)\\*"
	  (display-buffer-in-side-window)
	  (window-width . 75)
	  (side . right)
	  (slot . 0))
	 ("\\*\\(Ibuffer\\)\\*"
	  (display-buffer-in-side-window)
	  (window-width . 100)
	  (side . right)
	  (slot . 1))
	 ("\\*\\(Flymake diagnostics\\|xref\\|Completions\\)"
	  (display-buffer-in-side-window)
	  (window-height . 0.25)
	  (side . bottom)
	  (slot . 1))
	 ("\\*\\(grep\\|find\\)\\*"
	  (display-buffer-in-side-window)
	  (window-height . 0.25)
	  (side . bottom)
	  (slot . 2))
	 )))

;;; VERTICO
(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
			  ("RET" . vertico-directory-enter)
			  ("DEL" . vertico-directory-delete-char)
			  ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;;; ISEARCH
(use-package isearch
  :ensure nil
  :config
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) ")
  (setq lazy-count-suffix-format nil)
  (setq search-whitespace-regexp ".*?"))

;;; ELDOC
(use-package eldoc
  :ensure nil
  :init
  (global-eldoc-mode))

;;; EGLOT
(use-package eglot
  :ensure nil
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-events-buffer-config '(:size 0 :format full))
  (eglot-prefer-plaintext t)
  (jsonrpc-event-hook nil)
  (eglot-code-action-indications nil) ;; Emacs 31 -- annoying as hell
  :init
  (fset #'jsonrpc--log-event #'ignore)

  (defun emacs-solo/eglot-setup ()
	"Setup eglot mode with specific exclusions."
	(unless (eq major-mode 'emacs-lisp-mode)
	  (eglot-ensure)))

  (add-hook 'prog-mode-hook #'emacs-solo/eglot-setup)

  (with-eval-after-load 'eglot
	(add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp")))

  :bind (:map
		 eglot-mode-map
		 ("C-c l a" . eglot-code-actions)
		 ("C-c l o" . eglot-code-actions-organize-imports)
		 ("C-c l r" . eglot-rename)
		 ("C-c l f" . eglot-format)))

;;; FLYMAKE
(use-package flymake
  :ensure nil
  :defer t
  :hook (prog-mode . flymake-mode)
  :bind (:map flymake-mode-map
			  ("M-8" . flymake-goto-next-error)
			  ("M-7" . flymake-goto-prev-error)
			  ("C-c ! n" . flymake-goto-next-error)
			  ("C-c ! p" . flymake-goto-prev-error)
			  ("C-c ! l" . flymake-show-buffer-diagnostics)
			  ("C-c ! t" . toggle-flymake-diagnostics-at-eol))
  :custom
  (flymake-show-diagnostics-at-end-of-line nil)
  ;; (flymake-show-diagnostics-at-end-of-line 'short)
  (flymake-indicator-type 'margins)
  (flymake-margin-indicators-string
   `((error "!" compilation-error)      ;; Alternatives: », E, W, i, !, ?)
	 (warning "?" compilation-warning)
	 (note "i" compilation-info)))
  :config
  ;; Define the toggle function
  (defun toggle-flymake-diagnostics-at-eol ()
	"Toggle the display of Flymake diagnostics at the end of the line
and restart Flymake to apply the changes."
	(interactive)
	(setq flymake-show-diagnostics-at-end-of-line
		  (not flymake-show-diagnostics-at-end-of-line))
	(flymake-mode -1) ;; Disable Flymake
	(flymake-mode 1)  ;; Re-enable Flymake
	(message "Flymake diagnostics at end of line: %s"
			 (if flymake-show-diagnostics-at-end-of-line
				 "Enabled" "Disabled"))))

;;; WHITESPACE
(use-package whitespace
  :ensure nil
  :defer t
  :hook (before-save . whitespace-cleanup))

;;; MAN
(use-package man
  :ensure nil
  :commands (man)
  :config
  (setq Man-notify-method 'pushy))

;;; MINIBUFFER
(use-package minibuffer
  :ensure nil
  :custom
  (completion-ignore-case t)
  (completion-show-help t)
  (completions-max-height 20)
  (completions-format 'one-column)
  (completions-detailed t)
  (enable-recursive-minibuffers t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  :config
  (setq minibuffer-prompt-properties
		'(read-only t intangible t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Keep minibuffer lines unwrapped, long lines like on M-y will be truncated
  (add-hook 'minibuffer-setup-hook
		  (lambda () (setq truncate-lines t)))

  (minibuffer-depth-indicate-mode 1)
  (minibuffer-electric-default-mode 1))


;;; ELEC_PAIR
(use-package elec-pair
  :ensure nil
  :defer
  :hook (after-init . electric-pair-mode))

;;; PAREN
(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :custom
  (show-paren-delay 0)
  (show-paren-style 'mixed)
  (show-paren-context-when-offscreen t)) ;; show matches within window splits

;;; UNDO-FU
(use-package undo-fu
  :straight t
  :bind (("C-z" . 'undo-fu-only-undo)
		 ("C-S-z" . 'undo-fu-only-redo)))

;;; ORG
(use-package org
  :ensure nil
  :defer t
  :mode ("\\.org\\'" . org-mode)
  :custom
  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-todo-headline t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t))

(use-package org-superstar
  :straight t
  :config (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

;;; UNIQUIFY
(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-strip-common-suffix t)
  (setq uniquify-after-kill-buffer-p t))

;;; WHICH-KEY
(use-package which-key
  :defer t
  :ensure nil
  :hook
  (after-init . which-key-mode)
  :config
  (setq which-key-separator "  ")
  (setq which-key-prefix-prefix "... ")
  (setq which-key-max-display-columns 3)
  (setq which-key-idle-delay 1.5)
  (setq which-key-idle-secondary-delay 0.25)
  (setq which-key-add-column-padding 1)
  (setq which-key-max-description-length 40))

;;; WEBJUMP
(use-package webjump
  :defer t
  :ensure nil
  :bind ("C-x /" . webjump)
  :custom
  (webjump-sites
   '(("DuckDuckGo" . [simple-query "www.duckduckgo.com" "www.duckduckgo.com/?q=" ""])
	 ("Google" . [simple-query "www.google.com" "www.google.com/search?q=" ""])
	 ("YouTube" . [simple-query "www.youtube.com/feed/subscriptions" "www.youtube.com/rnesults?search_query=" ""])
	 ("ChatGPT" . [simple-query "https://chatgpt.com" "https://chatgpt.com/?q=" ""]))))

;;; ACE-WINDOW
(use-package ace-window
  :straight t
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;;; NEOTREE
(use-package neotree
  :straight t
  :bind ([f8] . neotree-toggle)
  )

;; VTERM
(defun my/vterm-right ()
  "Open vterm in a window split to the right."
  (interactive)
  (let ((new-window (split-window-right)))
	(select-window new-window)
	(vterm)))
(use-package vterm
  :straight t
  :bind (("C-c t" . my/vterm-right)))

(provide 'init)
;;; init.el ends here
