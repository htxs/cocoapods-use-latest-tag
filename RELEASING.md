A checklist for releasing the Gem:

* Test: `rake`
* Bump version in lib/cocoapod_use_latest_tag.rb
* Commit
* `git tag x.y.z`
* `git push`
* `git push --tags`
* `gem build cocoapods-use-latest-tag.gemspec`
* `gem push cocoapods-use-latest-tag-x.y.z.gem`
* Create release on GitHub from tag
