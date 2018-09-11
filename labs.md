---
layout: page
title: Labs
permalink: /labs/
---

On this page, you will see our labs.
These are meant to be short weekly assignments that reenforce the knowledge we've learned in class.
Each one will be assigned shortly before the recitations on Friday and will be due, unless a scheduling conflict occurs, the following Sunday.
Any deviations to that will be announced with the corresponding lab.

{% for lab in site.labs %}

{% if lab.solution %}

**Solution**: [{{ lab.title }} Solution]({{site.baseurl}}{{ lab.url }})

{% else %}
# [{{ lab.title }}: {{ lab.subtitle}}]({{ site.baseurl}}{{ lab.url }})

**Released**: {{ lab.released }}

**Due**: {{ lab.due }}

{{ lab.summary }}
{% endif %}

{% endfor %}
