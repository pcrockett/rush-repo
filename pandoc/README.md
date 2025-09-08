# pandoc

why install from rush / github releases when it's so well-packaged in basically all
linux distros? because we get a static executable from GH releases.

why do i want the static executable? because, at least in archlinux, the `pandoc-cli`
package has hundreds of megabytes'-worth of haskell dependencies, and nearly _every_
`pacman -Syu` requires downloading them all. it's just so much faster to download one
static executable than it is to replace these dozens of dependencies on my machine every
couple of days.
