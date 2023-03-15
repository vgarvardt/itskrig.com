rKlotz - yet another blog engine in go
27 Dec 14 10:48 +0200
rklotz, go, boltdb, open source, golang

+++

Finally, I made it! Started the project in July, worked on it for several days, then suspended it, returned several days ago, gave it new name, spent several evenings and now -- it's production-ready.

About a half of year ago I started to look closer at the go language -- it it quite simple and have concurrency as its killer-feature. But solving tutorial tasks is quite boring, so I decided to do a project using this language and its technologies. My first idea was a web-based game and I started to implement it with [Revel](http://revel.github.io/) as web-framework, [GORM](https://github.com/jinzhu/gorm) as ORM and Postgres as DB. I even made several pull requests to GORM to implement couple features that I required. But couple weeks later I understood that project progress moves too slow as I don't have enough experience neither with go language nor with its tools to complete the project in appropriate time. So I decided to implement much simpler project first. And for me, the most simple web-project type is simple blog engine.

I subscribed to several go lists in Twitter -- [Golang Inside](https://twitter.com/GoLangInside), [Go News](https://twitter.com/golang_news), [Go Newsletter](https://twitter.com/golangweekly), [Go](https://twitter.com/golang), [Golang Go](https://twitter.com/GolangGo) and Russian Go news aggregator [4gophers](http://4gophers.com/). This gave me list of cool golang projects.

I choose web-framework quite fast -- [Gin Gonic](http://gin-gonic.github.io/gin/) is small and fast one, has everything I need for my new small project. Another cool project I found is [Pongo2](https://github.com/flosch/pongo2) -- template engine with Django-like synthax, and I find this type of synthax to be the one I like much more than [go html templates](http://golang.org/pkg/html/template/). I abandoned the idea of writing common blog engine with common relational (MySQL, Postgres) or No-SQL (Mongo, Redis, etc.) solution as I wanted to write something new and interesting for me. I thought about static blog with posts saved to SQLite or, even, files, compiled to HTML on save and served by web-server. But then I found the [BoltDB](https://github.com/boltdb/bolt) project. It was exactly what I needed -- pure-go, simple and no db  server required, everything is stored in a single file, like SQLite, but with high performance out-of-the-box.

As BoltDB is simple key-value storage I implemented indexing for posts and found that go-routines perfectly solve this task. Every time author saved a post re-indexing is executed in go-routine. Indexer iterates over all saved posts and builds several maps -- *paths map* for accessing posts by human-readable link, *tags map* to filter posts by tag and, the most important, *pages map* -- cache of posts pages for visitors.

Another thing that was difficult to choose for me is default theme. I did not want to use Twitter Bootstrap as I used it for many another projects and wanted to try something new. I tried one free blog template, tried one paid and finally came to [Zurb Foundation](http://foundation.zurb.com/) that is very similar to Bootstrap, but not Bootstrap =)

Few words on the project name. *Phil Karlton* mentioned: *"There are only two hard things in Computer Science: cache invalidation and naming things."* I solved the first one quite easy -- rebuild cache on every post modification (and server restart). The second one was much harder for me. *Blogo* -- was the first name I gave to this project. I did not like this name a lot, but it was better that nothing. Later I found another project with the same name in Apple App Store (as for me -- expensive and useless app with WP and Evernote integration) and decided that new naming is the highest priority task =) As I currently learn German I wanted something in this language. Blog in German is das Blog that is not so interesting, but block (that sounds like blog, yeah =)) is der Klotz, that is more interesting. Removing couple letters and space turns der Klotz into rKlotz =)

Published it under BSD-3 license on [GitHub](https://github.com/vgarvardt/rklotz). PRs are welcome =)

PS: still have some [open issues](https://github.com/vgarvardt/rklotz/issues) that must be resolved before 0.1 release
