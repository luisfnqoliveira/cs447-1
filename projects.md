---
layout: page
title: Projects
permalink: /projects/
---

On this page, you will see our course projects.

{% for project in site.projects %}

{% if project.solution %}

**Solution**: [{{ project.title }} Solution]({{site.baseurl }}{{ project.url }})

{% else %}
# [{{ project.title }}: {{ project.subtitle }}]({{ site.baseurl }}{{ project.url }})

**Released**: {{ project.released }}

**Due**: {{ project.due }}

{{ project.summary }}
{% endif %}

{% endfor %}
