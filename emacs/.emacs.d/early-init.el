;; early-init.el -- -*- lexical-binding: t; -*-

;;; Code:

(setq gc-cons-threshold most-positive-fixnum
	  gc-cons-percentage 0.6
	  vc-handled-backends '(Git))

;; Better Window Management handling
(setq frame-resize-pixelwise t
	  frame-inhibit-implied-resize t
	  frame-title-format '("Emacs"))

(setq inhibit-compacting-font-caches t)

;; Disables unused UI Elements
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

;; Disable package.el
(setq package-enable-at-startup nil)


(provide 'early-init)
;;; early-init.el ends here
