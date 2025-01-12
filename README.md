# 42-emacs

**A comprehensive Emacs configuration for 42 students, featuring on-the-fly Norminette checks and a 42 header insertion command.**

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Troubleshooting](#troubleshooting)
6. [Contributing](#contributing)
7. [License](#license)

---

## Overview

This repository contains an `init.el` (or `.emacs`) setup customized for **42 coding norms**. The configuration integrates:
- **Flycheck** with a custom Norminette checker
- A function to **insert the 42 header** into new `.c` files
- Various convenience settings (highlight trailing whitespace, minimal UI, etc.)

It is intended to help 42 students maintain Norm-compliant code and speed up development by providing immediate feedback on common style issues.

---

## Features

1. **Real-Time Norminette Checks**  
   Runs the latest Norminette tool automatically on file save or after a short idle period.

2. **42 Header Insertion**  
   Quickly add the standard 42 header to new `.c` (and `.h`) files via `M-x insert-42-header`.

3. **Minimal UI & Productivity Enhancements**  
   - Line numbers and column numbers  
   - Highlighting of trailing whitespace (to avoid norm errors)  
   - Spaces instead of tabs by default  
   - Automatic file reloading if changed on disk (auto-revert)
  
4. **Automatic Backups**

This Emacs configuration automatically creates backup files whenever you **save** a file, and stores them in `~/.emacs.d/backups`. Likewise, **auto-save** files (the ones Emacs creates periodically while you edit) go into `~/.emacs.d/auto-saves/`. This keeps your project folders clean and ensures you always have older versions of files available if you need to revert changes or recover from crashes.

**How it works:**
- **On Save**: Emacs copies the previous version of your file into the `backups` folder. You’ll often see filenames with a `~` suffix or version number in there.
- **While Editing**: Emacs periodically writes auto-saves to `auto-saves/`. If Emacs or your computer crashes, you can recover in-progress edits from those files.
- **Recovery**: To restore a backup, open it directly from `~/.emacs.d/backups/`, or use Emacs’ built-in commands (like `M-x recover-file`) to revert changes.
- **Customization**: If you prefer different behavior (or no backups at all), simply remove or edit these lines in `init.el`:
  ```elisp
  (setq backup-directory-alist `(("." . "~/.emacs.d/backups"))
        make-backup-files t
        auto-save-default t
        auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-saves/" t)))


---

## Installation

1. **Clone this Repo** (or copy the files) into your home directory (or wherever you store your Emacs config):
   ```bash
   git clone https://github.com/<your-username>/42-emacs.git
   ```
2. **Link the config** so Emacs can load it. Common options:
   - **If you use `~/.emacs.d/init.el`:**
     ```bash
     ln -s /path/to/42-emacs/init.el ~/.emacs.d/init.el
     ```
   - **If you use `~/.emacs`:**
     ```bash
     ln -s /path/to/42-emacs/init.el ~/.emacs
     ```
3. **Restart Emacs**.  
4. **Confirm** that Flycheck and Norminette are installed. If not, from within Emacs:
   - `M-x package-refresh-contents`
   - `M-x package-install flycheck`
   - Ensure you have Norminette installed globally (e.g., `pip3 install norminette`).

---

## Usage

1. **Open a C file** in Emacs.  
2. **Check Norm**: Once you save or idle for a few seconds, Flycheck should highlight any Norminette errors or warnings inline.  
3. **Insert 42 header**: In a new `.c` or `.h` file, type:
   ```
   M-x insert-42-header
   ```
   This command inserts the standard 42 header at the top of the file. Edit the placeholders (`YOUR_LOGIN`) accordingly.  
4. **Navigation**:  
   - Next error: `M-g n`  
   - Previous error: `M-g p`  
   - List errors: `M-x flycheck-list-errors`

---

## Troubleshooting

- **Syntax error at startup**:  
  - Make sure you have **matching parentheses** in `init.el`. You can run `M-x check-parens` to quickly find mismatches.

- **No Norminette errors** even if code is non-compliant:  
  - Ensure `norminette --version` works in a terminal.  
  - Check that your Flycheck checker is set to `norminette` (see your `c-mode-hook` in `init.el`).

- **Header not inserting**:  
  - Verify you have the correct function name, `insert-42-header`, and that it’s defined in your config.

- **Emacs ignoring config**:  
  - Make sure the file is **really** at `~/.emacs.d/init.el` (or `~/.emacs`).  
  - Use `emacs --debug-init` to see any startup errors.

---

## Contributing

1. **Fork** the project.  
2. Create a new **branch** for your feature or fix:
   ```bash
   git checkout -b my-new-feature
   ```
3. Commit your changes and **push** to your branch:
   ```bash
   git commit -am 'Add some feature'
   git push origin my-new-feature
   ```
4. **Open a Pull Request** on GitHub.

---

## License

This project is open-source. You may use, modify, and distribute it freely. No official affiliation with 42; use at your own risk!

```
MIT License
Copyright (c) 2025 yfe404

Permission is hereby granted, free of charge, to any person obtaining a copy...
```
