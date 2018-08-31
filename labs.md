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
# [{{ lab.title }}]({{ site.baseurl}}{{ lab.permalink }})

**Released**: {{ lab.released }}

**Due**: {{ lab.due }}

{{ lab.summary }}

{% endfor %}
