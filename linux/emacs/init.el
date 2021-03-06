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

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
   (load custom-file))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/"))

(defun ensure-package-installed (&rest packages)
  (mapc
   (lambda (package)
     (unless (package-installed-p package)
       (package-install package)
       ))
   packages))

(package-initialize)

(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed 'use-package)
(ensure-package-installed 'treemacs 'treemacs-projectile 'lsp-treemacs 'cmake-mode 'gitlab-ci-mode 'clang-format)

;; disable auto-save and auto-backup
(setq auto-save-default nil)
(setq make-backup-files nil)

(defun indentation-style ()
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))
(indentation-style)

(setq-default truncate-lines 0) ;; disable line wrap

(setq compilation-scroll-output t)

(setq-default tab-width 4)
(setq-default c-basic-offset 4)

(setq use-package-always-ensure t)

(defalias 'yes-or-no-p 'y-or-n-p)

(cua-mode t) ;; enable cua-mode
(menu-bar-mode -1) ;; disable menu bar
(global-display-line-numbers-mode) ;; show line numbers
(show-paren-mode) ;; enable paren matching

(column-number-mode t)
(line-number-mode t)

(setq sml/theme 'dark)
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

(global-set-key (kbd "C-<up>") (lambda()
    (interactive)
    (scroll-down 4)))

(global-set-key (kbd "C-<down>") (lambda()
    (interactive)
    (scroll-up 4)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package undo-tree
  :ensure t
  :config
    (global-undo-tree-mode)
)

(use-package smart-mode-line
  :ensure t
  :config
    (smart-mode-line-enable t)
)

(use-package projectile
  :ensure t
  :init
    (setq projectile-project-search-path '("~/projects/"))
  :bind (:map global-map
              ("<f5>" . projectile-compile-project)
              ("<f6>" . projectile-run-project)
              ("<f7>" . projectile-test-project)
        )
)

(use-package magit
  :ensure t
  :bind (:map global-map
              ("C-x g" . magit-status)
        )
)

(use-package treemacs
  :ensure t
  :bind
  (:map global-map
        ("C-x t 1" . treemacs-delete-other-windows)
        ("C-x t t" . treemacs)
        ("C-x t B" . treemacs-bookmark))
)

(use-package helm
  :ensure t
  :bind (:map global-map
              ("M-x" . helm-M-x)
              ("C-x b" . helm-buffers-list)
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
  :bind (:map global-map
              ("C-f" . helm-swoop-without-pre-input)
        )
)

(use-package move-text
  :ensure t
  :bind (:map global-map
              ("C-S-<up>" . move-text-up)
              ("C-S-<down>" . move-text-down)
        )
)

(use-package buffer-move
  :ensure t
  :bind (:map global-map
              ("M-<up>" . buf-move-up)
              ("M-<down>" . buf-move-down)
              ("M-<left>" . buf-move-left)
              ("M-<right>" . buf-move-right)
        )
)

(use-package goto-line-preview
  :ensure t
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
  :bind (:map global-map
              ("C-x z" . zoom-window-zoom)
        )
)

(use-package crux
  :ensure t
  :bind (:map global-map
              ("S-<delete>" . crux-kill-whole-line)
              ("C-d" . crux-duplicate-current-line-or-region)
        )
)

(use-package cff
  :ensure t
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
  :config
    (xclip-mode 1)
)

(use-package company
  :ensure t
  :defer t
  :config
    (global-company-mode)
)

(use-package company-lsp
  :ensure t
  :defer t
  :init
    (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)
    (setq xref-prompt-for-identifier '(not xref-find-definitions xref-find-definitions-other-window xref-find-definitions-other-frame xref-find-references))
  :config
    (push 'company-lsp company-backends)
)

(use-package flycheck
  :ensure t
  :init
    (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-gcc c/c++-cppcheck emacs-lisp-checkdoc))
  :config
    (global-flycheck-mode)
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
  :bind (:map lsp-mode-map
              ("<f2>" . lsp-find-definition)
              ("<f3>" . lsp-find-references)
        )
  :init
    (setq ccls-executable "/usr/bin/ccls")
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

(use-package rust-mode
  :init
    (setq rust-format-on-save t)
    (setq lsp-rust-server 'rust-analyzer)
  :bind (:map rust-mode-map
              ("M-RET" . lsp-execute-code-action)
             ))

(use-package lsp-mode
  :ensure t
  :hook ((python-mode . lsp)
         (rust-mode . lsp))
)

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

;; https://stackoverflow.com/questions/1771102/changing-emacs-forward-word-behaviour
(defun my-syntax-class (char)
  "Return ?s, ?w or ?p depending or whether CHAR is a white-space, word or punctuation character."
  (pcase (char-syntax char)
      (`?\s ?s)
      (`?w ?w)
      (`?_ ?w)
      (_ ?p)))

(global-set-key (kbd "<f9>") (lambda(arg)
                               (interactive "P")
                               (require 'projectile)
                               (require 'helm-files)
                               (helm-grep-ag (projectile-project-root) arg)))
