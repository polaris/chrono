# chrono

This is a project to do ... something.

## Build executable

```
buildapp --output chrono                                     \
         --asdf-path ~/quicklisp/local-projects/chrono/      \
         --asdf-tree ~/quicklisp/dists/                      \
         --load-system chrono                                \
         --eval '(defun main (args) (chrono:toplevel args))' \
         --entry main                                        \
         --compress-core
```