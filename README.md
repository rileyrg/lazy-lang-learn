- [lazy-lang-learn.el periodic display of new snippet to translate](#orgdb75651)
  - [Screenshots](#org939d947)
    - [A new snippet pops after `lazy-lang-learn--period`](#org02e8518)
    - [translate it with `lazy-lang-learn-translate`](#orgb24155c)
    - [translate older snippets  with `lazy-lang-learn-translate-from-history`](#org0cf8ca9)
  - [requirements](#org572dd2d)
    - [google-translate](#orgb2b3352)
    - [alert](#org2f5d663)
    - [fortunes-de](#org9dd38ad)
  - [usage](#orgd2f932c)
  - [customisation](#org83cac14)
    - [`lazy-lang-learn--period`](#org1c4c1f4)
    - [`lazy-lang-learn--function`](#org39f625f)
    - [`lazy-lang-learn--display-function`](#orgb73fe5f)
    - [`lazy-lang-learn--history-length`](#org067a170)
    - [`lazy-lang-learn--history-file`](#org698eb27)
    - [`lazy-lang-learn--lighter`](#org8638d18)
  - [TODO](#org1990fc2)
    - [have the minor mode timer pop up existing ones from the history if so configured.](#org9eb4c18)
    - [hot key to remove immediately last snippet](#org13816a4)
    - [delete from history](#org1fb61a1)
    - [migrate the history format to an org file maybe so add things like view count etc etc](#org0623e83)

Lazy timer based display of things to learn. Ability to recall and translate with presistance across sessions.


<a id="orgdb75651"></a>

# lazy-lang-learn.el periodic display of new snippet to translate

Defines a new minor-mode `lazy-lang-learn-mode` which calls out to `lazy-lang-learn--function` for a new snippet and displays it with `lazy-lang-learn--display-function`. Stores it in `lazy-lang-learn--history` which can be browsed and translated via `lazy-lang-learn--translate-from-history`. Newly displayed snippets can be immediately translated using `lazy-lang-learn-translate`.


<a id="org939d947"></a>

## Screenshots


<a id="org02e8518"></a>

### A new snippet pops after `lazy-lang-learn--period`

![img](images/lazy-lang-learn--new.png "lazy-lang-learn display new snippet using alert library")


<a id="orgb24155c"></a>

### translate it with `lazy-lang-learn-translate`

![img](images/lazy-lang-learn--translate.png "lazy-lang-learn translate latest snippet")


<a id="org0cf8ca9"></a>

### translate older snippets  with `lazy-lang-learn-translate-from-history`

![img](images/lazy-lang-learn--translate-from-history.png "lazy-lang-learn translate from history")


<a id="org572dd2d"></a>

## requirements


<a id="orgb2b3352"></a>

### google-translate

This whole thing is based around using [google-translate](https://github.com/atykhonov/google-translate), a package that allows you to translate strings using Google Translate service directly from GNU Emacs.


<a id="org2f5d663"></a>

### alert

The default `lazy-lang-learn--display-function` is set to `'alert`. See [alert](https://github.com/jwiegley/alert).


<a id="org9dd38ad"></a>

### fortunes-de

Debian comes with `fortunes-de` which is the default snippet generator used by `lazy-lang-learn--function` default function `lazy-lang-learn--german-fortune`.

```bash
sudo apt install fortunes-de
```


<a id="orgd2f932c"></a>

## usage

```emacs-lisp
(use-package lazy-lang-learn
  :straight (lazy-lang-learn :local-repo "~/development/projects/emacs/lazy-lang-learn" :type git :host github :repo "rileyrg/lazy-lang-learn" )
  :bind
  ("C-c L" . lazy-lang-learn-mode)
  ("<f12>" . lazy-lang-learn-translate)
  ("S-<f12>" . lazy-lang-learn-translate-from-history))
```


<a id="org83cac14"></a>

## customisation

Customisation group `lazy-lang-learn`


<a id="org1c4c1f4"></a>

### `lazy-lang-learn--period`

Idle time in seconds before it fetches a new snippet to display


<a id="org39f625f"></a>

### `lazy-lang-learn--function`

Holds the name of a function to return snippets to store and later translate. Currently defaults to `lazy-lang-learn--german-fortune` which simply calls out to the shell to get a unix fortune snippet&#x2026;

```emacs-lisp
(defun lazy-lang-learn--german-fortune()
  "Return a german fortune string."
  (shell-command-to-string "fortune de"))
```


<a id="orgb73fe5f"></a>

### `lazy-lang-learn--display-function`

Holds the name of a function to display new snippets to browse. Defaults to [alert](https://github.com/jwiegley/alert).


<a id="org067a170"></a>

### `lazy-lang-learn--history-length`

How many snippets to keep and save in `lazy-lang-learn--history-file`


<a id="org698eb27"></a>

### `lazy-lang-learn--history-file`

The file used to store language snippets.


<a id="org8638d18"></a>

### `lazy-lang-learn--lighter`

The minor mode indicator in the mode line.


<a id="org1990fc2"></a>

## TODO


<a id="org9eb4c18"></a>

### have the minor mode timer pop up existing ones from the history if so configured.


<a id="org13816a4"></a>

### hot key to remove immediately last snippet


<a id="org1fb61a1"></a>

### delete from history


<a id="org0623e83"></a>

### migrate the history format to an org file maybe so add things like view count etc etc
