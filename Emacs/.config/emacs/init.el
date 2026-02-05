;;; init.el --- Emacs config -*- lexical-binding: t -*-

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(use-package emacs
  :bind(("C-x 2" . 'split-and-follow-horizontally)
        ("C-x 3" . 'split-and-follow-vertically)
        ("s-C-<left>" . 'shrink-window-horizontally)
	    ("s-C-<right>" . 'enlarge-window-horizontally)
	    ("s-C-<down>" . 'shrink-window)
	    ("s-C-<up>" . 'enlarge-window))
  
  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (savehist-mode 1)
  (global-hl-line-mode 1)
  (global-prettify-symbols-mode 1)
  (context-menu-mode 1) ;; enable right-click
  (electric-pair-mode 1)
  (set-fringe-mode 10)

  :config
  ;;(setq make-backup-files nil)
  (setq backup-directory-alist '((".*" . "~/.Trash")))
  (setq version-control t)
  (setq delete-old-versions t)  
  (setq auto-save-default nil)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq standard-indent 4)
  (setq c-basic-offset tab-width)
  (setq enable-recursive-minibuffers t)
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (setq-default display-line-numbers-width 4) ;; make window dont shift to right
  
  :hook
  (prog-mode-hook . display-line-numbers-mode)
  (text-mode-hook . display-line-numbers-mode))


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (with-temp-buffer
    (write-file custom-file)))
(load custom-file)

(use-package async
  :ensure t
  :init
  (async-bytecomp-package-mode 1)
  (dired-async-mode 1))

(use-package undo-fu
  :ensure t
  :bind (("C-z" . 'undo-fu-only-undo)
		 ("C-S-z" . 'undo-fu-only-redo)))


(use-package doom-themes
  :ensure t
  :init
  (load-theme 'doom-gruvbox t))

(use-package mood-line
  :ensure t
  :init
  (mood-line-mode 1)

  :config
  (setq mood-line-format
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
  
  (setq mood-line-glyph-alist mood-line-glyphs-fira-code))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package corfu
  :ensure t
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
  :ensure t
  :after corfu
  
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-tex))

(use-package lsp-mode
  :ensure t
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

