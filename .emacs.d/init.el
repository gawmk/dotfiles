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

					;causes no job control in this shell error
					;(setq shell-command-switch "-ic")

(setq use-dialog-box nil)

(add-to-list 'exec-path "~/.local/bin/")

(add-to-list 'auto-mode-alist '("\\.pl\\'"  . prolog-mode))

;; Never enable abbrev-mode automatically
(setq-default abbrev-mode nil)

;; Don't save abbrevs to disk
(setq save-abbrevs nil)


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

;; daemon
(require 'server)
(unless (server-running-p)
  (server-start))
;; ask for pass without a window
(setq epg-pinentry-mode 'loopback)

(defun flyspell-mode (&optional _)
  "Disabled flyspell-mode. Do nothing.")
(defun flyspell-prog-mode ()
  "Disabled flyspell-prog-mode. Do nothing.")

(setq-default spell-checking-enable-by-default nil)
(flyspell-mode 0)
;; Disable flyspell completely
(setq flyspell-mode nil)
(setq global-flyspell-mode nil)
(remove-hook 'text-mode-hook 'flyspell-mode)
(remove-hook 'prog-mode-hook 'flyspell-prog-mode)
;; Don't load ispell or try to configure it
(setq ispell-program-name nil)
(setq ispell-local-dictionary nil)
(setq ispell-local-dictionary-alist nil)
(setq ispell-dictionary nil)
(setq ispell-extra-args '("--sucks-to-be-a-spell-checker"))


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

(set-frame-parameter nil 'alpha-background 70)        ;transparency
(add-to-list 'default-frame-alist '(alpha-background . 80))

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


(add-hook 'org-mode-hook #'variable-pitch-mode)

(with-eval-after-load 'org
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-block nil :inherit 'fixed-pitch))

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
	     (image-path "~/multimedia/pics/wallpapers/shepherd.png")
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
    "mu" '(mu4e :which-key "mail")
    "tt" '(vterm :which-key "launch and rename vterm")
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
  "st" '(tab-switch :which-key "switch tab")
  "kb" '(kill-buffer :which-key "kill buffer")
  "sb" '(counsel-switch-buffer :which-key "switch buffer"))

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
                                ("mkv" . "mpv")
				  ("docx" . "libreoffice")
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

(use-package org
  :config
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
      '(("~/org/archive.org" :maxlevel . 2)
        ("~/org/todo.org" :maxlevel . 2)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

;; redisplay images after saving
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'org-redisplay-inline-images nil 'make-it-local)))


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
  	
        ("j" "Work Log Entry"
         entry (file+datetree "~/org/work-log.org")
         "* %?"
         :empty-lines 0)

        ("c" "Code To-Do"
         entry (file+headline "~/org/inbox.org" "Code Related Tasks")
         "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: ")

	("m" "Meeting"
         entry (file+datetree "~/org/meetings.org")
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
  (setq org-agenda-files '("~/org"))
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

(use-package org-roam
  :custom
  org-roam-directory (file-truename "~/org")
  :config
  (org-roam-db-autosync-mode))

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


(defun auto-complete-text-off ()
  (interactive) 
  (message "Trying to turn off ispell completion...")
  (remove-hook 'completion-at-point-functions #'ispell-completion-at-point t))

;; (use-package mu4e
;;   :ensure nil
;;   :load-path "/usr/share/emacs/site-lisp/mu4e/"
;;   :config
;;   (setq mail-user-agent 'mu4e-user-agent)
;;   (setq message-kill-buffer-on-exit t)
;;   ;; This is set to 't' to avoid mail syncing issues when using mbsync
;;   (setq mu4e-change-filenames-when-moving t)
;;   (setq mu4e-sent-messages-behavior 'delete)
;;   (setq message-send-mail-function 'smtpmail-send-it)

;;   ;; wrap email text
;;   (setq mu4e-compose-format-flowed t)

;;   ;; Refresh mail using isync every 10 minutes
;;   (setq mu4e-update-interval (* 10 60))
;;   (setq mu4e-get-mail-command "mbsync -a -c ~/.config/mu4e/mbsyncrc")
;;   (setq mu4e-maildir "~/mail")

;;   (setq mu4e-contexts
;;         (list
;;          ;; Work account
;;          (make-mu4e-context
;;           :name "Gmail"
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
;;           :vars '((user-mail-address . "mikolaj.gawrys@gmail.com")
;;                   (user-full-name    . "Mikołaj Gawryś")
;;                   (smtpmail-stream-type . starttls)
;;                   (smtpmail-smtp-server . "smtp.gmail.com")
;;                   (smtpmail-smtp-service . 587)
;;                   (mu4e-drafts-folder  . "/gmail/[Gmail]/Drafts")
;;                   (mu4e-sent-folder  . "/gmail/[Gmail]/Sent Mail")
;;                   (mu4e-refile-folder  . "/gmail/[Gmail]/All Mail")
;;                   (mu4e-trash-folder  . "/gmail/[Gmail]/Bin")))))

;;   (setq mu4e-maildir-shortcuts
;;         '( (:maildir "/gmail/Inbox"              :key ?i)
;;            (:maildir "/gmail/[Gmail]/Sent Mail"  :key ?s)
;;            (:maildir "/gmail/[Gmail]/Bin"      :key ?t)
;;            (:maildir "/gmail/[Gmail]/All Mail"   :key ?a))))

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

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main"))

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
