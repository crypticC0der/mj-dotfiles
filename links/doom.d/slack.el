;;; ../.config/links/doom.d/slack.el -*- lexical-binding: t; -*-
(use-package helm-slack :after (slack)) ;; optional
(use-package slack
  :commands (slack-start)
  :init
  (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)
  :config
  (slack-register-team
   :name "FutaDomWorld"
   :default t
   :token "xoxc-515462684464-2443006127460-2437243308706-ba80e79c2521d6bda19ac10a017ebaad247d65ee51128d076b1a3cad6a9c30f0"
   :cookie "C%2Bvn7m7BPdV3eWj0rSVB3IR%2BvJwIHzdZyHxWYqdttvHX%2BuZhvlI0umGVYNW3b1VXWpE7qHnQjmAiUlWt8afIn8Hd%2F%2B6h4pmrDlxjz0sFhwUPSqzNI7mxk5i5OGMfE1og%2FP%2B4w3RxgEredcQ3bN2yAXZ1x7%2FwLtSRY1RS%2BMLbGGoarIez%2FW1Okufu"
   :subscribed-channels '(animation art empress general random)
   :full-and-display-names t)

  (evil-define-key 'normal slack-info-mode-map
    ",u" 'slack-room-update-messages)
  (evil-define-key 'normal slack-mode-map
    ",c" 'slack-buffer-kill
    ",ra" 'slack-message-add-reaction
    ",rr" 'slack-message-remove-reaction
    ",rs" 'slack-message-show-reaction-users
    ",pl" 'slack-room-pins-list
    ",pa" 'slack-message-pins-add
    ",pr" 'slack-message-pins-remove
    ",mm" 'slack-message-write-another-buffer
    ",me" 'slack-message-edit
    ",md" 'slack-message-delete
    ",u" 'slack-room-update-messages
    ",2" 'slack-message-embed-mention
    ",3" 'slack-message-embed-channel
    "\C-n" 'slack-buffer-goto-next-message
    "\C-p" 'slack-buffer-goto-prev-message)
   (evil-define-key 'normal slack-edit-message-mode-map
    ",k" 'slack-message-cancel-edit
    ",s" 'slack-message-send-from-buffer
    ",2" 'slack-message-embed-mention
    ",3" 'slack-message-embed-channel))

(use-package alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier))
