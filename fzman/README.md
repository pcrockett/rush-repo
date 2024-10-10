# fzman

a man page search UI using fzf.

## troubleshooting

from [arch wiki](https://wiki.archlinux.org/title/Man_page#Searching_manuals):

> Note: The search feature is provided by a dedicated cache. By default, maintenance of that cache
> is handled by `man-db.service` which gets periodically triggered by `man-db.timer`. If you are
> getting a "nothing appropriate" message for every search, try manually regenerating the cache by
> running `mandb` as root.
