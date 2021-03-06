; Load files from my home
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

; For R. The first two lines are needed *before* loading 
; ess, to set indentation to two spaces
(setq ess-default-style 'DEFAULT)
(setq ess-indent-level 2)
(setq ess-history-directory "~/.R/")

;; Magical shift+ENTER
;; http://kieranhealy.org/blog/archives/2009/10/12/make-shift-enter-do-a-lot-in-ess/
(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window w1 nil t))
        (R)
        (set-window-buffer w2 "*R*")
        (set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [up] 'comint-previous-input)
             (local-set-key [down] 'comint-next-input)))
(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(require 'ess-site)

; Do not replace _ with <-
(ess-toggle-underscore nil)

(defun my-ess-post-run-hook ()
  (ess-execute-screen-options)
  (local-set-key "\C-cw" 'ess-execute-screen-options))
(add-hook 'ess-post-run-hook 'my-ess-post-run-hook)

; Moving between windows with shift+arrows
(windmove-default-keybindings)

; Save/load history of minibuffer
(savehist-mode 1)

; Markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

; Variables I set up from within emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu 0.8)
 '(ac-auto-start 2)
 '(ac-quick-help-delay 0.1)
 '(auto-save-default nil)
 '(comint-move-point-for-output nil)
 '(comint-scroll-show-maximum-output nil)
 '(comint-scroll-to-bottom-on-input nil)
 '(compilation-ask-about-save nil)
 '(compilation-auto-jump-to-first-error nil)
 '(compilation-environment nil)
 '(compilation-read-command nil)
 '(compilation-scroll-output (quote first-error))
 '(compile-command "make")
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(fci-rule-character-color "#444444")
 '(fci-rule-color "#444444")
 '(fci-rule-column 75)
 '(fill-column 75)
 '(font-latex-fontify-script nil)
 '(font-latex-fontify-sectioning 1.0)
 '(global-linum-mode nil)
 '(inhibit-startup-screen t)
 '(linum-delay t)
 '(linum-eager t)
 '(linum-format " %4d")
 '(show-paren-mode t)
 '(speedbar-default-position (quote left))
 '(sr-speedbar-auto-refresh nil)
 '(sr-speedbar-max-width 30)
 '(sr-speedbar-right-side nil)
 '(sr-speedbar-width-x 30))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face :foreground "gray50" :slant normal))))
 '(font-lock-comment-face ((t (:slant italic))))
 '(linum ((t (:inherit (shadow default) :background "#181a26" :height 0.9)))))

;; dark theme
(load-theme 'deeper-blue)

;; set all windows (emacs's "frame") to use font DejaVu Sans Mono
(set-frame-font "DejaVu Sans Mono-11" t t)
(when (member "Symbola" (font-family-list))
  (set-fontset-font t 'unicode "Symbola" nil 'prepend))

;; no toolbar
(tool-bar-mode -1)

;; no scrollbars
(scroll-bar-mode -1)

;; mark fill column
(require 'fill-column-indicator)

;; Make Macbook keys work
(setq mac-command-modifier 'super)
(setq ns-function-modifier 'hyper)

;; Code folding, load it in the modes used for programming
(require 'fold-dwim)
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(dolist (x '(emacs-lisp lisp java perl sh python))
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'hs-minor-mode))

;; Keybindings for code folding
(global-set-key (kbd "C-H-S-h")	  'hs-hide-all)
(global-set-key (kbd "C-H-h")	  'hs-show-all)
(global-set-key (kbd "H-h")   'hs-toggle-hiding)
(global-set-key [(shift mouse-2)] 'hs-mouse-toggle-hiding)

;; To be able to install emacs packages from here
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;; Color of the fringe
(set-face-background 'fringe "#181a26")

;; Open a while from anywhere within the git tree
(require 'git-find-file)
(global-set-key (kbd "H-t") 'git-find-file)
(global-set-key (kbd "s-t") 'git-find-file)

;; Mark additions/deletions in a git repo, on the margin
(require 'git-gutter-fringe)
(global-git-gutter-mode t)
(set-face-foreground 'git-gutter-fr:modified "yellow")
(set-face-foreground 'git-gutter-fr:added    "#006600")
(set-face-foreground 'git-gutter-fr:deleted  "#660000")

;; Load speedbar in the same frame, do not refresh it
;; automatically
(require 'sr-speedbar)
(add-hook 'speedbar-mode-hook (lambda () (linum-mode -1)))
;; (sr-speedbar-open)
(sr-speedbar-refresh-turn-off)

;; ???
(setq url-http-attempt-keepalives nil)

(eval-after-load "comint"
	'(progn
		 (define-key comint-mode-map [C-up]
			 'comint-previous-matching-input-from-input)
		 (define-key comint-mode-map [C-down]
			 'comint-next-matching-input-from-input)
     
		 ;; also recommended for ESS use --
		 (setq comint-scroll-to-bottom-on-output nil)
		 (setq comint-scroll-show-maximum-output nil)
		 ;; somewhat extreme, almost disabling writing in *R*, 
		 ;; *shell* buffers above prompt:
		 (setq comint-scroll-to-bottom-on-input 'this)
		 ))

(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
(setq-default scroll-up-aggressively 0.01
	      scroll-down-aggressively 0.01)

;; Some keys for ESS
(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])

(define-key ess-mode-map [(meta down)] 'ess-eval-line-and-step)
(define-key ess-mode-map [(meta up)] 'ess-eval-function-or-paragraph-and-step)
(define-key ess-mode-map [(meta left)] 'ess-eval-region)

;; saveplace
;; Remeber the cursor position in a file
;; http://www.emacswiki.org/emacs/SavePlace
;; http://git.sysphere.org/dotfiles/tree/emacs
(setq save-place-file "~/.emacs.d/emacs-places")        ; save file within ~/.emacs.d
(setq-default save-place t)
(require 'saveplace)
;; y or n for yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

(defun my-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (when (display-graphic-p) (fci-mode nil))
  (linum-mode 1)
  )
(add-hook 'prog-mode-hook 'my-common-hook)
(add-hook 'R-mode-hook 'my-common-hook)
(add-hook 'LaTeX-mode-hook 'my-common-hook)
(add-hook 'TeX-mode-hook 'my-common-hook)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(require 'ssh)

;; To maximize the frame at startup
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)

;; Easier key to recompile
(global-set-key (kbd "C-x c") 'recompile)

(projectile-global-mode)

;; Save window configuration
;; (desktop-save-mode 1)

;; Pretty arrows and magrittr pipes in R
(defvar pretty-alist
  (cl-pairlis '() '()))
(add-to-list 'pretty-alist '("%>%" . ?⇉))
(add-to-list 'pretty-alist '("<-" . ?←))
(add-to-list 'pretty-alist '("->" . ?→))
(add-to-list 'pretty-alist '("<<-" . ?↞))
(add-to-list 'pretty-alist '("::" . ?∷))
(add-to-list 'pretty-alist '("\\$" . ?$))
;; (add-to-list 'pretty-alist '("\\[\\[" . ?))
;; (add-to-list 'pretty-alist '("\\]\\]" . ?))
;; (add-to-list 'pretty-alist '%||%' . ?))
;; (add-to-list 'pretty-alist '%&&%' . ?))
(defun pretty-things ()
  (mapc
   (lambda (x)
     (let ((word (car x))
           (char (cdr x)))
       (font-lock-add-keywords
        nil
        `((,(concat "\\(" word "\\)")
            (0 (progn
                 (compose-region (match-beginning 1) (match-end 1)
				 (vector ?\t `(Bc . Bc) ,char `(Br . Bl) ?\u2009
					 `(Bl . Br) ?\u2009 `(Bl . Br) ?\u2009
					 `(Br . Bl) ?\u2009))
                 nil)))))))
   pretty-alist))

(add-hook 'ess-mode-hook
	  (lambda ()
	    (font-lock-add-keywords nil
                 '(("\\(%>%\\)" 1
                    font-lock-builtin-face t)))))

(add-hook 'ess-mode-hook
	  (lambda ()
	    (font-lock-add-keywords nil
                 '(("\\(\\$\\)" 1
                    font-lock-comment-delimiter-face t)))))

(when (display-graphic-p) (add-hook 'ess-mode-hook 'pretty-things))
(when (display-graphic-p) (add-hook 'inferior-ess-mode-hook 'pretty-things))

(define-key ess-mode-map [(super .)] "%>%")
(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [(super .)] "%>%")))

;; Highlight matching parentheses
(require 'highlight-parentheses)
(setq hl-paren-colors '("gold" "IndianRed" "cyan" "green" "orange"
			"magenta"))
(defun hpm-on ()
  (highlight-parentheses-mode t))
(add-hook 'ess-mode-hook 'hpm-on)
(add-hook 'inferior-ess-mode-hook 'hpm-on)

;; Better buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Put backup files in temporary directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Better looking terminal windows
;; Space after line numbers
(when (not(display-graphic-p)) (add-hook 'window-configuration-change-hook
					 (lambda ()
					   (setq linum-format "%4d "))))
;; Turn off menu bar
(when (not(display-graphic-p)) (menu-bar-mode -1))

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/egg"))
(require 'egg)

(load "editorconfig")

;; (require 'pos-tip)
(add-to-list 'load-path "/Users/gaborcsardi/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/Users/gaborcsardi/.emacs.d//ac-dict")
(ac-config-default)

(set-face-attribute 'ac-candidate-face nil   :background "#00222c" :foreground "light gray")
(set-face-attribute 'ac-selection-face nil   :background "SteelBlue4" :foreground "white")
(set-face-attribute 'popup-tip-face    nil   :background "#003A4E" :foreground "light gray")

(add-hook 'ess-mode (lambda () (add-to-list 'ac-sources 'ac-source-R)))

(defvar sanityinc/fci-mode-suppressed nil)
(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-mode)
  (when fci-mode
    (turn-off-fci-mode)))
(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and (not popup-instances) sanityinc/fci-mode-suppressed)
    (setq sanityinc/fci-mode-suppressed nil)
    (turn-on-fci-mode)))
