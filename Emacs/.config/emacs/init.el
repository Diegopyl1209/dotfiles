;;; init.el --- my config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defun split-and-follow-horizontally ()
  "Split window horizontally and follow."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(defun split-and-follow-vertically ()
  "Split window vertically and follow."
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
  ;(setq-default indent-tabs-mode nil)
  ;(setq-default tab-width 2)
  ;(setq-default c-basic-offset tab-width)
  ;(setq standard-indent 2)
  (setq enable-recursive-minibuffers t)
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (setq-default display-line-numbers-width 4) ;; make window dont shift to right

  :hook
  (prog-mode-hook . display-line-numbers-mode)
  (prog-mode-hook . subword-mode)
  (text-mode-hook . display-line-numbers-mode))


(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (with-temp-buffer
    (write-file custom-file)))
(load custom-file)


(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-medium t))

(use-package async
  :ensure t
  :init
  (async-bytecomp-package-mode 1)
  (dired-async-mode 1))

(use-package undo-fu
  :ensure t
  :bind (("C-z" . 'undo-fu-only-undo)
		 ("C-S-z" . 'undo-fu-only-redo)))

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
  (corfu-preview-current nil)    ;; Disable current candidate preview

  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-tex))

(use-package flycheck
  :ensure t
  :hook ((after-init . global-flycheck-mode)
         ;; Show diagnostics inline
         ;(after-init . global-flycheck-annotate-mode)
	 )
  :config
  (global-flycheck-eglot-mode 1))

;; (use-package go-mode
;;   :ensure t)

(use-package rust-mode
  :ensure t
  :mode ("\\.rs\\'" . rust-mode))

(use-package zig-ts-mode
  :ensure t
  :mode ("\\.zig\\'" . zig-ts-mode))


(provide 'init)
;;; init.el ends here


