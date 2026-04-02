---
layout: default
title: Lecture notes (by chapter)
permalink: /lecture_notes/
---

# Lecture notes (by chapter)

Top-level folders under `lecture_notes/` whose names begin with `chapter`, and every file under each (including nested folders), except anything under a `prebaked/` directory: those folders are linked as a whole instead of listing each file.

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

{% assign gkey_order = 'notebooks|||py|||powerpoint|||other' | split: '|||' %}

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

{% if has_prebaked %}
## {{ heading }} ({% assign pb_first = true %}{% for root in prebaked_roots %}{% unless root == blank %}{% assign plink = '/' | append: root | append: '/' %}{% unless pb_first %}, {% endunless %}<a href="{{ plink | relative_url }}">{% if pb_first %}prebaked{% else %}{{ root | remove_first: chap_prefix | append: '/' }}{% endif %}</a>{% assign pb_first = false %}{% endunless %}{% endfor %})
{% else %}
## {{ heading }}
{% endif %}

{% assign gkey_raw = '' %}
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
    {% assign gk = 'notebooks' %}
  {% elsif fext == 'py' %}
    {% assign gk = 'py' %}
  {% elsif fext == 'pptx' or fext == 'ppt' %}
    {% assign gk = 'powerpoint' %}
  {% else %}
    {% assign gk = 'other' %}
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
{% assign group_list = sorted_gkeys | split: '|||' %}

{% for gk in group_list %}
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
{% if gk == 'notebooks' %}
{% assign gtitle = 'Notebooks' %}
{% elsif gk == 'py' %}
{% assign gtitle = 'Python' %}
{% elsif gk == 'powerpoint' %}
{% assign gtitle = 'PowerPoint' %}
{% else %}
{% assign gtitle = 'Other' %}
{% endif %}
### {{ gtitle }}

<ul>
{% assign cl_buf = '' %}
{% assign cl_key = '' %}
{% assign sec_prefix = 'lecture_notes/' | append: folder | append: '/' %}
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
  {% assign display = rel | remove_first: sec_prefix %}
  {% assign spp = bn | split: '_sol.' %}
  {% assign sppsz = spp | size %}
  {% assign skip_li = false %}
  {% if sppsz == 2 %}
    {% assign base_bn = spp[0] | append: '.' | append: spp[1] %}
    {% assign base_rel = rel | replace: bn, base_bn %}
    {% assign base_start_bn = spp[0] | append: '_start.' | append: spp[1] %}
    {% assign base_start_rel = rel | replace: bn, base_start_bn %}
    {% if sorted_visible contains base_rel %}
      {% assign skip_li = true %}
    {% endif %}
    {% if sorted_visible contains base_start_rel %}
      {% assign skip_li = true %}
    {% endif %}
  {% endif %}
  {% unless skip_li %}
    {% if sppsz == 2 %}
      {% if cl_buf != '' %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
{% assign cl_buf = '' %}
{% assign cl_key = '' %}
      {% endif %}
<li><a href="{{ '/' | append: rel | relative_url }}">{{ display }}</a></li>
    {% else %}
  {% assign stsp = bn | split: '_start.' %}
  {% assign stpsz = stsp | size %}
  {% if stpsz == 2 %}
  {% assign sol_bn_from_start = stsp[0] | append: '_sol.' | append: stsp[1] %}
  {% assign sol_rel_from_start = rel | replace: bn, sol_bn_from_start %}
  {% if sorted_visible contains sol_rel_from_start %}
      {% if cl_buf != '' %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
{% assign cl_buf = '' %}
{% assign cl_key = '' %}
      {% endif %}
<li><a href="{{ '/' | append: rel | relative_url }}">{{ display }}</a> (<a href="{{ '/' | append: sol_rel_from_start | relative_url }}">solution</a>)</li>
  {% else %}
      {% if cl_buf != '' %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
{% assign cl_buf = '' %}
{% assign cl_key = '' %}
      {% endif %}
<li><a href="{{ '/' | append: rel | relative_url }}">{{ display }}</a></li>
  {% endif %}
  {% else %}
  {% assign dp = bn | split: '.' %}
  {% assign fextn = dp | last %}
  {% assign stem = '' %}
  {% for p in dp %}
    {% if forloop.last %}
    {% else %}
      {% if stem == '' %}
        {% assign stem = p %}
      {% else %}
        {% assign stem = stem | append: '.' | append: p %}
      {% endif %}
    {% endif %}
  {% endfor %}
  {% if stem contains '_by_' %}
    {% assign byparts = stem | split: '_by_' %}
    {% assign pfx = byparts | first %}
  {% else %}
    {% assign pfx = stem %}
    {% for _n in (1..40) %}
      {% assign psz = pfx | size %}
      {% if psz < 1 %}
        {% break %}
      {% endif %}
      {% assign lix = psz | minus: 1 %}
      {% assign lc = pfx | slice: lix, 1 %}
      {% if lc == '0' or lc == '1' or lc == '2' or lc == '3' or lc == '4' or lc == '5' or lc == '6' or lc == '7' or lc == '8' or lc == '9' %}
        {% assign pfx = pfx | slice: 0, lix %}
      {% else %}
        {% break %}
      {% endif %}
    {% endfor %}
  {% endif %}
  {% assign this_ck = bn %}
  {% assign pfxsz = pfx | size %}
  {% if pfxsz >= 3 %}
    {% assign this_ck = pfx | append: '|' | append: fextn %}
  {% endif %}
  {% assign sol_bn = stem | append: '_sol.' | append: fextn %}
  {% assign sol_rel = rel | replace: bn, sol_bn %}
  {% assign start_bn = stem | append: '_start.' | append: fextn %}
  {% assign start_rel = rel | replace: bn, start_bn %}
  {% if sorted_visible contains sol_rel %}
    {% if sorted_visible contains start_rel %}
      {% if cl_buf != '' and cl_key != this_ck %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
{% assign cl_buf = '' %}
{% assign cl_key = '' %}
      {% endif %}
      {% if cl_buf == '' %}
        {% assign cl_key = this_ck %}
        {% assign cl_buf = rel | append: '@@@' %}
      {% elsif cl_key == this_ck %}
        {% assign cl_buf = cl_buf | append: rel | append: '@@@' %}
      {% else %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
        {% assign cl_key = this_ck %}
        {% assign cl_buf = rel | append: '@@@' %}
      {% endif %}
    {% else %}
      {% if cl_buf != '' %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
{% assign cl_buf = '' %}
{% assign cl_key = '' %}
      {% endif %}
<li><a href="{{ '/' | append: rel | relative_url }}">{{ display }}</a> (<a href="{{ '/' | append: sol_rel | relative_url }}">solution</a>)</li>
    {% endif %}
  {% else %}
    {% if cl_buf != '' and cl_key != this_ck %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
{% assign cl_buf = '' %}
{% assign cl_key = '' %}
    {% endif %}
    {% if cl_buf == '' %}
      {% assign cl_key = this_ck %}
      {% assign cl_buf = rel | append: '@@@' %}
    {% elsif cl_key == this_ck %}
      {% assign cl_buf = cl_buf | append: rel | append: '@@@' %}
    {% else %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
      {% assign cl_key = this_ck %}
      {% assign cl_buf = rel | append: '@@@' %}
    {% endif %}
  {% endif %}
  {% endif %}
    {% endif %}
  {% endunless %}
  {% endif %}
{% endunless %}
{% endfor %}
{% if cl_buf != '' %}
<li>{% assign fc = true %}{% assign bp = cl_buf | split: '@@@' %}{% for cr in bp %}{% unless cr == blank %}{% unless fc %}, {% endunless %}<a href="{{ '/' | append: cr | relative_url }}">{{ cr | remove_first: sec_prefix }}</a>{% assign fc = false %}{% endunless %}{% endfor %}</li>
{% endif %}
</ul>

{% endif %}
{% endunless %}
{% endfor %}

{% endunless %}
{% endfor %}
