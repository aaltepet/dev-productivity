 ;;; package --- Summary
;;; Commentary:
;;; Code:

;; MODES
;; tide: https://github.com/ananthakumaran/tide
;; -- typescript IDE
;;
;; eldoc: https://www.emacswiki.org/emacs/ElDoc
;; (globally available, default-enabled)
;; -- enabled by default, provides type-hints in the command frame
;;
;; web-mode: http://web-mode.org/
;; -- major mode for editing web templates
;;
;; flycheck-mode: https://www.flycheck.org/en/latest/
;; (dependency auto-installed by tide)
;; -- syntax checking
;;
;; hideshowvis-mode:
;; -- best code folding
;;
;; nlinum-mode:
;; -- line numbers
;; -- has a global switch to auto-enable in every buffer!
;;
;; company-mode: https://company-mode.github.io/
;; -- text completion framework (i.e. COMPleteANYthing)
;; -- tide has support for company, so js/ts files get auto-complete thanks to tsserver!

(require 'package)
(add-to-list 'package-archives
              '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; custom lisp can be installed here
(add-to-list 'load-path "~/.emacs.d/lisp")

;; https://masteringemacs.org/article/introduction-to-ido-mode
(require 'ido)
(ido-mode t)
; always create a new buffer if the name doesn't match.
(setq ido-create-new-buffer 'always)
;; disable auto searching for files unless called explicitly
(setq ido-auto-merge-delay-time 99999)

; (setq ido-file-extensions-order '(".ts" ".js" ".test.ts" ".test.js"))
;; possibly use this to move x.test.[tj]s to be after the actual module
; (add-hook 'ido-make-buffer-list-hook 'ido-summary-buffers-to-end)


;; themes are installed here.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; install the monokai theme globally; use in all buffers
(load-theme 'monokai t)

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better
;; http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; hot-keys to increase/decrease font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
;; ALT-g - goto line
(global-set-key "\M-g" 'goto-line)

(setq tab-width 4)
(setq-default indent-tabs-mode nil)

    ;(yaml-mode prettier-js ac-js2 rjsx-mode hideshow-org hideshowvis json-mode js-doc icicles folding exec-path-from-shell monokai-theme js2-refactor auto-complete auto-compile skewer-mode js2-mode imenu+ jsx-mode)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(backup-inhibited t t)
 '(column-number-mode t)
 '(company-tooltip-align-annotations t)
 '(custom-safe-themes
   (quote
    ("c7a9a68bd07e38620a5508fef62ec079d274475c8f92d75ed0c33c45fbe306bc" default)))
 '(delete-selection-mode t)
 '(desktop-buffers-not-to-save "\\`|\\* ")
 '(desktop-lazy-verbose t)
 '(desktop-restore-eager 4)
 '(desktop-save-mode t)
 '(electric-indent-mode nil)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(package-selected-packages
   (quote
    (magit find-file-in-repository company config-general-mode yaml-mode prettier-js js2-mode web-mode tide exec-path-from-shell monokai-theme)))
 '(select-enable-clipboard t)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

;; https://www.emacswiki.org/emacs/SetFonts
;; M-x mac-font-panel-mode and pick the font you want.
;; M-x describe-font and copy the font name (e.g. “-apple-inconsolata-medium-r-normal--13-130-72-72-m-130-iso10646-1”)
;; Add the following to your .emacs file:
(set-default-font "-*-Input Mono Narrow-normal-normal-extracondensed-*-12-*-*-*-m-0-iso10646-1")

;; use Consolas font
;;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;; '(default ((t (:inherit nil :stipple nil :background "#272822" :foreground "#F8F8F2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight light :height 140 :width normal :foundry "nil" :family "Input"))))
;; '(font-lock-builtin-face ((t (:foreground "#F92672" :weight light)))))

; emacs yes/no questions are now y/n
(defalias 'yes-or-no-p 'y-or-n-p)

; delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'web-mode)
(require 'flycheck)
(require 'yaml-mode)

;; globally enable company mode
(add-hook 'after-init-hook 'global-company-mode)

; enable flycheck globally -- for automatic syntax checking
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-check-syntax-automatically '(mode-enabled save idle-change new-line))

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

;;; -- for debugging tide
(setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"))
;;; (setq tide-tsserver-executable "node_modules/typescript/bin/tsserver")

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  ; this was recommended but doesn't seem to work
  ;(setq flycheck-check-syntax-automatically '(save mode-enabled))
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1)
)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; in emacs 27 js-mode is much better, but for now remap *.js
;; to use js2-mode.
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.tsx" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.env\\'" . config-general-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)
(add-hook 'js2-mode-hook #'setup-tide-mode)
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; -- jsx-tide not installed (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
;; -- javascript-tide is not installed (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)

(defun add-to-multiple-hooks (function hooks)
  (mapc (lambda (hook)
          (add-hook hook function))
        hooks))

;; curl https://raw.githubusercontent.com/sheijk/hideshowvis/master/hideshowvis.el > ~/.emacs.d/lisp/hideshowvis.el
(require 'hideshowvis)
(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
(autoload 'hideshowvis-minor-mode
  "hideshowvis"
  "Will indicate regions foldable with hideshow in the fringe."
  'interactive)

(add-to-multiple-hooks
 'hideshowvis-enable
 '(text-mode-hook web-mode-hook js2-mode-hook typescript-mode-hook sh-mode-hook))

;; sudo npm install -g prettier
(require 'prettier-js)
(add-to-multiple-hooks
  'prettier-js-mode
  '(web-mode-hook typescript-mode-hook js2-mode-hook))

;;; http://stackoverflow.com/a/29556894
;(defun update-buffer-modtime-if-byte-identical ()
;  (let* ((size      (buffer-size))
;         (byte-size (position-bytes size))
;         (filename  buffer-file-name))
;    (when (and byte-size (<= size 1000000))
;      (let* ((attributes (file-attributes filename))
;             (file-size  (nth 7 attributes)))
;        (when (and file-size
;                   (= file-size byte-size)
;                   (string= (buffer-substring-no-properties 1 (1+ size))
;                            (with-temp-buffer
;                              (insert-file-contents filename)
;                              (buffer-string))))
;          (set-visited-file-modtime (nth 5 attributes))
;          t)))))
;
;(defun verify-visited-file-modtime--ignore-byte-identical (original &optional buffer)
;  (or (funcall original buffer)
;      (with-current-buffer buffer
;        (update-buffer-modtime-if-byte-identical))))
;(advice-add 'verify-visited-file-modtime :around #'verify-visited-file-modtime--ignore-byte-identical)
;
;(defun ask-user-about-supersession-threat--ignore-byte-identical (original &rest arguments)
;  (unless (update-buffer-modtime-if-byte-identical)
;    (apply original arguments)))
;(advice-add 'ask-user-about-supersession-threat :around #'ask-user-about-supersession-threat--ignore-byte-identical)
;
(provide '.emacs)
;;; .emacs ends here
