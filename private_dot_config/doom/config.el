;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Diego Peña y Lillo"
      user-mail-address "diegopyl1209@gmail.com")


;; UI

(setq doom-theme 'doom-gruvbox)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

(setq display-line-numbers-type 'relative)


;; Completion

(after! corfu
  (setq corfu-auto nil))


;; Major Modes

(use-package! nix-ts-mode
  :mode "\\.nix\\'")


;; Org

(setq org-directory "~/org/")

