;;; early-init.el --- Emacs config -*- lexical-binding: t -*-

(setq package-enable-at-startup nil)

(setq gc-cons-threshold most-positive-fixnum
	  gc-cons-percentage 0.6
	  vc-handled-backends '(Git))

(setq frame-resize-pixelwise t
	  frame-inhibit-implied-resize t
	  frame-title-format '("Emacs"))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

(setq inhibit-startup-message t)
