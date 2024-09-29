;;; lsp-ada.el --- description -*- lexical-binding: t; -*-

;; Copyright (C) 2020 emacs-lsp maintainers

;; Author: emacs-lsp maintainers
;; Keywords: lsp, ada

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; LSP Clients for the Ada Programming Language

;;; Code:

(require 'lsp-mode)
(require 'lsp-semantic-tokens)

(defgroup lsp-ada nil
  "Settings for Ada Language Server."
  :group 'lsp-mode
  :link `(url-link :tag "Settings Documentation"
                   ,(concat "https://github.com/AdaCore/ada_language_server"
                            "/blob/master/doc/settings.md"))
  :prefix "lsp-ada-"
  :package-version '(lsp-mode . "6.2"))

(lsp-defcustom lsp-ada-project-file nil
  "GNAT Project file used to configure the Language Server.

Both absolute and relative paths are supported within the project file
name.  When a relative path is used, the path is relative to the root
folder.

When the project file is not specified, the Language Server will attempt
to determine the project file itself, either by querying \\='alr\\=', if
the root folder contains an alire.toml file and \\='alr\\=' was found in
the path, or otherwise by searching for a unique project file in the
root folder.  For Alire projects, whose project file was discovered by
querying \\='alr\\=', the server will also query and populate the Alire
environment."
  :type '(choice (string :tag "File")
                 (const  :tag "Not Specified" nil))
  :group 'lsp-ada
  :link '(url-link :tag "Configuration Example"
                   "https://github.com/AdaCore/ada_language_server")
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.projectFile")
;;;###autoload(put 'lsp-ada-project-file 'safe-local-variable 'stringp)

(lsp-defcustom lsp-ada-option-charset "UTF-8"
  "The charset to use by the Ada Language server.  Defaults to \\='UTF-8\\='."
  :type 'string
  :group 'lsp-ada
  :package-version '(lsp-mode . "6.2")
  :lsp-path "ada.defaultCharset")
;;;###autoload(put 'lsp-ada-option-charset 'safe-local-variable 'stringp)

(lsp-defcustom lsp-ada-display-method-ancestry-on-navigation nil
  "Policy for displaying overriding/overridden subprograms on navigation requests."
  :type '(choice (const "never")
                 (const "usage_and_abstract_only")
                 (const "definition_only")
                 (const "always")
                 (const :tag "Not Specified" nil))
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.displayMethodAncestryOnNavigation")
;;;###autoload(put 'lsp-ada-display-method-ancestry-on-navigation 'safe-local-variable 'stringp)

(lsp-defcustom lsp-ada-documentation-style nil
  "Style used to extract documentation for an entity."
  :type '(choice (const "gnat")
                 (const "leading")
                 (const :tag "Not Specified" nil))
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.documentationStyle")
;;;###autoload(put 'lsp-ada-documentation-style 'safe-local-variable 'stringp)

(lsp-defcustom lsp-ada-enable-diagnostics t
  "A boolean to disable diagnostics.  Defaults to true."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "6.2")
  :lsp-path "ada.enableDiagnostics")
;;;###autoload(put 'lsp-ada-enable-diagnostics 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-enable-indexing t
  "Whether the server indexes the source files after loading a project."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "6.2")
  :lsp-path "ada.enableIndexing")
;;;###autoload(put 'lsp-ada-enable-indexing 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-fold-comments t
  "Whether the server sends information to control folding comment blocks."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.foldComments")
;;;###autoload(put 'lsp-ada-fold-comments 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-follow-symlinks t
  "Whether the server attempts to resolve symlinks for file names."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.followSymlinks")
;;;###autoload(put 'lsp-ada-follow-symlinks 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-insert-with-clauses t
  "Whether to automatically insert missing with-clauses for completions."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.insertWithClauses")
;;;###autoload(put 'lsp-ada-insert-with-clauses 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-named-notation-threshold nil
  "Number of parameters when named notation is used in completion snippets."
  :type 'integer
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.namedNotationThreshold")
;;;###autoload(put 'lsp-ada-named-notation-threshold 'safe-local-variable 'integerp)

(lsp-defcustom lsp-ada-on-type-formatting-indent-only t
  "Whether textDocument/onTypeFormatting request only indents a new line."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.onTypeFormatting.indentOnly")
;;;###autoload(put 'lsp-ada-on-type-formatting-indent-only 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-project-diagnostics t
  "Whether the Ada Language Server should emit project diagnostics.

This setting is ignored if `lsp-ada-enable-diagnostics' is nil.  A
workspace reload is necessary to refresh the diagnostics after modifying
this setting."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.projectDiagnostics")
;;;###autoload(put 'lsp-ada-project-diagnostics 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-relocate-build-tree nil
  "Path to use for out-of-tree builds."
  :type 'string
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.relocateBuildTree")
;;;###autoload(put 'lsp-ada-relocate-build-tree 'safe-local-variable 'stringp)

(lsp-defcustom lsp-ada-root-dir nil
  "The root directory for artifact relocation.

This setting must be used in conjunction with `lsp-ada-relocate-build-tree'."
  :type 'string
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.rootDir")
;;;###autoload(put 'lsp-ada-root-dir 'safe-local-variable 'stringp)

(lsp-defcustom lsp-ada-rename-in-comments nil
  "Whether to apply textDocument/rename to comments."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.renameInComments")
;;;###autoload(put 'lsp-ada-rename-in-comments 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-scenario-variables nil
  "Scenario variables for project."
  :type '(alist :tag "Scenario Variable(s)"
                :key-type (symbol :tag "Variable Name")
                :value-type (string :tag "Value"))
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.scenarioVariables")
;;;###autoload
(put 'lsp-ada-scenario-variables
     'safe-local-variable
     (lambda (object)
       (while (and (consp object)
                   (consp (car object))
                   (symbolp (caar object))
                   (stringp (cdar object)))
         (setq object (cdr object)))
       (null object)))

(lsp-defcustom lsp-ada-use-completion-snippets t
  "Whether to enable snippets in completion results."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.useCompletionSnippets")
;;;###autoload(put 'lsp-ada-use-completion-snippets 'safe-local-variable 'booleanp)

(lsp-defcustom lsp-ada-use-gnatformat nil
  "Enables GNATformat as the formatting provider for Ada source files.

This option controls the formatting provider.  If disabled, GNATpp is
used instead."
  :type 'boolean
  :group 'lsp-ada
  :package-version '(lsp-mode . "9.0.1")
  :lsp-path "ada.useGnatformat")
;;;###autoload(put 'lsp-ada-use-gnatformat 'safe-local-variable 'booleanp)

(defcustom lsp-ada-als-executable "ada_language_server"
  "Command to start the Ada language server."
  :group 'lsp-ada
  :risky t
  :type 'file)

(defcustom lsp-ada-library-folders #'lsp-ada--default-library-folders
  "List of Ada library folders.

Library folders contain source which may be visited from a workspace,
but whose source files are not themselves considered a separate
workspace.  This typically applies to language run-time source file
folders.

Instead of a list of a folders, a function may be provided, which will
be called with the most recently active workspace as a parameter and
must return a list of Ada library folders, or nil if none."
  :group 'lsp-ada
  :type '(choice function
                 (repeat :tag "Library Folders"
                         (directory :tag "Library Folder")))
  :package-version '(lsp-mode . "9.0.1"))
;;;###autoload(put 'lsp-ada-library-folders 'safe-local-variable 'list-of-strings-p)

(defcustom lsp-ada-semantic-token-face-overrides
  '(("namespace" . default)
    ("modifier"  . lsp-face-semhl-keyword))
  "Semantic token face overrides to be applied."
  :type '(alist :key-type string
                :value-type (choice (face  :tag "Face")
                                    (const :tag "No Face" nil)))
  :group 'lsp-ada
  :package-version '(lsp-mode "9.0.0"))

(defcustom lsp-ada-semantic-token-modifier-face-overrides
  '(("declaration")
    ("definition")
    ("implementation")
    ("static")
    ("modification")
    ("documentation")
    ("defaultLibrary"))
  "Semantic token modifier face overrides to be applied."
  :type '(alist :key-type string
                :value-type (choice (face  :tag "Face")
                                    (const :tag "No Face" nil)))
  :group 'lsp-ada
  :package-version '(lsp-mode "9.0.0"))

(defvar lsp-ada--als-download-url-cache nil)

(defvar lsp-ada--als-downloaded-executable
  (f-join lsp-server-install-dir
          "ada-ls"
          (symbol-name (lsp-resolve-value lsp--system-arch))
          (pcase system-type
            ('gnu/linux  "linux")
            ('darwin     "darwin")
            ('windows-nt "win32")
            (_           "linux"))
          (concat "ada_language_server"
                  (pcase system-type
                    ('windows-nt ".exe")
                    (_ "")))))

(defun lsp-ada--als-latest-release-url ()
  "URL for the latest release of the Ada Language Server."
  (setq lsp-ada--als-download-url-cache
        (lsp--find-latest-gh-release-url
         "https://api.github.com/repos/AdaCore/ada_language_server/releases/latest"
         (format "%s.zip"
                 (pcase (list system-type (lsp-resolve-value lsp--system-arch))
                   ('(gnu/linux  x64)   "Linux_amd64")
                   ('(gnu/linux  arm64) "Linux_aarch64")
                   ('(darwin     x64)   "macOS_amd64")
                   ('(darwin     arm64) "macOS_aarch64")
                   ('(windows-nt x64)   "Windows_amd64")
                   (`(,_         x64)   "Linux_amd64"))))))

(defun lsp-ada--als-store-path ()
  "Store Path for the downloaded Ada Language Server."
  (f-join lsp-server-install-dir
          "ada-ls"
          (file-name-base (or lsp-ada--als-download-url-cache
                              (lsp-ada--als-latest-release-url)
                              "ada-ls"))))

(defun lsp-ada--default-library-folders (_workspace)
  "Determine the set of Ada library folders."
  (when (string-match-p "/adainclude/" (buffer-file-name))
    (list (file-name-directory (buffer-file-name)))))

(lsp-dependency
 'ada-ls
 '(:download :url lsp-ada--als-latest-release-url
             :store-path lsp-ada--als-store-path
             :decompress :zip
             :binary-path lsp-ada--als-downloaded-executable
             :set-executable? t)
 '(:system lsp-ada-als-executable))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection
                                   (lambda () (lsp-package-path 'ada-ls)))
                  :major-modes '(ada-mode ada-ts-mode)
                  :priority -1
                  :initialization-options (lambda ()
                                            (ht-get (lsp-configuration-section "ada") "ada"))
                  ;; Send workspace/didChangeConfiguration as a workaround for:
                  ;;   https://github.com/AdaCore/ada_language_server/issues/1209
                  :initialized-fn (lambda (workspace)
                                    (with-lsp-workspace workspace
                                                        (lsp--set-configuration
                                                         (lsp-configuration-section "ada"))))
                  :library-folders-fn (lambda (workspace)
                                        (if (functionp lsp-ada-library-folders)
                                            (funcall lsp-ada-library-folders workspace)
                                          lsp-ada-library-folders))
                  :download-server-fn (lambda (_client callback error-callback _update?)
                                        (lsp-package-ensure 'ada-ls callback error-callback))
                  :semantic-tokens-faces-overrides `( :types ,lsp-ada-semantic-token-face-overrides
                                                      :modifiers ,lsp-ada-semantic-token-modifier-face-overrides)
                  :server-id 'ada-ls))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection
                                   (lambda () (list (lsp-package-path 'ada-ls)
                                                    "--language-gpr")))
                  :major-modes '(gpr-mode gpr-ts-mode)
                  :priority -1
                  :download-server-fn (lambda (_client callback error-callback _update?)
                                        (lsp-package-ensure 'ada-ls callback error-callback))
                  :server-id 'gpr-ls))

(lsp-consistency-check lsp-ada)

(provide 'lsp-ada)
;;; lsp-ada.el ends here
