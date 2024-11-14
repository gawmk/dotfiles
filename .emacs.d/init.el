(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("48042425e84cd92184837e01d0b4fe9f912d875c43021c3bcb7eeb51f1be5710" default))
 '(package-selected-packages
   '(visual-fill-column org-bullets latex vterm page-break-lines counsel-projectile projectile hydra evil-collection evil general all-the-icons helpful ivy-rich which-key doom-modeline doom-themes counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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

;; Write backups to ~/.emacs.d/backup/
(setq backup-directory-alist '(("." . "~/.config/emacs/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old
(setq create-lockfiles nil)

(setq use-dialog-box nil)

(add-to-list 'exec-path "~/.local/bin/")

(setq global-auto-revert-non-file-buffers 1)
(global-auto-revert-mode 1)

(recentf-mode 1)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(counsel-mode 1)
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

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

(set-frame-parameter nil 'alpha-background 80)        ;transparency
(add-to-list 'default-frame-alist '(alpha-background . 80))

(use-package page-break-lines    ;pretty page breaks
  :diminish page-break-lines-mode
  :config (page-break-lines-mode))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(set-face-attribute 'default nil :font "Iosevka Comfy" :height 160 :weight 'semibold)

(load-theme 'doom-gruvbox)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package all-the-icons)

(defun gawmk/show-welcome-buffer ()
  "Show *Welcome* buffer."
  (with-current-buffer (get-buffer-create "*Welcome*")
    (setq truncate-lines t)
    (let* ((buffer-read-only)
           (image-path "~/pics/wallpapers/novigrad.png")
           (image (create-image image-path))
           (size (image-size image))
           (height (cdr size))
           (width (car size))
           (top-margin (floor (/ (- (window-height) height) 2)))
           (left-margin (floor (/ (- (window-width) width) 2)))
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
    "pf" '(project-find-file :which-key "project management")
    "mc" '(compile :which-key "compile")
    "tt" '(launch-vterm :which-key "launch and rename vterm")
    "ff" '(counsel-find-file :which-key "find file")
    "rf" '(counsel-recentf :which-key "open recent file")
    "hf" '(counsel-describe-function :which-key "describe function")
    "hb" '(describe-bindings :which-key "describe bindings")
    "hv" '(counsel-describe-variable :which-key "describe variable")))

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

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(gawmk/leader-key
  "st" '(tab-switcher :which-key "switch tab")
  "kb" '(kill-buffer :which-key "kill buffer")
  "sb" '(counsel-switch-buffer :which-key "switch buffer"))

(use-package project)

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
(define-key window-map "p"  'tab-bar-switch-to-recent-tab)

(use-package popper
    :ensure t ; or :straight t
    :init
    (bind-key* "C-p" 'popper-toggle)
    (bind-key* "M-p" 'popper-cycle)
    (bind-key* "C-M-p" 'popper-toggle-type)

    (evil-collection-define-key 'normal 'shell-mode-map "C-p" nil)
    (evil-collection-define-key 'normal 'comint-mode-map (kbd "C-p") nil)
    (define-key comint-mode-map "C-p" nil)

    (setq popper-group-function #'popper-group-by-project) ; project.el projects
    (setq popper-group-function #'popper-group-by-directory) ; group by project.el

    (setq popper-reference-buffers
          '("\\*Messages\\*"
            "Output\\*$"
            "\\*Async Shell Command\\*"
            helpful-mode
            help-mode
            compilation-mode)))
(popper-mode 1)
(popper-echo-mode 1)

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
  (setq dired-open-extensions '(("png" . "imv-wayland")
                                ("mp4" . "mpv")
                                ("jpeg" . "imv-wayland")
                                ("jpg" . "imv-wayland"))))
(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))
(gawmk/leader-key 
  "dd" '(dired :which-key "open dired")
  "dp" '(project-dired :which-key "open dired project")
  "dj" '(dired-jump :which-key "dired jump"))

(defun gawmk/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1))
(use-package org
  :hook (org-mode . gawmk/org-mode-setup)
  :config
  (define-key org-mode-map (kbd "C-M-h") 'org-do-promote)
  (define-key org-mode-map (kbd "C-M-l") 'org-do-demote)
  (define-key org-mode-map (kbd "C-M-k") 'org-move-subtree-up)
  (define-key org-mode-map (kbd "C-M-j") 'org-move-subtree-down)

  (define-key org-mode-map (kbd "C-M-p") 'org-priority-down)
  (define-key org-mode-map (kbd "C-M-S-p") 'org-priority-up)

  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.12)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'bold :height (cdr face)))
  (keymap-set org-mode-map "C-c" nil)

  ;; visual stuff
  (setq org-ellipsis " ▾")
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
      '(("~/org/archive.org" :maxlevel . 2)
        ("~/org/projects.org" :maxlevel . 2)
        ("~/org/agenda.org" :maxlevel . 2)
        ("~/org/tasks.org" :maxlevel . 1)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)


(gawmk/leader-key
  "oa" '(org-agenda :which-key "org agenda")
  "oc" '(org-capture :which-key "org agenda")
  "oid" '(org-deadline :which-key "insert a deadline on a TODO")
  "oit" '(org-time-stamp :which-key "insert a timestamp on a TODO")
  "oil" '(org-insert-link :which-key "insert a link to a resource")
  "od" '(org-todo :which-key "cycle through TODO states")
  "ot" '(org-set-tags-command :which-key "insert a tag on a headline")
  "or" '(org-refile :which-key "move an org heading to a diff file")
  "osp" '(org-set-property :which-key "choose a property to set for an item")
  "ois" '(org-schedule :which-key "insert a scheduled tag on a TODO"))

(setq org-capture-templates
      `(("t" "Task" entry  (file+headline "~/org/inbox.org" "Tasks")
         ,(concat "* TODO [#B] %?\n"
                  "/Entered on/ %U"))
        ("n" "Note"  entry (file+headline "~/org/inbox.org" "Notes")
         "** %?")

        ("c" "Code To-Do"
         entry (file+headline "~/org/inbox.org" "Code Related Tasks")
         "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: ")

        ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
         ,(concat "* %? :meeting:\n"
                  "/Entered on/ %U"))
        ))

;; TODO states
(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n!)" "PLANNING(p!)" "IN-PROGRESS(i!)" "|" "DONE(d!)")
        ))

;; auto insert mode when capturing
(add-hook 'org-capture-mode-hook 'evil-insert-state)

;; TODO colors
(setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "#d65d0e" :weight bold))
        ("PLANNING" . (:foreground "#d4679c" :weight bold))
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

;; Tags
(setq org-tag-alist '(
                      ;; Places
                      ("@home" . ?h)
                      ("@work" . ?w)
                      ("@uni" . ?u)

                      ;; dev
                      ("@computer" . ?c)
                      ("@phone" . ?p)

                      ("errand" . ?e)
                      ("meeting" . ?m)
                      ))


(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

(defun gawmk/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . gawmk/org-mode-visual-fill))

;; agenda settings
(setq org-agenda-files '("~/org"))
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-window-setup 'only-window)

(setq org-agenda-skip-timestamp-if-done t)

;; custom agenda commands

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
          (tags-todo "PRIORITY=\"B\""
                   ((org-agenda-skip-function '(or (air-org-skip-subtree-if-priority ?A)
                                                   (air-org-skip-subtree-if-priority ?C)
                                                   ))
                    (org-agenda-overriding-header "ALL normal priority tasks:")))
          ;; Display items with pirority C
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
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
(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))


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
  "xb" '(org-babel-execute-src-block :which-key "execute a code block"))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'gawmk/org-babel-tangle-config)))

(use-package vterm
  :ensure t
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'vterm-mode 'insert))
  (setq vterm-timer-delay 0.01)
  (keymap-set vterm-mode-map "<insert-state> C-c" 'vterm--self-insert))
  (keymap-set vterm-mode-map "<insert-state> C-w" 'window-map)


(defun launch-vterm (buffer-name)
  "Start a terminal and rename buffer."
  (interactive "sbuffer name: ")
  (vterm)
  (rename-buffer buffer-name t))

(use-package magit)

(gawmk/leader-key
  "mg" '(magit-status :which-key "magit status pane")
  "cmg" '(magit-clone :which-key "clone a repository"))

(use-package pdf-tools
  :defer t
  :commands (pdf-loader-install)
  ;;:mode "\\.pdf\\"
  :bind (:map pdf-view-mode-map
              ("j" . pdf-view-next-line-or-next-page)
              ("k" . pdf-view-previous-line-or-next-page)
              ("C-+" . pdf-view-enlarge)
              ("C--" . pdf-view-shrink))
  :init (pdf-loader-install)
  :config (add-to-list 'revert-without-query ".pdf"))

(add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1) (blink-cursor-mode -1) (line-number-mode -1)))

(use-package eglot
  :config
  (fset #'jsonrpc--log-event #'ignore)
  (add-hook 'c-mode-hook #'eglot-ensure))

(with-eval-after-load 'eglot
  (setq completion-category-defaults nil)
  (add-to-list 'eglot-server-programs
               '(c-mode . ("clangd"))))


(use-package eglot-booster
  :after eglot
  :config (eglot-booster-mode))

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
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package mu4e
    :ensure nil
    :load-path "/usr/share/emacs/site-lisp/mu4e/"
    :config
    (setq mail-user-agent 'mu4e-user-agent)
    ;; This is set to 't' to avoid mail syncing issues when using mbsync
    (setq mu4e-change-filenames-when-moving t)

    ;; Refresh mail using isync every 10 minutes
    (setq mu4e-update-interval (* 10 60))
    (setq mu4e-get-mail-command "mbsync -a -c ~/.config/mu4e/mbsyncrc")
    (setq mu4e-maildir "~/mail")

    (setq mu4e-drafts-folder "gawmk-gmail/[Gmail]/Drafts")
    (setq mu4e-sent-folder   "gawmk-gmail/[Gmail]/Sent Mail")
    (setq mu4e-refile-folder "gawmk-gmail/[Gmail]/All Mail")
    (setq mu4e-trash-folder  "gawmk-gmail/[Gmail]/Bin")


(setq mu4e-maildir-shortcuts
    '((:maildir "/Inbox"    :key ?i)
      (:maildir "/[Gmail]/Sent Mail" :key ?s)
      (:maildir "/[Gmail]/Bin"     :key ?b)
      (:maildir "/[Gmail]/Drafts"    :key ?d)
      (:maildir "/[Gmail]/All Mail"  :key ?a))))
