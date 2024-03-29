{{ define "partial/about.tpl" }}
<div class="callout primary">
    <div class="grid-x">
        <div class="cell small-12 medium-2 text-center">
            <img src="/static/misc/portrait.jpg?{{ .instance_id }}" alt="Vladimir Garvardt"
                 style="max-height: 150px; width: auto; border-radius: 50%;">
        </div>
        <div class="cell small-12 medium-8">
            <h3 class="text-center">Hello, I am Vladimir Garvardt</h3>
            <p>Feel free to email me to provide some feedback on the project, give suggestions, or to just say
                hello!</p>
        </div>
        <div class="cell small-12 medium-2">
            <ul class="no-bullet">
                <li>
                    <a href="https://mas.to/@vgarvardt" class="btn btn-default btn-lg btn-block" target="_blank">
                        <i class="fa-brands fa-mastodon"></i> <span class="network-name">Mastodon</span>
                    </a>
                </li>
                <li>
                    <a href="https://twitter.com/vgarvardt" class="btn btn-default btn-lg btn-block" target="_blank">
                        <i class="fa-brands fa-twitter"></i> <span class="network-name">Twitter</span>
                    </a>
                </li>
                <li>
                    <a href="https://github.com/vgarvardt" class="btn btn-default btn-lg btn-block" target="_blank">
                        <i class="fa-brands fa-github"></i> <span class="network-name">Github</span>
                    </a>
                </li>
                <li>
                    <a href="https://linkedin.com/in/vgarvardt/" class="btn btn-default btn-lg btn-block"
                       target="_blank">
                        <i class="fa-brands fa-linkedin"></i> <span class="network-name">LinkedIn</span>
                    </a>
                </li>
                <li>
                    <a href="mailto:vgarvardt@pm.me" class="btn btn-default btn-lg btn-block" target="_blank">
                        <i class="fa-regular fa-at"></i> <span class="network-name">vgarvardt@pm.me</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>
{{ end }}
