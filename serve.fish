#!/usr/bin/env fish
# Preview the site at http://127.0.0.1:4000 — run from this directory after `bundle install`.
cd (dirname (status -f))
if command -q rbenv
    rbenv init - fish | source
end
exec bundle exec jekyll serve $argv
