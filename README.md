# h2o-alpine

(yet another) docker image for the pretty awesome web server [h2o][h2o].
Slightly opinionated since I don't need mruby.

Currently weighing in at 7mb:
```console
$ docker images   
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
h2o                      2.1.0-beta4         28afd78332d7        11 minutes ago      7.05 MB
``` 

No plans to add this to the docker registry for the moment; will likely expand
on customization beforehand.

[h2o]: https://h2o.examp1e.net
