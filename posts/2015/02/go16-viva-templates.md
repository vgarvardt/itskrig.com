Go 1.6 - finally, templates ready for use
27 Feb 15 13:45 +0200
go, golang, rklotz, open source

+++

As I mentioned in [rKlotz](http://itskrig.com/krlotz-yet-another-blog-engine-in-golang) introduction post I choose [Pongo2](https://github.com/flosch/pongo2) as template engine for the first public version. Actually I tried [html/template](https://golang.org/pkg/html/template/) but found it too _basic_ -- it remind me my first steps in web-development with PHP and bunch of template files-blocks that were included in each page. But, as of Go 1.6 everything changed! Now Go templates do support  `{{ block "name" pipeline }} ... {{ end }}` that makes life much more easier.

Couple weeks ago, when 1.6 was not yet released, I decided that I need to move from Pongo2 to native go templates. It took couple evenings to understand how it should work and rewrite almost all templates. I found that moving from base template with blocks to list of templates with a bunch of includes makes my inner perfectionist cry, but I wanted to finish this. As a result, I rewrote all templates but one -- `@/form.html`. The problem with form is that it injects some code into header and footer of the page and I could not find solution that seemed elegant enough for me to use includes and avoid hard-coding. So I stopped and gave myself some time to think about it.

Fortunately Go 1.6 was released and I found uber-cool feature in its change log. It took me an evening to move back to base layout template with blocks of content and header/footer injections, my inner perfectionist was happy and I removed one vendor dependency from the project. Actually I added another dependency, [Golang Template Functions](https://github.com/leekchan/gtf), as Pongo2 has a lot of useful template functions that default go templates do not have.

Another change that I did is static files vendoring. I do not work a lot with front-end, so all of my job projects are bundled with pre-downloaded static libraries. It is quite old-school, but works well for back-office projects with simple Bootstrap-based UI and couple jQuery UI components. So, for rKlotz I choose [bower](http://bower.io/) as package manager and now GitHub gives me more relevant stats on languages usage for my project:

* Go 57.4%
* HTML 41.3%
* Makefile 1.3%

Instead of:

* JavaScript 51.3%
* CSS 36.2%
* Go 7.0%
* HTML 4.9%
* Other 0.6%

Next step is dockerization =)
