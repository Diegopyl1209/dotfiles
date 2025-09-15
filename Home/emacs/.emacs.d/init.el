;; init.el -- -*- lexical-binding: t; -*-

;;; COMMENTARY:

;;this is my Emacs's config do whatever you want with it.

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
  :bind(("M-j" . duplicate-dwin)
	("M-g r" . recentf-open)
	("M-s g" . grep)
	("M-s f" . find-name-dired)
	("C-z" . nil)
	("C-x C-z" . nil)
	("C-x C-k RET" . nil))
  :custom
  (delete-by-moving-to-trash t)
  (enable-recursive-minibuffers t)
  (find-ls-option '("-exec ls -ldh {} +" . "-ldh"))  ; find-dired results with human readable sizes
  (history-lenght 300)
  (use-short-answers t)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (inhibit-startup-message t)
  (create-lockfiles nil)
  (make-backup-files t)
  (backup-directory-alist
   `(("." . ,(expand-file-name "backup" user-emacs-directory))))
  (tramp-backup-directory-alist backup-directory-alist)
  (backup-by-copying t)
  (delete-old-versions t)
  (version-control t)
  (kept-new-versions 5)
  (kept-old-versions 5)
  (vc-git-print-log-follow t)
  (vc-make-backup-files nil)  ; Do not backup version controlled files
  (vc-git-diff-switches '("--histogram"))
  (auto-save-default t)
  (auto-save-interval 300)
  (auto-save-timeout 30)
  (auto-save-no-message t)
  (auto-save-include-big-deletions t)
  (auto-save-list-file-prefix
   (expand-file-name "autosave/" user-emacs-directory))
  (tramp-auto-save-directory
   (expand-file-name "tramp-autosave/" user-emacs-directory))
  (kill-buffer-delete-auto-save-files t)
  (kill-do-not-save-duplicates t)
  (revert-without-query (list "."))
  (auto-revert-stop-on-user-input nil)
  (auto-revert-verbose t)
  (global-auto-revert-non-file-buffers t)
  (global-auto-revert-ignore-modes '(Buffer-menu-mode))
  (recentf-max-saved-items 300) ; default is 20
  (recentf-max-menu-items 15)
  (recentf-auto-cleanup 'mode)
  (recentf-exclude (list "^/\\(?:ssh\\|su\\|sudo\\)?:"))
  (save-place-file (expand-file-name "saveplace" user-emacs-directory))
  (save-place-limit 600)
  (resize-mini-windows 'grow-only)
  (window-divider-default-bottom-width 1)
  (window-divider-default-places t)
  (window-divider-default-right-width 1)
  (redisplay-skip-fontification-on-input t)
  (fast-but-imprecise-scrolling t)
  (scroll-error-top-bottom t)
  (scroll-preserve-screen-position t)
  (scroll-conservatively 101)
  (left-fringe-width  8)
  (right-fringe-width 8)
  (word-wrap t)
  (truncate-lines t)
  (tab-width 4)
  (c-basic-offset tab-width)
  (cperl-indent-level tab-width)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (comment-multi-line t)
  (comment-empty-lines t)
  (fill-column 80)
  (sentence-end-double-space nil)
  (require-final-newline t)
  (lazy-highlight-initial-delay 0)
  (xref-show-definitions-function 'xref-show-definitions-completing-read)
  (xref-show-xrefs-function 'xref-show-definitions-completing-read)

  :config
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 100)
  (setq-default display-line-numbers-type 'relative)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)

  :init
  (global-auto-revert-mode 1)
  (recentf-mode 1)
  (repeat-mode 1)
  (savehist-mode 1)
  (save-place-mode 1))

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

;;; MODELINE
;; (use-package doom-modeline
;;   :straight t
;;   :init (doom-modeline-mode 1))

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
	 ("\\*\\(compilation\\)\\*"
		(display-buffer-below-selected)
		(window-height . 0.25))
	 ("\\*\\(vterm\\)\\*"
		(display-buffer-in-direction)
		(direction . right)
		(window-width . 0.4))
	 )))

;;; ACE-WINDOW
(use-package ace-window
	:straight t
	:bind ("M-o" . 'ace-window)
	:config
	(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;;; VERTICO
;; (use-package vertico
;;	:straight t
;;	:init
;;	(vertico-mode))
;;
;; (use-package vertico-directory
;;	:after vertico
;;	:ensure nil
;;	:bind (:map vertico-map
;;				("RET" . vertico-directory-enter)
;;				("DEL" . vertico-directory-delete-char)
;;				("M-DEL" . vertico-directory-delete-word))
;;	;; Tidy shadowed file names
;;	:hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;;; IDO
(use-package ido
  :ensure nil
  :init
  (ido-mode 1)
  (ido-everywhere 1))

(use-package ido-completing-read+
  :straight t
  :init
  (ido-ubiquitous-mode 1))

;;; ORDERLESS
(use-package orderless
	:straight t
	:custom
	(completion-styles '(orderless basic))
	(completion-category-defaults nil)
	(completion-category-overrides '((file (styles partial-completion)))))

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

	:bind (:map
		 eglot-mode-map
		 ("C-c l a" . eglot-code-actions)
		 ("C-c l o" . eglot-code-actions-organize-imports)
		 ("C-c l r" . eglot-rename)
		 ("C-c l f" . eglot-format)))

;;; LSP-MODE
(use-package lsp-mode
  :straight t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands lsp
  :custom
  (lsp-modeline-diagnostics-enable nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-signature-render-documentation nil)
  (lsp-enable-symbol-highlighting nil)
  (lsp-lens-enable nil)
  (lsp-headerline-breadcrumb-enable nil))

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
	;;(flymake-show-diagnostics-at-end-of-line 'short)
	(flymake-indicator-type 'fringes)
	;; (flymake-margin-indicators-string
	;;  `((error "!" compilation-error)
	;;  (warning "?" compilation-warning)
	;;  (note "i" compilation-info))))
	)

;;; CORFU
(use-package corfu
	:straight t
	:commands (corfu-mode global-corfu-mode)
	:hook ((prog-mode . corfu-mode)
		 (shell-mode . corfu-mode)
		 (eshell-mode . corfu-mode))
	:custom
	(text-mode-ispell-word-completion nil)
	:config
	(global-corfu-mode))

;;; CAPE
(use-package cape
	:straight t
	:commands (cape-dabbrev cape-file cape-elisp-block)
	:bind ("C-c p" . cape-prefix-map)
	:init
	(add-hook 'completion-at-point-functions #'cape-dabbrev)
	(add-hook 'completion-at-point-functions #'cape-file)
	(add-hook 'completion-at-point-functions #'cape-elisp-block))

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

;;; NEOTREE
(use-package neotree
	:straight t
	:bind ([f8] . neotree-toggle)
	)

;; VTERM
(use-package vterm
	:straight t
	:bind (("C-c t" . vterm)))

(provide 'init)
;;; init.el ends here
