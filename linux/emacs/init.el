(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(elpy-modules
   '(elpy-module-company elpy-module-eldoc elpy-module-pyvenv elpy-module-highlight-indentation elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults))
 '(package-selected-packages
   '(use-package treemacs-magit treemacs-projectile lsp-treemacs treemacs markdown-preview-mode gitlab-ci-mode-flycheck gitlab-ci-mode cmake-mode smart-mode-line racer flycheck-rust rust-mode visual-regexp undo-tree highlight-symbol dockerfile-mode magit py-autopep8 elpy cff xclip buffer-move move-text zoom-window flycheck-clang-tidy crux goto-line-preview smartparens clang-format yasnippet helm helm-swoop company-lsp company ccls lsp-ui lsp-mode)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
   (load custom-file))

;; Disable GC for startup
(setq gc-cons-threshold (* 500 1024 1024)
      gc-cons-percentage 0.6)

;; Restore GC default values
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;; Increase data emacs can read from a process - mostly for LSP
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(add-hook 'emacs-startup-hook
          (lambda ()
            (message (format "Emacs startup time: %s" (emacs-init-time)))))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/"))

(when (< emacs-major-version 27)
  (package-initialize))

(package-install-selected-packages)

;; disable auto-save and auto-backup
(setq auto-save-default nil)
(setq make-backup-files nil)

(setq-default indent-tabs-mode nil) ;; disable tabs
(setq-default truncate-lines 0) ;; disable line wrap

(setq default-tab-width 4)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

(setq projectile-project-search-path '("~/projects/"))

(defalias 'yes-or-no-p 'y-or-n-p)

(cua-mode t) ;; enable cua-mode
(menu-bar-mode -1) ;; disable menu bar
(global-display-line-numbers-mode) ;; show line numbers
(show-paren-mode) ;; enable paren matching

(column-number-mode t)
(line-number-mode t)

(setq sml/theme 'dark)
(smart-mode-line-enable t)
(display-time-mode 0)

(add-hook 'dired-mode-hook 'hl-line-mode)

(load "~/projects/fzf.el/fzf.el")

;; environment
(setenv "FZF_DEFAULT_COMMAND" "rg --files --hidden -g '!.*/' -g '![Bb]uild/' -g '!.o'")

;; key bindings
(global-set-key (kbd "C-k") 'fzf-projectile)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-w") 'kill-current-buffer)
(global-set-key (kbd "C-x C-c") 'kill-emacs)

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

(global-set-key (kbd "<f2>") 'xref-find-definitions)
(global-set-key (kbd "<f3>") 'xref-find-references)
(global-set-key (kbd "<f5>") 'projectile-compile-project)

(global-set-key (kbd "C-<up>") (lambda()
    (interactive)
    (scroll-down 4)))

(global-set-key (kbd "C-<down>") (lambda()
    (interactive)
    (scroll-up 4)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package magit
  :ensure t
  :defer t
  :bind (:map global-map
              ("C-x g" . magit-status)
        )
)

(use-package treemacs
  :ensure t
  :defer t
  :bind
  (:map global-map
        ("C-x t 1" . treemacs-delete-other-windows)
        ("C-x t t" . treemacs)
        ("C-x t B" . treemacs-bookmark))
)

(use-package helm
  :ensure t
  :defer t
  :bind (:map global-map
              ("M-x" . helm-M-x)
              ("C-x b" . helm-buffers-list)
              ("<f6>" . helm-do-grep-ag)
        )
  :init
    (setq helm-M-x-fuzzy-match t)
    (setq helm-follow-mode-persistent t)
    (setq helm-buffer-max-length nil)
    (setq helm-grep-ag-command "rg --color=always --colors 'match:fg:black' --colors 'match:bg:yellow' --smart-case --no-heading --line-number %s %s %s")
    (setq helm-grep-ag-pipe-cmd-switches '("--colors 'match:fg:black'" "--colors 'match:bg:yellow'"))
  :config
    (helm-mode 1)
)

(use-package helm-swoop
  :ensure t
  :defer t
  :bind (:map global-map
              ("C-f" . helm-swoop-without-pre-input)
        )
)

(use-package move-text
  :ensure t
  :defer t
  :bind (:map global-map
              ("C-S-<up>" . move-text-up)
              ("C-S-<down>" . move-text-down)
        )
)

(use-package buffer-move
  :ensure t
  :defer t
  :bind (:map global-map
              ("M-<up>" . buf-move-up)
              ("M-<down>" . buf-move-down)
              ("M-<left>" . buf-move-left)
              ("M-<right>" . buf-move-right)
        )
)

(use-package goto-line-preview
  :ensure t
  :defer t
  :bind (:map global-map
              ("C-l" . goto-line-preview)
        )
)

(use-package visual-regexp
  :ensure t
  :defer t
)

(use-package zoom-window
  :ensure t
  :defer t
  :bind (:map global-map
              ("C-x z" . zoom-window-zoom)
        )
)

(use-package crux
  :ensure t
  :defer t
  :bind (:map global-map
              ("S-<delete>" . crux-kill-whole-line)
              ("C-d" . crux-duplicate-current-line-or-region)
        )
)

(use-package cff
  :ensure t
  :defer t
  :bind (:map global-map
              ("<f4>" . cff-find-other-file)
        )
)

(use-package smartparens
  :ensure t
  :defer t
  :config
    (smartparens-global-mode)
)

(use-package xclip
  :ensure t
  :defer t
  :config
    (xclip-mode 1)
)

(require 'company-lsp)
(push 'company-lsp company-backends)
(setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)

;; all languages
(setq xref-prompt-for-identifier '(not xref-find-definitions xref-find-definitions-other-window xref-find-definitions-other-frame xref-find-references))

(require 'flycheck)
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-gcc c/c++-cppcheck emacs-lisp-checkdoc))
(global-flycheck-mode)

(use-package company
  :ensure t
  :defer t
  :config
    (global-company-mode)
)

(use-package yasnippet
  :ensure t
  :defer t
  :config
    (yas-global-mode)
)

(use-package elpy
  :ensure t
  :defer t
  :config
    (elpy-enable)
)

(use-package py-autopep8
  :ensure t
  :defer t
  :config
    (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
)

(use-package ccls
  :ensure t
  :defer t
  :bind (:map global-map
              ("<f2>" . lsp-find-definition)
              ("<f3>" . lsp-find-references)
              )
  :init
    (setq ccls-executable "/usr/local/bin/ccls")
    (setq lsp-ui-sideline-show-hover nil)
    (setq lsp-enable-file-watchers nil)
    (add-hook 'c-mode-common-hook
              (lambda()
                (lsp)
                (lsp-mode)
                )
              )
)

(defun clang-format-buffer-when-used()
  "Only use clang-format when it's in the project root."
  (when (locate-dominating-file "." ".clang-format")
    (clang-format-buffer))
  ;; Evaluate to nil, else the file is considered already saved.
  nil)
(add-hook 'c++-mode-hook
  (lambda () (add-to-list 'write-contents-functions 'clang-format-buffer-when-used)))

(use-package dockerfile-mode
  :ensure t
  :defer t
  :init
    (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
)

(use-package yaml-mode
  :ensure t
  :defer t
  :init
    (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
)

(setq gdb-many-windows t
      gdb-use-separate-io-buffer t)

(advice-add 'gdb-setup-windows :after
            (lambda () (set-window-dedicated-p (selected-window) t)))


(advice-add 'gud-sentinel :after
            (lambda (proc msg)
              (when (memq (process-status proc) '(signal exit))
                (jump-to-register gud-window-register)
                (bury-buffer))))

(use-package racer
  :ensure t
  :config
    (add-hook 'racer-mode-hook #'company-mode)
)

(use-package rust-mode
  :ensure t
  :init
    (setq rust-format-on-save t)
  :config
    (add-hook 'rust-mode-hook #'racer-mode)
    (add-hook 'racer-mode-hook #'eldoc-mode)
    (add-hook 'rust-mode-hook #'flycheck-rust-setup)
    (global-set-key (kbd "<f2>") 'racer-find-definition)
)

(use-package flycheck-rust
  :ensure t
  :config
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
    (add-hook 'rust-mode-hook 'flycheck-mode)
)

;; https://stackoverflow.com/questions/1771102/changing-emacs-forward-word-behaviour
(defun my-syntax-class (char)
  "Return ?s, ?w or ?p depending or whether CHAR is a white-space, word or punctuation character."
  (pcase (char-syntax char)
      (`?\s ?s)
      (`?w ?w)
      (`?_ ?w)
      (_ ?p)))

(defun my-forward-word (&optional arg)
  "Move point forward a word (simulate behavior of Far Manager's editor).
With prefix argument ARG, do it ARG times if positive, or move backwards ARG times if negative."
  (interactive "^p")
  (or arg (setq arg 1))
  (let* ((backward (< arg 0))
         (count (abs arg))
         (char-next
          (if backward 'char-before 'char-after))
         (skip-syntax
          (if backward 'skip-syntax-backward 'skip-syntax-forward))
         (skip-char
          (if backward 'backward-char 'forward-char))
         prev-char next-char)
    (while (> count 0)
      (setq next-char (funcall char-next))
      (cl-loop
       (if (or                          ; skip one char at a time for whitespace,
            (eql next-char ?\n)         ; in order to stop on newlines
            (eql (char-syntax next-char) ?\s))
           (funcall skip-char)
         (funcall skip-syntax (char-to-string (char-syntax next-char))))
       (setq prev-char next-char)
       (setq next-char (funcall char-next))
       ;; (message (format "Prev: %c %c %c Next: %c %c %c"
       ;;                   prev-char (char-syntax prev-char) (my-syntax-class prev-char)
       ;;                   next-char (char-syntax next-char) (my-syntax-class next-char)))
       (when
           (or
            (eql prev-char ?\n)         ; stop on newlines
            (eql next-char ?\n)
            (and                        ; stop on word -> punctuation
             (eql (my-syntax-class prev-char) ?w)
             (eql (my-syntax-class next-char) ?p))
            (and                        ; stop on word -> whitespace
             this-command-keys-shift-translated ; when selecting
             (eql (my-syntax-class prev-char) ?w)
             (eql (my-syntax-class next-char) ?s))
            (and                        ; stop on whitespace -> non-whitespace
             (not backward)             ; when going forward
             (not this-command-keys-shift-translated) ; and not selecting
             (eql (my-syntax-class prev-char) ?s)
             (not (eql (my-syntax-class next-char) ?s)))
            (and                        ; stop on non-whitespace -> whitespace
             backward                   ; when going backward
             (not this-command-keys-shift-translated) ; and not selecting
             (not (eql (my-syntax-class prev-char) ?s))
             (eql (my-syntax-class next-char) ?s))
            )
         (cl-return))
       )
      (setq count (1- count)))))

(defun my-backward-word (&optional arg)
  (interactive "^p")
  (or arg (setq arg 1))
  (my-forward-word (- arg)))

(global-set-key (kbd "C-<left>") 'my-backward-word)
(global-set-key (kbd "C-<right>") 'my-forward-word)
