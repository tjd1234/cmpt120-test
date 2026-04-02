---
layout: default
title: Lecture notes (by chapter)
permalink: /lecture_notes/
---

# Lecture notes (by chapter)

Top-level folders under `lecture_notes/` whose names begin with `chapter`, and every file under each (including nested folders).

{% assign raw_folders = '' %}
{% for file in site.static_files %}
  {% assign rel = file.path | remove_first: '/' %}
  {% assign parts = rel | split: '/' %}
  {% assign psz = parts | size %}
  {% if parts[0] == 'lecture_notes' and psz >= 2 %}
    {% assign seg = parts[1] %}
    {% assign head = seg | slice: 0, 7 %}
    {% assign seglen = seg | size %}
    {% if head == 'chapter' and seglen > 7 %}
      {% assign raw_folders = raw_folders | append: seg | append: '@@@' %}
    {% endif %}
  {% endif %}
{% endfor %}
{% assign chapter_dirs = raw_folders | split: '@@@' | uniq %}
{% assign ordered_raw = '' %}
{% for n in (1..30) %}
  {% assign cand = 'chapter' | append: n %}
  {% if chapter_dirs contains cand %}
    {% assign ordered_raw = ordered_raw | append: cand | append: '@@@' %}
  {% endif %}
{% endfor %}
{% if chapter_dirs contains 'chapter_algorithms' %}
  {% assign ordered_raw = ordered_raw | append: 'chapter_algorithms' | append: '@@@' %}
{% endif %}
{% assign chapter_dirs_ordered = ordered_raw | split: '@@@' %}

{% assign gkey_order = 'ipynb|||py|||powerpoint|||pdf|||markdown|||text|||zip|||csv|||json|||images|||html|||word|||excel|||video|||none' | split: '|||' %}
{% assign gkey_order_str = '|ipynb|py|powerpoint|pdf|markdown|text|zip|csv|json|images|html|word|excel|video|none|' %}

{% for folder in chapter_dirs_ordered %}
{% unless folder == blank %}
{% if folder == 'chapter_algorithms' %}
{% assign heading = 'Algorithms' %}
{% else %}
{% assign chapnum = folder | remove_first: 'chapter' %}
{% assign heading = 'Chapter ' | append: chapnum %}
{% endif %}
## {{ heading }}

{% assign file_lines = '' %}
{% for file in site.static_files %}
  {% assign rel = file.path | remove_first: '/' %}
  {% assign fparts = rel | split: '/' %}
  {% if fparts[0] == 'lecture_notes' and fparts[1] == folder %}
    {% assign file_lines = file_lines | append: rel | append: '@@@' %}
  {% endif %}
{% endfor %}
{% assign sorted_files = file_lines | split: '@@@' | uniq | sort %}

{% assign gkey_raw = '' %}
{% for rel in sorted_files %}
{% unless rel == blank %}
  {% assign bn = rel | split: '/' | last %}
  {% assign ep = bn | split: '.' %}
  {% assign epn = ep | size %}
  {% if epn > 1 %}
    {% assign fext = ep | last | downcase %}
  {% else %}
    {% assign fext = '_none_' %}
  {% endif %}
  {% if fext == 'ipynb' %}
    {% assign gk = 'ipynb' %}
  {% elsif fext == 'py' %}
    {% assign gk = 'py' %}
  {% elsif fext == 'pptx' or fext == 'ppt' %}
    {% assign gk = 'powerpoint' %}
  {% elsif fext == 'pdf' %}
    {% assign gk = 'pdf' %}
  {% elsif fext == 'md' %}
    {% assign gk = 'markdown' %}
  {% elsif fext == 'txt' %}
    {% assign gk = 'text' %}
  {% elsif fext == 'zip' %}
    {% assign gk = 'zip' %}
  {% elsif fext == 'csv' %}
    {% assign gk = 'csv' %}
  {% elsif fext == 'json' %}
    {% assign gk = 'json' %}
  {% elsif fext == 'png' or fext == 'jpg' or fext == 'jpeg' or fext == 'gif' or fext == 'svg' or fext == 'webp' %}
    {% assign gk = 'images' %}
  {% elsif fext == 'html' or fext == 'htm' %}
    {% assign gk = 'html' %}
  {% elsif fext == 'docx' %}
    {% assign gk = 'word' %}
  {% elsif fext == 'xlsx' %}
    {% assign gk = 'excel' %}
  {% elsif fext == 'mp4' or fext == 'webm' %}
    {% assign gk = 'video' %}
  {% elsif fext == '_none_' %}
    {% assign gk = 'none' %}
  {% else %}
    {% assign gk = fext %}
  {% endif %}
  {% assign gkey_raw = gkey_raw | append: gk | append: '|||' %}
{% endunless %}
{% endfor %}
{% assign gkey_uniq = gkey_raw | split: '|||' | uniq %}

{% assign sorted_gkeys = '' %}
{% for gk in gkey_order %}
  {% if gkey_uniq contains gk %}
    {% assign sorted_gkeys = sorted_gkeys | append: gk | append: '|||' %}
  {% endif %}
{% endfor %}
{% assign gkey_rest = gkey_uniq | sort %}
{% for gk in gkey_rest %}
{% unless gk == blank %}
  {% assign gtag = '|' | append: gk | append: '|' %}
  {% unless gkey_order_str contains gtag %}
    {% assign sorted_gkeys = sorted_gkeys | append: gk | append: '|||' %}
  {% endunless %}
{% endunless %}
{% endfor %}
{% assign group_list = sorted_gkeys | split: '|||' %}

{% for gk in group_list %}
{% unless gk == blank %}
{% assign nmatch = 0 %}
{% for rel in sorted_files %}
{% unless rel == blank %}
  {% assign bn = rel | split: '/' | last %}
  {% assign ep = bn | split: '.' %}
  {% assign epn = ep | size %}
  {% if epn > 1 %}
    {% assign fext = ep | last | downcase %}
  {% else %}
    {% assign fext = '_none_' %}
  {% endif %}
  {% if fext == 'ipynb' %}
    {% assign fgk = 'ipynb' %}
  {% elsif fext == 'py' %}
    {% assign fgk = 'py' %}
  {% elsif fext == 'pptx' or fext == 'ppt' %}
    {% assign fgk = 'powerpoint' %}
  {% elsif fext == 'pdf' %}
    {% assign fgk = 'pdf' %}
  {% elsif fext == 'md' %}
    {% assign fgk = 'markdown' %}
  {% elsif fext == 'txt' %}
    {% assign fgk = 'text' %}
  {% elsif fext == 'zip' %}
    {% assign fgk = 'zip' %}
  {% elsif fext == 'csv' %}
    {% assign fgk = 'csv' %}
  {% elsif fext == 'json' %}
    {% assign fgk = 'json' %}
  {% elsif fext == 'png' or fext == 'jpg' or fext == 'jpeg' or fext == 'gif' or fext == 'svg' or fext == 'webp' %}
    {% assign fgk = 'images' %}
  {% elsif fext == 'html' or fext == 'htm' %}
    {% assign fgk = 'html' %}
  {% elsif fext == 'docx' %}
    {% assign fgk = 'word' %}
  {% elsif fext == 'xlsx' %}
    {% assign fgk = 'excel' %}
  {% elsif fext == 'mp4' or fext == 'webm' %}
    {% assign fgk = 'video' %}
  {% elsif fext == '_none_' %}
    {% assign fgk = 'none' %}
  {% else %}
    {% assign fgk = fext %}
  {% endif %}
  {% if fgk == gk %}
    {% assign nmatch = nmatch | plus: 1 %}
  {% endif %}
{% endunless %}
{% endfor %}
{% if nmatch > 0 %}
{% if gk == 'ipynb' %}
{% assign gtitle = 'Jupyter notebooks' %}
{% elsif gk == 'py' %}
{% assign gtitle = 'Python' %}
{% elsif gk == 'powerpoint' %}
{% assign gtitle = 'PowerPoint' %}
{% elsif gk == 'pdf' %}
{% assign gtitle = 'PDF' %}
{% elsif gk == 'markdown' %}
{% assign gtitle = 'Markdown' %}
{% elsif gk == 'text' %}
{% assign gtitle = 'Text' %}
{% elsif gk == 'zip' %}
{% assign gtitle = 'Zip archives' %}
{% elsif gk == 'csv' %}
{% assign gtitle = 'CSV' %}
{% elsif gk == 'json' %}
{% assign gtitle = 'JSON' %}
{% elsif gk == 'images' %}
{% assign gtitle = 'Images' %}
{% elsif gk == 'html' %}
{% assign gtitle = 'HTML' %}
{% elsif gk == 'word' %}
{% assign gtitle = 'Word' %}
{% elsif gk == 'excel' %}
{% assign gtitle = 'Excel' %}
{% elsif gk == 'video' %}
{% assign gtitle = 'Video' %}
{% elsif gk == 'none' %}
{% assign gtitle = 'Other files' %}
{% else %}
{% assign gtitle = gk | upcase | append: ' files' %}
{% endif %}
### {{ gtitle }}

<ul>
{% for rel in sorted_files %}
{% unless rel == blank %}
  {% assign bn = rel | split: '/' | last %}
  {% assign ep = bn | split: '.' %}
  {% assign epn = ep | size %}
  {% if epn > 1 %}
    {% assign fext = ep | last | downcase %}
  {% else %}
    {% assign fext = '_none_' %}
  {% endif %}
  {% if fext == 'ipynb' %}
    {% assign fgk = 'ipynb' %}
  {% elsif fext == 'py' %}
    {% assign fgk = 'py' %}
  {% elsif fext == 'pptx' or fext == 'ppt' %}
    {% assign fgk = 'powerpoint' %}
  {% elsif fext == 'pdf' %}
    {% assign fgk = 'pdf' %}
  {% elsif fext == 'md' %}
    {% assign fgk = 'markdown' %}
  {% elsif fext == 'txt' %}
    {% assign fgk = 'text' %}
  {% elsif fext == 'zip' %}
    {% assign fgk = 'zip' %}
  {% elsif fext == 'csv' %}
    {% assign fgk = 'csv' %}
  {% elsif fext == 'json' %}
    {% assign fgk = 'json' %}
  {% elsif fext == 'png' or fext == 'jpg' or fext == 'jpeg' or fext == 'gif' or fext == 'svg' or fext == 'webp' %}
    {% assign fgk = 'images' %}
  {% elsif fext == 'html' or fext == 'htm' %}
    {% assign fgk = 'html' %}
  {% elsif fext == 'docx' %}
    {% assign fgk = 'word' %}
  {% elsif fext == 'xlsx' %}
    {% assign fgk = 'excel' %}
  {% elsif fext == 'mp4' or fext == 'webm' %}
    {% assign fgk = 'video' %}
  {% elsif fext == '_none_' %}
    {% assign fgk = 'none' %}
  {% else %}
    {% assign fgk = fext %}
  {% endif %}
  {% if fgk == gk %}
  {% assign prefix = 'lecture_notes/' | append: folder | append: '/' %}
  {% assign display = rel | remove_first: prefix %}
  <li><a href="{{ '/' | append: rel | relative_url }}">{{ display }}</a></li>
  {% endif %}
{% endunless %}
{% endfor %}
</ul>

{% endif %}
{% endunless %}
{% endfor %}

{% endunless %}
{% endfor %}
