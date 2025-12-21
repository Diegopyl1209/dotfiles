;;; init.el --- Emacs config -*- lexical-binding: t -*-

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


(use-package emacs
  :bind(("s-C-<left>" . 'shrink-window-horizontally)
	("s-C-<right>" . 'enlarge-window-horizontally)
	("s-C-<down>" . 'shrink-window)
	("s-C-<up>" . 'enlarge-window))
  :init
  (defalias 'yes-or-no-p 'y-or-n-p)
  (savehist-mode 1)
  (show-paren-mode 1)
  (global-hl-line-mode 1)
  (global-prettify-symbols-mode 1)
  (context-menu-mode 1)
  (electric-pair-mode 1)

  :custom
  (make-backup-files nil)
  (auto-save-default nil)
  (scroll-conservatively 100)

  (tab-width 4)
  (standard-indent 4)
  (c-basic-offset tab-width)
  (indent-tabs-mode t)
  (electric-indent-inhibit t)
  (backward-delete-char-untabify-method nil)

  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))

  :hook
  (prog-mode-hook . display-line-numbers-mode)
  (text-mode-hook . display-line-numbers-mode))

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)


 (use-package async
	:straight t
	:init
	(dired-async-mode 1))


(use-package undo-fu
	:straight t
	:bind (("C-z" . 'undo-fu-only-undo)
		 ("C-S-z" . 'undo-fu-only-redo)))


(use-package doom-themes
  :straight t
  :init
  (load-theme 'doom-gruvbox t))


(use-package mood-line
  :straight t
  :config
  (mood-line-mode)

  :custom
  (mood-line-format
   '(("┃ " (mood-line-segment-modal) " "
      (or (mood-line-segment-buffer-status) " ") " "
      (mood-line-segment-buffer-name) "  "
      (mood-line-segment-anzu) "  "
      (mood-line-segment-multiple-cursors) "  "
      (mood-line-segment-cursor-position) " "
      (mood-line-segment-scroll) "")
	 
     ((mood-line-segment-vc) "  "
      (mood-line-segment-major-mode) "  "
      (mood-line-segment-misc-info) "  "
      (mood-line-segment-checker) "  "
      (mood-line-segment-process) "  ")))
  
    (mood-line-glyph-alist mood-line-glyphs-fira-code))


(use-package which-key
  :straight t
  :init
  (which-key-mode))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package marginalia
  :straight t
  :init
  (marginalia-mode))


(use-package consult
  :straight t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key nil
   consult-buffer :preview-key nil
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   :preview-key "M-.")

  (setq consult-narrow-key "<"))


(use-package corfu
  :straight t
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match 'insert) ;; Configure handling of exact matches

  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package kind-icon
  :straight t
  :after corfu
  
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :straight t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-tex))


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

