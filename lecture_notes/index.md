---
layout: default
title: Lecture notes (by chapter)
permalink: /lecture_notes/
---

# Lecture notes (by chapter)

<style>
.lecture-notes-row { display: flex; flex-wrap: wrap; gap: 1rem 1.5rem; align-items: flex-start; margin: 0.75rem 0 1rem; }
.lecture-notes-col { flex: 1 1 12rem; min-width: 0; }
.lecture-notes-col .lecture-notes-group-heading { margin-top: 0; font-size: 1.1em; }
.lecture-notes-other { margin-top: 0.5rem; clear: both; }
.lecture-notes-other .lecture-notes-group-heading { font-size: 1.1em; }
@media (max-width: 42rem) {
  .lecture-notes-row { flex-direction: column; }
}
</style>

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

{% for folder in chapter_dirs_ordered %}
{% unless folder == blank %}
{% if folder == 'chapter_algorithms' %}
{% assign heading = 'Algorithms' %}
{% else %}
{% assign chapnum = folder | remove_first: 'chapter' %}
{% assign heading = 'Chapter ' | append: chapnum %}
{% endif %}

{% assign file_lines = '' %}
{% for file in site.static_files %}
  {% assign rel = file.path | remove_first: '/' %}
  {% assign fparts = rel | split: '/' %}
  {% if fparts[0] == 'lecture_notes' and fparts[1] == folder %}
    {% assign file_lines = file_lines | append: rel | append: '@@@' %}
  {% endif %}
{% endfor %}
{% assign sorted_files = file_lines | split: '@@@' | uniq | sort %}
{% assign chap_prefix = 'lecture_notes/' | append: folder | append: '/' %}

{% assign visible_lines = '' %}
{% for rel in sorted_files %}
{% unless rel == blank %}
  {% unless rel contains '/prebaked/' %}
    {% assign visible_lines = visible_lines | append: rel | append: '@@@' %}
  {% endunless %}
{% endunless %}
{% endfor %}
{% assign sorted_visible = visible_lines | split: '@@@' | uniq | sort %}

{% assign prebaked_roots_raw = '' %}
{% assign has_prebaked = false %}
{% for rel in sorted_files %}
{% unless rel == blank %}
  {% if rel contains '/prebaked/' %}
    {% assign rp = rel | split: '/prebaked/' %}
    {% assign rpn = rp | size %}
    {% if rpn > 1 %}
      {% assign root = rp[0] | append: '/prebaked' %}
      {% assign has_prebaked = true %}
      {% assign prebaked_roots_raw = prebaked_roots_raw | append: root | append: '@@@' %}
    {% endif %}
  {% endif %}
{% endunless %}
{% endfor %}
{% assign prebaked_roots = prebaked_roots_raw | split: '@@@' | uniq | sort %}

## {{ heading }}

{% assign main_gkeys = 'notebooks|||py|||powerpoint' | split: '|||' %}
{% assign row_opened = false %}
{% for gk in main_gkeys %}
{% unless gk == blank %}
{% assign nmatch = 0 %}
{% for rel in sorted_visible %}
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
    {% assign fgk = 'notebooks' %}
  {% elsif fext == 'py' %}
    {% assign fgk = 'py' %}
  {% elsif fext == 'pptx' or fext == 'ppt' %}
    {% assign fgk = 'powerpoint' %}
  {% else %}
    {% assign fgk = 'other' %}
  {% endif %}
  {% if fgk == gk %}
    {% assign nmatch = nmatch | plus: 1 %}
  {% endif %}
{% endunless %}
{% endfor %}
{% if nmatch > 0 %}
  {% unless row_opened %}
<div class="lecture-notes-row">
  {% assign row_opened = true %}
  {% endunless %}
  <div class="lecture-notes-col">
  {% include lecture_notes_group.html %}
  </div>
{% endif %}
{% endunless %}
{% endfor %}
{% if row_opened %}
</div>
{% endif %}

{% assign gk = 'other' %}
{% assign nmatch = 0 %}
{% for rel in sorted_visible %}
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
    {% assign fgk = 'notebooks' %}
  {% elsif fext == 'py' %}
    {% assign fgk = 'py' %}
  {% elsif fext == 'pptx' or fext == 'ppt' %}
    {% assign fgk = 'powerpoint' %}
  {% else %}
    {% assign fgk = 'other' %}
  {% endif %}
  {% if fgk == gk %}
    {% assign nmatch = nmatch | plus: 1 %}
  {% endif %}
{% endunless %}
{% endfor %}
{% if nmatch > 0 or has_prebaked %}
<div class="lecture-notes-other">
{% include lecture_notes_group.html %}
</div>
{% endif %}

{% endunless %}
{% endfor %}
