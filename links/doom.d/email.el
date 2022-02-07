;; MU4E
;;

(use-package mu4e)

;; Update path to mu for macOS as needed
(when (eq system-type 'darwin)
  (add-to-list 'load-path "/usr/local/Cellar/mu/1.0_1/share/emacs/site-lisp/mu/mu4e"))
(require 'mu4e)

;; spell check
(add-hook 'mu4e-compose-mode-hook 'flyspell-mode)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

;; for mbsync
(setq mu4e-change-filenames-when-moving t)

;; Path to emails
(setq mu4e-maildir "~/Maildir")

;; default account: gmail
(setq mu4e-sent-folder "/.sent"
      mu4e-drafts-folder "/.drafts"
      user-mail-address "wp23456.awsomeness@gmail.com"
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-local-domain "gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-stream-type 'starttls
      smtpmail-smtp-service 587)

(require 'smtpmail)

(setq message-send-mail-function 'smtpmail-send-it)

;; Outlook and gmail contexts
(setq mu4e-contexts
      `( ,(make-mu4e-context
          :name "gmail-personal"
          :enter-func (lambda () (mu4e-message "Entering Gmail context"))
          :leave-func (lambda () (mu4e-message "Leaving Gmail context"))
          ;; we match based on the maildir of the message
		  :match-func (lambda (msg)
                        (when msg
                          (string-match-p "^/wp23456" (mu4e-message-field msg :maildir))))
          :vars '( ( user-mail-address . "wp23456.awsomeness@gmail.com"  )
				   (smtpmail-smtp-user . "wp23456.awsomeness")
				   ( smtpmail-smtp-server . "smtp.gmail.com" )
                   ( user-full-name . "MJ Ponsonby" )
				   ( mu4e-trash-folder . "/wp23456/[Gmail].Trash" )
				   ( mu4e-refile-folder . "/wp23456/[Gmail].Archive" )
				   ( mu4e-drafts-folder . "/wp23456/[Gmail].Drafts" )
                   ( mu4e-compose-signature .
                     (concat
                       "MJ Ponsonby\n"))))
       ,(make-mu4e-context
          :name "family"
          :enter-func (lambda () (mu4e-message "Entering the Outlook context"))
		  :leave-func (lambda () (mu4e-message "Leaving Outlook context"))
          ;; we match based on the maildir of the message
          :match-func (lambda (msg)
                        (when msg
                          (string-match-p "^/wponsonby" (mu4e-message-field msg :maildir))))
          :vars '( ( user-mail-address . "will@ponsonby.org" )
				   ( smtpmail-smtp-user . "will@ponsonby.org" )
				   ( smtpmail-smtp-server . "smtp.iomartmail.com" )
                                   ( smtpmail-smtp-service . 465 )
                                   ( smtpmail-auth-credentials '(("smtp.iomartmail.com" 465 "will@ponsonby.org" nil)) )
                                   ( smtpmail-starttls-credentials '(("smtp.iomartmail.com" 465 nil nil)))
                   ( user-full-name . "MJ Ponsonby" )
				   ( mu4e-trash-folder . "/outlook/Deleted Items" )
				   ( mu4e-refile-folder . "/wponsonby/Archive" )
				   ( mu4e-drafts-folder . "/wponsonby/Drafts" )
                   ( mu4e-compose-signature  .
                     (concat
                       "MJ Ponsonby\n"))))))


;; No automatic signature
(setq mu4e-compose-signature-auto-include nil)

;; don't save message to Sent Messages, Gmail & Outlook take care of this
(setq mu4e-sent-messages-behavior 'delete)

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; Default account is gmail -- this part might not be necessary
(setq message-send-mail-function 'smtpmail-send-it
   starttls-use-gnutls t
   smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
   smtpmail-auth-credentials
     '(("smtp.gmail.com" 587 "wp23456.awsomeness@gmail.com" nil))
   smtpmail-default-smtp-server "smtp.gmail.com"
   smtpmail-smtp-server "smtp.gmail.com"
   smtpmail-smtp-service 587)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; view message in browser by typing 'aV'
(add-to-list 'mu4e-view-actions
  '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; No line breaks in compose
(defun no-auto-fill ()
  "Turn off auto-fill-mode."
  (auto-fill-mode -1))

;; Turn off 80-character auto-wrap
(add-hook 'mu4e-compose-mode-hook #'no-auto-fill)

(global-set-key (kbd "C-c m n") 'mu4e)
(global-set-key (kbd "C-c m u") 'mu4e-update-mail-and-index)
(setq mu4e-hide-index-messages t) ;; Silence index messages
(setq mu4e-update-interval 600) ;; Update every 10 minutes

;; Load the org-mu4e package -- I installed this manually, not through
;; MELPA
(load "org-mu4e") ;; best not to include the ending “.el” or “.elc”

(require 'org-mu4e)

;; Turn off colors for message preview
(require 'mu4e-contrib)
(setq mu4e-html2text-command 'mu4e-shr2text)
(setq shr-color-visible-luminance-min 60)
(setq shr-color-visible-distance-min 5)
(setq shr-use-colors nil)
(advice-add #'shr-colorize-region :around (defun shr-no-colourise-region (&rest ignore)))


;; Additional commands

;; Keyboard macro to type in 'ac' -- this will capture the message
;; in mu4e-headers-mode.
(fset 'my-mu4e-action-capture
	  (lambda (&optional arg) "Keyboard macro." (interactive "p")
		(kmacro-exec-ring-item (quote ("ac" 0 "%d")) arg)))

(defun my-mu4e-forward-message ()
  "Forward the selected message."
  (interactive)
  (my-mu4e-action-capture)
  (compose-mail)
  (mu4e-compose-attach-captured-message))

(defun my-mu4e-headers-mode-config ()
  "For use in `mu4e-headers-mode-hook.'"
  (local-set-key (kbd "f") 'my-mu4e-forward-message))

(add-hook 'mu4e-headers-mode-hook 'my-mu4e-headers-mode-config)


;; MU4E-ALTERT
;;

(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)

(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
(setq mu4e-alert-set-window-urgency nil)
