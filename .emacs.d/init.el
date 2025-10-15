(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package org :load-path "~/.emacs.d/elpa/org-mode/lisp/")
(use-package org-latex-preview :load-path "~/.emacs.d/elpa/org-mode/lisp/"
  :config
  ;; Increase preview width
  (plist-put org-latex-preview-appearance-options
             :zoom 1.0)

  ;; ;; Use dvisvgm to generate previews
  ;; ;; You don't need this, it's the default:
  ;; (setq org-latex-preview-process-default 'dvisvgm)

  ;; Turn on `org-latex-preview-mode', it's built into Org and much faster/more
  ;; featured than org-fragtog. (Remember to turn off/uninstall org-fragtog.)
  (add-hook 'org-mode-hook 'org-latex-preview-mode)
  (add-hook 'org-mode-hook #'org-latex-preview)

  (setq org-latex-preview-mode-display-live t)

  (setq org-latex-preview-mode-update-delay 0.25))

;; Write backups to ~/.emacs.d/backup/
(setq backup-directory-alist '(("." . "~/.config/emacs/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old
(setq create-lockfiles nil)

    					;causes no job control in this shell error
    					;(setq shell-command-switch "-ic")

(setq use-dialog-box nil)

(add-to-list 'exec-path "~/.local/bin/")

(use-package exec-path-from-shell)
(setq exec-path-from-shell-arguments nil)
(setq exec-path-from-shell-debug t)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(setq global-auto-revert-non-file-buffers 1)
(global-auto-revert-mode 1)

(recentf-mode 1)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key))

;; daemon
(require 'server)
(unless (server-running-p)
  (server-start))
;; ask for pass without a window
(setq epg-pinentry-mode 'loopback)

(setq initial-scratch-message nil)
(setq inhibit-startup-screen t)

(scroll-bar-mode -1)    
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)    ;padding
(menu-bar-mode -1)
(defun display-startup-echo-area-message ()
  (message ""))

(column-number-mode)    ;line numbers
(setq display-line-numbers t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode) ;displays line nums in programming modes

(set-frame-parameter nil 'alpha-background 100)

(use-package olivetti
  :init
  (setq olivetti-body-width 100))

(use-package doom-themes
   :config
   ;; Global settings (defaults)
   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
         doom-themes-enable-italic t) ; if nil, italics is universally disabled

   ;; Enable flashing mode-line on errors
   (doom-themes-visual-bell-config)
   ;; Corrects (and improves) org-mode's native fontification.
   (doom-themes-org-config))

(set-face-attribute 'default nil :font "Iosevka Comfy" :height 150 :weight 'semibold)
(set-face-attribute 'variable-pitch nil :font "Iosevka Comfy Duo" :height 150 :weight 'semibold)
(set-face-attribute 'fixed-pitch nil :font "Iosevka Comfy" :height 150 :weight 'semibold)

(load-theme 'doom-gruvbox :no-confirm)


(add-hook 'org-mode-hook #'variable-pitch-mode)

(with-eval-after-load 'org
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-block nil :inherit 'fixed-pitch))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package all-the-icons)

(defun gawmk/show-welcome-buffer ()
  "Show *Welcome* buffer."
  (with-current-buffer (get-buffer-create "*Welcome*")
    (setq truncate-lines t)
    (let* ((buffer-read-only)
	     (image-path "~/sync/multimedia/pics/wallpapers/shepherd.png")
	     (image (create-image image-path))
	     (size (image-size image))
	     (height (cdr size))
	     (width (car size))
	   (top-margin (floor (/ (abs (- (window-height) height)) 2)))
	   (left-margin (floor (/ (abs (- (window-width) width)) 2)))
	     (prompt-title "Welcome to Emacs!"))
	(erase-buffer)
	(setq mode-line-format nil)
	(goto-char (point-min))
	(insert (make-string top-margin ?\n ))
	(insert (make-string left-margin ?\ ))
	(insert-image image)
	(insert "\n\n\n")
	(insert (make-string (floor (/ (- (window-width) (string-width prompt-title)) 2)) ?\ ))
	(insert prompt-title))
    (setq cursor-type nil)
    (read-only-mode +1)
    (switch-to-buffer (current-buffer))
    (local-set-key (kbd "q") 'kill-this-buffer)))
(gawmk/show-welcome-buffer)

(defun keyboard-escape-quit ()
  "Exit the current \"mode\" (in a generalized sense of the word).
This command can exit an interactive command such as `query-replace',
can clear out a prefix argument or a region,
can get out of the minibuffer or other recursive edit,
cancel the use of the current buffer (for special-purpose buffers),
or go back to just one window (by deleting all but the selected window)."
  (interactive)
  (cond ((eq last-command 'mode-exited) nil)
        ((> (minibuffer-depth) 0)
         (abort-recursive-edit)
         (current-prefix-arg
          nil)
         ((and transient-mark-mode mark-active)
          (deactivate-mark))
         ((> (recursion-depth) 0)
          (exit-recursive-edit))
         (buffer-quit-function
          (funcall buffer-quit-function))
         ((string-match "^ \\*" (buffer-name (current-buffer)))
          (bury-buffer)))))
(bind-key* "C-c" 'keyboard-escape-quit)  ;C-c as escape

(use-package general
  :ensure t
  :config
  ;; allow for shorter bindings -- e.g., just using things like nmap alone without general-* prefix
  (general-evil-setup t)

  ;; To automatically prevent Key sequence starts with a non-prefix key errors without the need to
  ;; explicitly unbind non-prefix keys, you can add (general-auto-unbind-keys) to your configuration
  ;; file. This will advise define-key to unbind any bound subsequence of the KEY. Currently, this
  ;; will only have an effect for general.el key definers. The advice can later be removed with
  ;; (general-auto-unbind-keys t).
  (general-auto-unbind-keys)
  (general-create-definer gawmk/leader-key
    :states '(normal visual insert emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (define-key minibuffer-mode-map (kbd "C-j") 'previous-history-element)
  (define-key minibuffer-mode-map (kbd "C-k") 'next-history-element)

  (gawmk/leader-key
    "mc" '(compile :which-key "compile")
    "tt" '(vterm :which-key "launch and rename vterm")
    "ff" '(find-file :which-key "find file")
    "rf" '(consult-recent-file :which-key "open recent file")
    "hf" '(describe-function :which-key "describe function")
    "hb" '(describe-bindings :which-key "describe bindings")
    "hv" '(describe-variable :which-key "describe variable")))

(use-package evil
    :init
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    (setq evil-want-C-i-jump nil)
    :config
    (evil-set-undo-system 'undo-redo)
    (evil-mode 1)
    (define-key evil-motion-state-map (kbd "RET") nil)
    (define-key evil-insert-state-map (kbd "C-c") 'evil-normal-state)
    (define-key evil-insert-state-map (kbd "C-p") 'nil)
    (define-key evil-normal-state-map (kbd "C-p") 'nil)
    (define-key evil-normal-state-map (kbd "C-v") 'evil-visual-line)
    (define-key evil-normal-state-map (kbd "S-v") 'evil-visual-block)
    (define-key evil-normal-state-map (kbd "C-a") 'evil-append-line)
    (define-key evil-normal-state-map (kbd "L") 'evil-end-of-line)
    (define-key evil-normal-state-map (kbd "H") 'evil-beginning-of-line)
    (define-key evil-normal-state-map (kbd "&") 'async-shell-command)
    (define-key evil-visual-state-map (kbd "C-/") 'comment-or-uncomment-region)
    ;; Use visual line motions even outside of visual-line-mode buffers
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

    (evil-set-initial-state 'messages-buffer-mode 'normal))

  (use-package evil-collection
    :after evil
    :config
    (evil-collection-init))

(eval-after-load "evil-maps"
  (dolist (map '(evil-motion-state-map
                 evil-insert-state-map
                 evil-emacs-state-map))
    (define-key (eval map) "\C-w" nil)))
(define-key global-map "\C-w" nil)

(use-package hydra)
(defhydra hydra-text-scale (:timeout 3)
  "zoom"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("d" nil "done" :exit t))

(defhydra hydra-resize-windows (:timeout 3)
  "resize windows"
  ("l" evil-window-increase-width "increase width")
  ("h" evil-window-decrease-width "decrease width")
  ("k" evil-window-increase-height "increase height")
  ("j" evil-window-decrease-height "decrease height")
  ("d" nil "done" :exit t))

(gawmk/leader-key
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "rw" '(hydra-resize-windows/body :which-key "resize windows"))

(gawmk/leader-key
  "st" '(tab-switch :which-key "switch tab")
  "kb" '(kill-buffer :which-key "kill buffer")
  "sb" '(consult-buffer :which-key "switch buffer"))

;; Enable Vertico.
(use-package vertico
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-resize t)
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode)
  :bind (:map vertico-map
	 ("C-k" . 'vertico-previous)
	 ("C-j" . 'vertico-next)))
   

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-s" . consult-line))

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package project)
(defun my-project-shell ()
  "override the standard eshell to launch vterm in project root"
  (interactive)
  (require 'comint)
  (let* ((default-directory (project-root (project-current t)))
         (default-project-shell-name (project-prefixed-buffer-name "vterm"))
         (shell-buffer (get-buffer default-project-shell-name)))
    (if (and shell-buffer (not current-prefix-arg))
        (if (comint-check-proc shell-buffer)
            (pop-to-buffer shell-buffer (bound-and-true-p display-comint-buffer-action))
          (vterm shell-buffer))
      (vterm (generate-new-buffer-name default-project-shell-name)))))

(advice-add 'project-shell :override #'my-project-shell)

(gawmk/leader-key
  "pf" '(project-find-file :which-key "find a file in project")
  "pt" '(project-shell :which-key "launch a term in project root")
  "pc" '(project-compile :which-key "compile at project root")
  "ps" '(project-search :which-key "search regex in project")
  "pb" '(project-switch-to-buffer :which-key "switch to buffer in project")
  "pd" '(project-dired :which-key "switch to project root dired")
  "px" '(project-async-shell-command :which-key "async shell command in root")
  "pp" '(project-switch-project :which-key "switch project"))

(use-package tab-bar)
(tab-bar-mode 1)
(define-prefix-command 'window-map)
(bind-key* "C-w" 'window-map)

(setq tab-bar-new-tab-choice "*Welcome*")
(setq tab-bar-close-button-show nil
      tab-bar-new-button-show nil)
;; window navi

(define-key window-map "h" 'evil-window-left)
(define-key window-map "l" 'evil-window-right)
(define-key window-map "j" 'evil-window-down)
(define-key window-map "k" 'evil-window-up)

;; splits
(define-key window-map "v" 'evil-window-vsplit)
(define-key window-map "s" 'evil-window-split)

;; misc
(define-key window-map "c" 'evil-window-delete)
(define-key window-map "x" 'tab-bar-close-tab)
(define-key window-map "=" 'balance-windows)

;; swapping windows
(define-key window-map "H" 'evil-window-move-far-left)
(define-key window-map "L" 'evil-window-move-far-right)
(define-key window-map "J" 'evil-window-move-very-bottom)
(define-key window-map "K" 'evil-window-move-very-top)

;; tab bar
(define-key window-map "t"  'tab-bar-new-tab)
(define-key window-map "rn" 'tab-bar-rename-tab)
(define-key window-map "rb" 'rename-buffer)
(define-key window-map "n"  'switch-to-next-buffer)
(define-key window-map "p"  'switch-to-prev-buffer)

(use-package popper
  :defer t
  :ensure t 
  :init
  (bind-key* "C-p" 'popper-toggle)
  (bind-key* "M-p" 'popper-cycle)
  (bind-key* "C-M-p" 'popper-toggle-type)
  (bind-key* "C-M-x" 'popper-kill-latest-popup)
  (require 'comint)

  (evil-collection-define-key 'normal 'shell-mode-map "C-p" nil)
  (evil-collection-define-key 'normal 'comint-mode-map (kbd "C-p") nil)
  (define-key comint-mode-map "C-p" nil)

  (setq popper-group-function #'popper-group-by-project) ; project.el projects

  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          helpful-mode
          help-mode
          compilation-mode)))

;; Match eshell, shell, term and/or vterm buffers
(setq popper-reference-buffers
      (append popper-reference-buffers
              '("^\\*eshell.*\\*$" eshell-mode ;eshell as a popup
                "^\\*shell.*\\*$"  shell-mode  ;shell as a popup
                "^\\*term.*\\*$"   term-mode   ;term as a popup
                "^\\*.+-vterm\\*$")))

(popper-mode 1)
(popper-echo-mode 1)
(defun popper-display-popup-right (buffer &optional alist)
  "Display popup-buffer BUFFER at the right side of the screen.
  ALIST is an association list of action symbols and values.  See
  Info node `(elisp) Buffer Display Action Alists' for details of
  such alists."
  (display-buffer-in-side-window
   buffer
   (append alist
           `((window-height . ,popper-window-height)
             (side . right)
             (slot . 1)))))
(setq popper-display-control t)
(setq popper-display-function #'popper-display-popup-right)

(use-package dired
  :ensure nil
  :custom ((dired-listing-switches "-aGho --group-directories-first"))
  :config
  (setf dired-kill-when-opening-new-dired-buffer t)
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :config
  (setq dired-open-extensions '(
                                ("mp4" . "mpv")
                                ("mp3" . "mpv")
                                ("mkv" . "mpv")
                                ("opus" . "mpv")
				  ("docx" . "libreoffice")
				  ("xls" . "libreoffice")
				  ("xlsx" . "libreoffice"))))
(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))
(gawmk/leader-key 
  "dd" '(dired :which-key "open dired")
  "di" '(image-dired :which-key "view images in dired (thumbnails)")
  "dj" '(dired-jump :which-key "dired jump"))

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :config
  (setq denote-directory (expand-file-name "~/sync/org/notes/"))
  (setq denote-history-completion-in-prompts nil)

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))

(use-package denote-org)

(gawmk/leader-key
  "dnr" '(denote-rename-file :which-key "rename a file to denote format")
  "dnl" '(denote-link-or-create :which-key "like a denote file")
  "dng" '(denote-grep :which-key "look for grep in denote")
  "dno" '(denote-open-or-create :which-key "open or create a note")
  "dnn" '(denote :which-key "create a denote"))

(use-package denote-explore)

;; temporary until karthink org is upstream
(use-package org :load-path "~/.emacs.d/elpa/org-mode/lisp/"
  :config

  (setq org-startup-with-latex-preview t)
  (setq org-hide-leading-stars t)
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width nil)
  (define-key org-mode-map (kbd "C-M-h") 'org-do-promote)
  (define-key org-mode-map (kbd "C-M-l") 'org-do-demote)
  (define-key org-mode-map (kbd "C-M-k") 'org-move-subtree-up)
  (define-key org-mode-map (kbd "C-M-j") 'org-move-subtree-down)

  (define-key org-mode-map (kbd "C-M-p") 'org-priority-down)
  (define-key org-mode-map (kbd "C-M-S-p") 'org-priority-up)
  (dolist (face '((org-level-1 . 1.5)
                  (org-level-2 . 1.3)
                  (org-level-3 . 1.2)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'bold :height (cdr face)))
  (keymap-set org-mode-map "C-c" nil)

  ;; visual stuff
  (setq org-ellipsis "▾")
  (setq org-hide-emphasis-markers t)
  (setq org-pretty-entities nil)

  ;; Follow the links
  (setq org-return-follows-link  t)

  ;; log mode
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t))

;; refile
(setq org-refile-targets
      '(("~/sync/org/archive.org" :maxlevel . 2)
        ("~/sync/org/todo.org" :maxlevel . 2)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

;; redisplay images after saving
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'org-redisplay-inline-images nil 'make-it-local)))

(use-package org-download
  :config
  (setq org-download-heading-lvl nil)
  (setq org-download-screenshot-method "grim -g \"$(slurp)\" %s")
  (setq org-download-method 'directory)
  (setq-default org-download-image-dir "./img"))

(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(gawmk/leader-key
  "oa" '(org-agenda :which-key "org agenda")
  "oc" '(org-capture :which-key "org agenda")
  "oss" '(org-download-screenshot :which-key "make an ss and paste it")
  "osp" '(org-download-clipboard :which-key "paste an ss from system clipboard")
  "oid" '(org-deadline :which-key "insert a deadline on a TODO")
  "oit" '(org-time-stamp :which-key "insert a timestamp on a TODO")
  "oil" '(org-insert-link :which-key "insert a link to a resource")
  "od" '(org-todo :which-key "cycle through TODO states")
  "ot" '(org-set-tags-command :which-key "insert a tag on a headline")
  "or" '(org-refile :which-key "move an org heading to a diff file")
  "ois" '(org-schedule :which-key "insert a scheduled tag on a TODO"))


(setq org-capture-templates
      `(("t" "Task" entry  (file+headline "~/sync/org/inbox.org" "Tasks")
         ,(concat "* TODO [#B] %?\n"
                  "/Entered on/ %U"))
        ("n" "Note"  entry (file+headline "~/sync/org/inbox.org" "Notes")
         "** %?")
        
        ("j" "Work Log Entry"
         entry (file+datetree "~/sync/org/work-log.org")
         "* %?"
         :empty-lines 0)

        ("c" "Code To-Do"
         entry (file+headline "~/sync/org/inbox.org" "Code Related Tasks")
         "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: ")

        ("m" "Meeting"
         entry (file+datetree "~/sync/org/meetings.org")
         "* %? :meeting:%^g \n:Created: %T\n** Attendees\n*** \n** Notes\n** Action Items\n*** TODO [#A] "
         :tree-type week
         :clock-in t
         :clock-resume t
         :empty-lines 0)
        ))

;; TODO states
(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n!)" "WAITING(w!)" "IN-PROGRESS(i!)" "|" "DONE(d!)" "CANC(c!)")
        ))

;; auto insert mode when capturing
(add-hook 'org-capture-mode-hook 'evil-insert-state)
(add-hook 'org-mode-hook 'org-indent-mode)
;; TODO colors
(setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "#d65d0e" :weight bold))
        ("WAITING" . (:foreground "#d4679c" :weight bold))
        ("IN-PROGRESS" . (:foreground "#eebd35" :weight bold))
        ("DONE" . (:foreground "#689d6a" :weight bold))
        ))

(setq org-priority-faces
      '(
        (?A . (:foreground "Grey"))
        (?B . (:foreground "Grey"))
        (?C . (:foreground "Grey"))))

;; DONE todo strikethrough
(defun my/modify-org-done-face ()
  (setq org-fontify-done-headline t)
  (set-face-attribute 'org-done nil :strike-through t)
  (set-face-attribute 'org-headline-done nil
                      :strike-through t
                      :foreground "Grey"))

(eval-after-load "org"
  (add-hook 'org-add-hook 'my/modify-org-done-face))

(add-hook 'org-mode-hook 'olivetti-mode)

;; agenda settings
  (setq org-agenda-files '("~/sync/org"))
  (setq org-agenda-restore-windows-after-quit t)
  (setq org-agenda-window-setup 'only-window)

  (setq org-agenda-skip-timestamp-if-done t)

  ;;olivetti mode for agenda
  (add-hook 'org-agenda-mode-hook 'olivetti-mode)

;; Agenda View "d"
(defun air-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

  PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(setq org-agenda-skip-deadline-if-done t)

(setq org-agenda-custom-commands
      '(
        ;; Daily Agenda & TODOs
        ("d" "Daily agenda and all TODOs"

         ;; Display items with priority A
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))

          ;; View 7 days in the calendar view
          (agenda "" ((org-agenda-span 7)))

          ;; Display items with priority B (really it is view all items minus A & C)
          (alltodo ""
                   ((org-agenda-skip-function '(or (air-org-skip-subtree-if-priority ?A)
                                                   (air-org-skip-subtree-if-priority ?C)
                                                   (org-agenda-skip-if nil '(scheduled deadline))))
                    (org-agenda-overriding-header "ALL normal priority tasks:")))

          ;; Display items with pirority C
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority Unfinished tasks:")))
          )

         ;; Don't compress things (change to suite your tastes)
         ((org-agenda-compact-blocks nil)))
        ))
  ;; agenda keybinds
  (eval-after-load 'org-agenda
    '(progn
       (evil-set-initial-state 'org-agenda-mode 'normal)
       (evil-define-key 'normal org-agenda-mode-map
         (kbd "<RET>") 'org-agenda-switch-to
         (kbd "M-<RET>") 'org-agenda-show
         (kbd "\t") 'org-agenda-goto

         "q" 'org-agenda-quit
         "m" 'org-tags-view
         "r" 'org-agenda-refile
         "C-r" 'org-agenda-redo
         "S" 'org-save-all-org-buffers
         "P" 'org-agenda-priority-up
         "," 'org-agenda-priority
         "p" 'org-agenda-priority-down
         "d" 'org-agenda-todo
         "t" 'org-agenda-set-tags
         ";" 'org-timer-set-timer
         "j"  'org-agenda-next-line
         "k"  'org-agenda-previous-line)))


  ;; evil calendar
  (defmacro my-org-in-calendar (command)
    (let ((name (intern (format "my-org-in-calendar-%s" command))))
      `(progn
         (defun ,name ()
           (interactive)
           (org-eval-in-calendar '(call-interactively #',command)))
         #',name)))

  (general-def org-read-date-minibuffer-local-map
    "C-h" (my-org-in-calendar calendar-backward-day)
    "C-l" (my-org-in-calendar calendar-forward-day)
    "C-k" (my-org-in-calendar calendar-backward-week)
    "C-j" (my-org-in-calendar calendar-forward-week)
    "C-S-h" (my-org-in-calendar calendar-backward-month)
    "C-S-l" (my-org-in-calendar calendar-forward-month)
    "C-S-k" (my-org-in-calendar calendar-backward-year)
    "C-S-j" (my-org-in-calendar calendar-forward-year))

(setq org-babel-python-command "python3")
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (C . t)
   ))



(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))


;; tangle on save
(defun gawmk/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/dotfiles/.emacs.d/config.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(gawmk/leader-key
  "xb" '(org-babel-execute-src-block :which-key "execute a code block")
  "xa" '(async-shell-command :which-key "execute a shell command asychronoulsy"))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'gawmk/org-babel-tangle-config)))

(defun mik/org-babel-edit ()
  "Edit python src block with lsp support by tangling the block and
then setting the org-edit-special buffer-file-name to the
absolute path. Finally load eglot."
  (interactive)

;; org-babel-get-src-block-info returns lang, code_src, and header
;; params; Use nth 2 to get the params and then retrieve the :tangle
;; to get the filename
  (setq mb/tangled-file-name (expand-file-name (assoc-default :tangle (nth 2 (org-babel-get-src-block-info)))))

  ;; tangle the src block at point 
  (org-babel-tangle '(4))
  (org-edit-special)

  ;; Now we should be in the special edit buffer with python-mode. Set
  ;; the buffer-file-name to the tangled file so that pylsp and
  ;; plugins can see an actual file.
  (setq-local buffer-file-name mb/tangled-file-name)
  (eglot-ensure)
  )

; and some keybindings for this
(gawmk/leader-key
  "oe" '(mik/org-babel-edit :which-key "edit a source code block with lsp support"))
(evil-define-key 'normal org-src-mode-map (kbd "ZZ") 'org-edit-src-exit)
(evil-define-key 'normal org-src-mode-map (kbd "ZQ") 'org-edit-src-abort)

(use-package vterm
  :ensure t
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'vterm-mode 'insert))
  (setq vterm-timer-delay 0.01)
  (keymap-set vterm-mode-map "<insert-state> C-c" 'vterm--self-insert))
  (keymap-set vterm-mode-map "<insert-state> C-p" 'nil)
  (keymap-set vterm-mode-map "C-p" 'nil)
  (keymap-set vterm-mode-map "<insert-state> C-w" 'window-map)


(defun
    launch-vterm (buffer-name)
  "Start a terminal and rename buffer."
  (interactive "sbuffer name: ")
  (vterm)
  (rename-buffer buffer-name t))

(use-package magit)
(setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
(gawmk/leader-key
  "mg" '(magit-status :which-key "magit status pane")
  "cmg" '(magit-clone :which-key "clone a repository"))

(use-package pandoc-mode)

(gawmk/leader-key
  "ep" '(pandoc-main-hydra/body :which-key "pandoc export dispatcher")
  "eo" '(org-export-dispatch :which-key "org export dispatcher"))

(use-package pdf-tools
  :defer t
  :commands (pdf-loader-install)
  :bind (:map pdf-view-mode-map
              ("C-S-j" . pdf-view-goto-page))
  ;;:mode "\\.pdf\\"
  :init (pdf-loader-install)
  :config (add-to-list 'revert-without-query ".pdf"))

(add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1) (blink-cursor-mode -1) (line-number-mode -1)))

(use-package csv-mode)
(add-hook 'csv-mode-hook #'csv-align-mode)


(add-hook 'js-json-mode-hook #'json-pretty-print-buffer)

(use-package eglot
  :config
  (fset #'jsonrpc--log-event #'ignore)
  (setq eldoc-echo-area-use-multiline-p nil)
  (add-hook 'c-mode-hook #'eglot-ensure)
  (setq eglot-connect-timeout 1000)
  (add-hook 'python-mode-hook #'eglot-ensure))

(with-eval-after-load 'eglot
  (setq completion-category-defaults nil)
  (add-to-list 'eglot-server-programs
	       '(python-mode . ("pyright-langserver"))
               '(c-mode . ("ccls"))))

;; (use-package eglot-booster
;;   :after eglot
;;   :config (eglot-booster-mode))

(use-package eldoc
  :defer
  :custom
  (eldoc-idle-delay 0.1)
  :config
  (evil-define-key 'normal eglot-mode-map (kbd "K") 'eldoc)
  (advice-add 'eldoc-doc-buffer :after
          (lambda (&rest _)
            (let ((buf (get-buffer "*eldoc*")))
              (when (buffer-live-p buf)
                (select-window (get-buffer-window buf))))))

  (add-hook 'eglot-managed-mode-hook (lambda () (eldoc-mode -1))))

(use-package markdown-mode)

(use-package corfu
  :init
  (global-corfu-mode)


  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2) 
  (corfu-auto-delay 0.0)
  (corfu-echo-documentation 0.25)

  :bind (:map corfu-map
              ("RET" . nil)
              ("C-j" . corfu-next)
              ("C-k" . corfu-previous)
              ("C-<return>" . corfu-insert)))

(use-package cape
  :init
  ;(setq completion-at-point-functions t)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-tex)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

  (setq text-mode-ispell-word-completion nil)

(use-package ledger-mode
  :defer t
  :mode ("\\.ledger.gpg\\'"
         "\\.ledger\\'")
  :custom
  (ledger-clear-whole-transactions t)
  (ledger-report-use-native-highlighting t)
  (ledger-report-use-header-line t)
  :config
  (setq ledger-reports
      '(("net" "ledger -f ledger.ledger bal ^assets ^liabilities")
       ("bal" "%(binary) -f %(ledger-file) bal")
       ("reg" "%(binary) -f %(ledger-file) reg")
       ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
       ("account" "%(binary) -f %(ledger-file) reg %(account)"))))


(gawmk/leader-key
  "la" '(ledger-add-transaction :which-key "add a ledger transaction")
  "lr" '(ledger-report :which-key "generate a ledger report"))

(use-package auctex
  :config
  (setq TeX-parse-self t); Enable parse on load.
  (setq TeX-auto-save t); Enable parse on save.
  (setq-default TeX-master nil)

  (gawmk/leader-key
    "lc" '(TeX-command-run-all :which-key "compile and preview"))

  (setq TeX-PDF-mode t); PDF mode (rather than DVI-mode)
  
  (add-hook 'TeX-mode-hook 'flyspell-mode); Enable Flyspell mode for TeX modes such as AUCTeX. Highlights all misspelled words.
  (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode); Enable Flyspell program mode for emacs lisp mode, which highlights all misspells
  (setq ispell-dictionary "english"); Default dictionary. To change do M-x ispell-change-dictionary RET.
  (add-hook 'TeX-mode-hook
            (lambda () (TeX-fold-mode 1))); Automatically activate TeX-fold-mode.
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-source-correlate-start-server t)  
  (setq LaTeX-babel-hyphen nil)); Disable language-specific hyphen insertion.

(use-package latex
  :ensure auctex
  :hook ((LaTeX-mode . prettify-symbols-mode)))

;; CDLatex settings
(use-package cdlatex
  :ensure t
  :hook ((LaTeX-mode . turn-on-cdlatex)
	 (org-mode . org-cdlatex-mode))
  :bind (:map cdlatex-mode-map 
              ("<tab>" . cdlatex-tab)))
(require 'cdlatex)
(add-to-list 'cdlatex-command-alist
	     '("vb" "bmatrix environment" "\\begin{bmatrix} \n ? \n\\end{bmatrix}" cdlatex-position-cursor nil nil t))
(add-to-list 'cdlatex-command-alist
	     '("pr" "partial symbol" "\\partial ?" cdlatex-position-cursor nil nil t))

;; Yasnippet settings
(use-package yasnippet
  :ensure t
  :hook ((LaTeX-mode . yas-minor-mode)
	 (org-mode . yas-minor-mode)
         (post-self-insert . my/yas-try-expanding-auto-snippets))
  :config
  (use-package warnings
    :config
    (cl-pushnew '(yasnippet backquote-change)
                warning-suppress-types
                :test 'equal))

  (setq yas-triggers-in-field t)
  
  ;; Function that tries to autoexpand YaSnippets
  ;; The double quoting is NOT a typo!
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand)))))

;; CDLatex integration with YaSnippet: Allow cdlatex tab to work inside Yas
;; fields
(use-package cdlatex
  :hook ((cdlatex-tab . yas-expand)
         (cdlatex-tab . cdlatex-in-yas-field))
  :config
  (use-package yasnippet
    :bind (:map yas-keymap
		("<tab>" . yas-next-field-or-cdlatex)
		("TAB" . yas-next-field-or-cdlatex))
    :config
    (defun cdlatex-in-yas-field ()
      ;; Check if we're at the end of the Yas field
      (when-let* ((_ (overlayp yas--active-field-overlay))
                  (end (overlay-end yas--active-field-overlay)))
        (if (>= (point) end)
            ;; Call yas-next-field if cdlatex can't expand here
            (let ((s (thing-at-point 'sexp)))
              (unless (and s (assoc (substring-no-properties s)
                                    cdlatex-command-alist-comb))
                (yas-next-field-or-maybe-expand)
                t))
          ;; otherwise expand and jump to the correct location
          (let (cdlatex-tab-hook minp)
            (setq minp
                  (min (save-excursion (cdlatex-tab)
                                       (point))
                       (overlay-end yas--active-field-overlay)))
            (goto-char minp) t))))

    (defun yas-next-field-or-cdlatex nil
      (interactive)
      "Jump to the next Yas field correctly with cdlatex active."
      (if
          (or (bound-and-true-p cdlatex-mode)
              (bound-and-true-p org-cdlatex-mode))
          (cdlatex-tab)
        (yas-next-field-or-maybe-expand)))))

(use-package gptel
  :config

  (setq gptel-default-mode 'org-mode)
  (gawmk/leader-key
    "gps" '(gptel-send :which-key "Send text up to point to gptel")
    "gpm" '(gptel-menu :which-key "Send text up to point to gptel")
    "gpt" '(gptel :which-key "Open a dedicated gptel buffer"))

  (setq
   gptel-model 'gemma3:4b
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '(gemma3:4b))))

(use-package julia-mode)
(use-package eglot-jl)

(use-package jupyter)
(setq org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                     (:session . "jl")
                                                     (:results . "raw")
                                                     (:kernel . "python3")))
(defun my-python-noindent-docstring (&optional _previous)
  (if (eq (car (python-indent-context)) :inside-docstring)
      'noindent))

(advice-add 'python-indent-line :before-until #'my-python-noindent-docstring)
