- [lazy-lang-learn.el periodic display of new snippet to translate](#org0efd0f3)
  - [Screencast](#orge47165a)
  - [Screenshots](#org09cb4d0)
    - [A new snippet pops after `lazy-lang-learn--period`](#org9a955a8)
    - [translate it with `lazy-lang-learn-translate`](#org9d70512)
    - [translate older snippets  with `lazy-lang-learn-translate-from-history`](#orgd50f381)
  - [requirements](#org583cd96)
    - [google-translate](#org7098667)
    - [alert](#org6b7d0bf)
    - [fortunes-de](#org0dc6d97)
  - [usage](#org0ef0bf0)
    - [key functions](#org025b549)
  - [customisation](#org207c692)
    - [`lazy-lang-learn--period`](#org998e654)
    - [`lazy-lang-learn--function`](#org7c4a659)
    - [`lazy-lang-learn--display-function`](#orgad0e043)
    - [`lazy-lang-learn--history-length`](#orga72e89e)
    - [`lazy-lang-learn--history-file`](#org094c4f4)
    - [`lazy-lang-learn--lighter`](#org8ab4678)
  - [TODO](#org8fb39d0)
    - [have the minor mode timer pop up existing ones from the history if so configured.](#org5b7fa95)
    - [hot key to remove immediately last snippet](#org869f5f7)
    - [delete from history](#orgfc28c02)
    - [migrate the history format to an org file maybe so add things like view count etc etc](#orgf9dc994)
    - [random translate from history](#org1024d0c)

Lazy timer based display of things to learn. Ability to recall and translate with presistance across sessions.


<a id="org0efd0f3"></a>

# lazy-lang-learn.el periodic display of new snippet to translate

Defines a new minor-mode `lazy-lang-learn-mode` which calls out to `lazy-lang-learn--function` for a new snippet and displays it with `lazy-lang-learn--display-function`. Stores it in `lazy-lang-learn--history` which can be browsed and translated via `lazy-lang-learn--translate-from-history`. Newly displayed snippets can be immediately translated using `lazy-lang-learn-translate`.


<a id="orge47165a"></a>

## Screencast

A short [video](https://www.youtube.com/watch?v=FiqfG33UwA4) of lazy-lang-learn hosted on YouTube demonstrating it's usage. The first few seconds are blurred. No idea why but the rest is ok&#x2026;

```emacs-lisp
ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 output.mp4
```


<a id="org09cb4d0"></a>

## Screenshots


<a id="org9a955a8"></a>

### A new snippet pops after `lazy-lang-learn--period`

![img](images/lazy-lang-learn--new.png "lazy-lang-learn display new snippet using alert library")


<a id="org9d70512"></a>

### translate it with `lazy-lang-learn-translate`

![img](images/lazy-lang-learn--translate.png "lazy-lang-learn translate latest snippet")


<a id="orgd50f381"></a>

### translate older snippets  with `lazy-lang-learn-translate-from-history`

![img](images/lazy-lang-learn--translate-from-history.png "lazy-lang-learn translate from history")


<a id="org583cd96"></a>

## requirements


<a id="org7098667"></a>

### google-translate

This whole thing is based around using [google-translate](https://github.com/atykhonov/google-translate), a package that allows you to translate strings using Google Translate service directly from GNU Emacs. I have some customisations to this which can be found under [my own emacs configuration](https://github.com/rileyrg/Emacs-Customisations) in [rgr/google.el](https://github.com/rileyrg/Emacs-Customisations/blob/master/etc/elisp/rgr-google.el)


<a id="org6b7d0bf"></a>

### alert

The default `lazy-lang-learn--display-function` is set to `'alert`. See [alert](https://github.com/jwiegley/alert).


<a id="org0dc6d97"></a>

### fortunes-de

Debian comes with `fortunes-de` which is the default snippet generator used by `lazy-lang-learn--function` default function `lazy-lang-learn--german-fortune`.

```bash
sudo apt install fortunes-de
```


<a id="org0ef0bf0"></a>

## usage

`C-u lazy-lang-learn-translate` will translate a random snippet from the history.

```emacs-lisp
(use-package lazy-lang-learn
  :straight (lazy-lang-learn :local-repo "~/development/projects/emacs/lazy-lang-learn" :type git :host github :repo "rileyrg/lazy-lang-learn" )
  :bind
  ("C-c L" . lazy-lang-learn-mode)
  ("<f12>" . lazy-lang-learn-translate) ;; C-u f12 to translate a random history element.
  ("C-S-<f12>" . lazy-lang-learn-translate-random) ;; same as C-u lazy-lang-learn-translate
  ("S-<f12>" . lazy-lang-learn-translate-from-history))
```


<a id="org025b549"></a>

### key functions

-   `lazy-lang-learn-new`

    display a new snippet

-   `lazy-lang-learn-translate`

    translate last snippet displayed or translated. Prefix (C-u) to pick a random one from history.

-   `lazy-lang-learn-translate-random`

    translates a random element from history - calls `lazy-lang-learn-translate`

-   `lazy-lang-learn-translate-from-history`

    interactively select from history and translate


<a id="org207c692"></a>

## customisation

Customisation group `lazy-lang-learn`


<a id="org998e654"></a>

### `lazy-lang-learn--period`

Idle time in seconds before it fetches a new snippet to display


<a id="org7c4a659"></a>

### `lazy-lang-learn--function`

Holds the name of a function to return snippets to store and later translate. Currently defaults to `lazy-lang-learn--german-fortune` which simply calls out to the shell to get a unix fortune snippet&#x2026;

```emacs-lisp
(defun lazy-lang-learn--german-fortune()
  "Return a german fortune string."
  (shell-command-to-string "fortune de"))
```


<a id="orgad0e043"></a>

### `lazy-lang-learn--display-function`

Holds the name of a function to display new snippets to browse. Defaults to [alert](https://github.com/jwiegley/alert).


<a id="orga72e89e"></a>

### `lazy-lang-learn--history-length`

How many snippets to keep and save in `lazy-lang-learn--history-file`


<a id="org094c4f4"></a>

### `lazy-lang-learn--history-file`

The file used to store language snippets.


<a id="org8ab4678"></a>

### `lazy-lang-learn--lighter`

The minor mode indicator in the mode line.


<a id="org8fb39d0"></a>

## TODO


<a id="org5b7fa95"></a>

### have the minor mode timer pop up existing ones from the history if so configured.


<a id="org869f5f7"></a>

### hot key to remove immediately last snippet


<a id="orgfc28c02"></a>

### delete from history


<a id="orgf9dc994"></a>

### migrate the history format to an org file maybe so add things like view count etc etc


<a id="org1024d0c"></a>

### DONE random translate from history     :ARCHIVE:
