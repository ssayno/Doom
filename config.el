;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 18 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "Sarasa Mono SC Nerd" :size 17))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issue!
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the defaulte
(setq doom-theme 'doom-one)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(use-package! highlight-parentheses
  :hook (LaTeX-mode. highlight-parentheses-mode))

(use-package! tex
  :init
  (add-to-list 'auto-mode-alist '("\\.tex$" . LaTeX-mode))
  :custom
  (TeX-region "fragment")
  (TeX-master nil)
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-show-compilation nil)
  (TeX-clean-confirm nil)
  (TeX-save-query nil)
  (LaTeX-item-indent 4)
  (LaTeX-indent-level 0)
  ;; speed up the start emacs when you open the tex file.
  (pdf-view-use-unicode-ligther nil)
  (pdf-view-use-scaling t)
  (pdf-view-use-imagemagick nil)
  :config
  (with-eval-after-load
	  'latex (define-key LaTeX-mode-map (kbd "C-c C-g") #'pdf-sync-forward-search))
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex -shell-escape --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
              (add-to-list 'TeX-command-list '("PdfLaTeX" "%`pdflatex -shell-escape --synctex=1 -8bit%(mode)%' %t" TeX-run-TeX nil t))
              (setq TeX-command-default "PdfLaTeX")
			  (add-to-list 'TeX-view-program-list '("eaf" eaf-pdf-synctex-forward-view))
			  (add-to-list 'TeX-view-program-selection '(output-pdf "eaf"))
			  (local-set-key (kbd "<f5>") 'TeX-clean)
			  (local-set-key (kbd "<f6>") 'TeX-documentation-texdoc)
			  (local-set-key (kbd "C-S-a") 'LaTeX-find-matching-begin)
			  (local-set-key (kbd "C-S-e") 'LaTeX-find-matching-end)
			  (turn-off-auto-fill)
              (outline-minor-mode)
              (menu-bar-mode -1)
              (visual-line-mode)
			  (setq autopair-handle-action-fns
					(list 'autopair-default-handle-action
						  '(lambda (action pair pos-before)
							 (hl-paren-color-update))))
			  (TeX-fold-mode)
			  (LaTeX-math-mode)
			  )))
(use-package! lispy
  :config
  (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1))))
;; (use-package auto-complete-auctex)
(use-package! cdlatex
  :after tex
  :init
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex) ; with AUCTeX LaTeX mode
  (add-hook 'latex-mode-hook 'turn-on-cdlatex) ; with Emacs latex mode
  :custom
  (cdlatex-paired-parens "$[{(")
  (TeX-electric-sub-and-superscript t)
  :config
  (defun my-after-load-cdlatex ()
    (define-key cdlatex-mode-map "_" nil) t)
  (eval-after-load "cdlatex" '(my-after-load-cdlatex))
  (setq cdlatex-env-alist
		'(("pmatrix" "\\begin{equation}\n\t\\begin{pmatrix}\n\t ? &  &  &  &  \\\\\n\t  &  &  &  &  \n\t\\end{pmatrix}\n\\end{equation}\n" nil)))
  (setq cdlatex-command-alist
		'(("ma" "Insert pmatrix env"   "" cdlatex-environment ("pmatrix") t nil)))
  )

;; use for no indent when you want to get a new
(when (fboundp 'electric-indent-mode)
  (electric-indent-mode -1))






;; ======================================== ;;
(use-package! org
  :defer
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
	 (shell . t)
	 (emacs-lisp t)
	 (python . t)
	 ))
  ;; (require 'color)
  ;; (set-face-attribute 'org-block nil :background
  ;; 					  (color-darken-name
  ;; 					   (face-attribute 'default :background) 3))
  ;; (setq org-src-block-faces '(("emacs-lisp" (:background "#EEE2FF"))
  ;; 							  ("python" (:background "#E5FFB8"))))
  )

;; ======================================== ;;
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (95 . 90)))
(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(80 . 60) '(100 . 100)))))

;; (global-set-key (kbd "SPC-t-t") 'toggle-transparency)



(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))




(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))
(global-set-key (kbd "C-c o") 'switch-to-minibuffer)
(map! (:leader
       (:desc "Switch to the minibuffer." :g "zo" #'switch-to-minibuffer)
       (:desc "Toggle alpha for emacs" :g "zt" #'toggle-transparency)
       (:desc "Change org2 user interface" :g "zu" #'org2blog-user-interface)
       (:desc "Open google browser" :g "zb" #'eaf-open-browser)
       (:desc "LSP find definition" :g "zf" #'lsp-find-definition)
       (:desc "LSP find reference" :g "zr" #'lsp-find-references)))

(use-package! ctable)
(use-package! deferred)
(use-package! epc)


(use-package! ctable)
(use-package! deferred)
(use-package! epc)
(add-load-path! "/home/sayno/.emacs.d/.local/straight/repos/emacs-application-framework")
(require 'eaf)
(require 'eaf-pdf-viewer)
(after! tex
  (setq eaf-browser-translate-language "es")
  (setq eaf-browser-continue-where-left-off t)
  (setq browse-url-browser-function 'eaf-open-browser)
  (defalias 'browse-web #'eaf-open-browser)
  (setq eaf-browser-default-search-engine "duckduckgo")
  (setq eaf-browse-blank-page-url "https://duckduckgo.com"))
(require 'eaf-terminal)
(require 'eaf-demo)
(require 'eaf-vue-demo)
(require 'eaf-markdown-previewer)
(require 'eaf-jupyter)
(require 'eaf-file-browser)
(require 'eaf-image-viewer)
(require 'eaf-camera)
(require 'eaf-system-monitor)
(require 'eaf-video-player)
(require 'eaf-file-sender)
(require 'eaf-netease-cloud-music)
(require 'eaf-music-player)
(require 'eaf-org-previewer)
(require 'eaf-mindmap)
(require 'eaf-airshare)
(require 'eaf-file-manager)
(require 'eaf-browser)
(require 'eaf-rss-reader)






(use-package! org2blog
  :config
  (setq org2blog/wp-blog-alist
        '(("myblog"
           :url "http://www.sayno.work/xmlrpc.php"
           :username ""
           :password ""
           :default-title "Hello World"
           :default-categories ("org2blog" "Java")
           :tags-as-categories nil))
        org2blog/wp-image-upload t)
  )
  ;; Whenever you reconfigure a package, make sure to wrap your config in an
  ;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
  ;;
  ;;   (after! PACKAGE
  ;;     (setq x y))
  ;;
  ;; The exceptions to this rule:
  ;;
  ;;   - Setting file/directory variables (like `org-directory')
  ;;   - Setting variables which explicitly tell you to set them before their
  ;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
  ;;   - Setting doom variables (which start with 'doom-' or '+').
  ;;
  ;; Here are some additional functions/macros that will help you configure Doom.
  ;;
  ;; - `load!' for loading external *.el files relative to this one
  ;; - `use-package!' for configuring packages
  ;; - `after!' for running code after a package has loaded
  ;; - `add-load-path!' for adding directories to the `load-path', relative to
  ;;   this file. Emacs searches the `load-path' when you load packages with
  ;;   `require' or `use-package'.
  ;; - `map!' for binding new keys
  ;;
  ;; To get information about any of these functions/macros, move the cursor over
  ;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
  ;; This will open documentation for it, including demos of how they are used.
  ;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
  ;; etc).
  ;;
  ;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
  ;; they are implemented.
