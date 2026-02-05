;;; early-init.el --- Emacs config -*- lexical-binding: t -*-

(setq native-comp-async-report-warnings-errors 'silent)
(setq byte-compile-warnings nil)

(setq gc-cons-threshold most-positive-fixnum
	  gc-cons-percentage 0.6
	  vc-handled-backends '(Git))

(setq frame-resize-pixelwise t
	  frame-inhibit-implied-resize t
	  frame-title-format '("Emacs"))

(setq default-frame-alist '((width . 200) (height . 60)))

(setq inhibit-startup-message t)
