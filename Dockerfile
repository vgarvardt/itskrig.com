FROM vgarvardt/rklotz:0.8.2

ENV SSL_ENABLED "true"
ENV SSL_HOST "itskrig.com"
ENV SSL_EMAIL "vgarvardt@gmail.com"

ENV STORAGE_DSN "memory://"

ENV UI_DESCRIPTION "itsKrig - blog of Vladimir Garvardt on Programming, Life, the Universe and Everything"
ENV UI_TITLE "itsKrig"
ENV UI_HEADING "Blog of Vladimir Garvardt"
ENV UI_INTRO "on Programming, Life, the Universe and Everything"

ENV PLUGINS_ENABLED "disqus,highlightjs,yasha,ga,gtm"
ENV PLUGINS_DISQUS "shortname:itskrig-com"
ENV PLUGINS_GA "tracking_id:UA-11342895-3"
ENV PLUGINS_GTM "id:GTM-M66FSRH"
ENV PLUGINS_YASHA "services:facebook twitter gplus"

# replace demo posts with the real
RUN rm -rf /etc/rklotz/posts/*
ADD posts/ /etc/rklotz/posts

# add photo for about panel
RUN mkdir -p /etc/rklotz/static/misc
ADD static/portrait.jpg /etc/rklotz/static/misc

# add custom about panel file
ADD about.html /etc/rklotz
