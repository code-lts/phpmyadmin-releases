# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0] - 2020-04-18

### Removed
- Drop support for IE

### Changed

- Clean and remove trailing whitespaces from JS file

### Notes

- I did not test anything.

## [1.4] - 2020-04-18

### Fixed
- Support for jQuery 1.9
- IE detection

### Added
- Unit test for jQuery 1.7.2
- package.json
- publish to NPM

## [1.3] - 2010-07-21
- Reorganized IE6/7 Iframe code to make it more
  "removable" for mobile-only development. Added IE6/7 document.title
  support. Attempted to make Iframe as hidden as possible by using
  techniques from http://www.paciellogroup.com/blog/?p=604. Added 
  support for the "shortcut" format $(window).hashchange( fn ) and
  $(window).hashchange() like jQuery provides for built-in events.
  Renamed jQuery.hashchangeDelay to <jQuery.fn.hashchange.delay> and
  lowered its default value to 50. Added <jQuery.fn.hashchange.domain>
  and <jQuery.fn.hashchange.src> properties plus document-domain.html
  file to address access denied issues when setting document.domain in
  IE6/7.

## [1.2] - 2010-01-11
- Fixed a bug where coming back to a page using this plugin
  from a page on another domain would cause an error in Safari 4. Also,
  IE6/7 Iframe is now inserted after the body (this actually works),
  which prevents the page from scrolling when the event is first bound.
  Event can also now be bound before DOM ready, but it won't be usable
  before then in IE6/7.

## [1.1] - 2010-01-21
- Incorporated document.documentMode test to fix IE8 bug
  where browser version is incorrectly reported as 8.0, despite
  inclusion of the X-UA-Compatible IE=EmulateIE7 meta tag.

## [1.0] - 2010-01-09
- Initial Release. Broke out the jQuery BBQ event.special
  window.onhashchange functionality into a separate plugin for users
  who want just the basic event & back button support, without all the
  extra awesomeness that BBQ provides. This plugin will be included as
  part of jQuery BBQ, but also be available separately.

[Unreleased]: https://github.com/cowboy/jquery-hashchange/compare/v1.3...HEAD
[v1.3]: https://github.com/cowboy/jquery-hashchange/compare/v1.2...v1.3
[v1.2]: https://github.com/cowboy/jquery-hashchange/compare/v1.1...v1.2
[v1.1]: https://github.com/cowboy/jquery-hashchange/compare/v1.0...v1.1
[v1.0]: https://github.com/cowboy/jquery-hashchange/releases/tag/v1.0
