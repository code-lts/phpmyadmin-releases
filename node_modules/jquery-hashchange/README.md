# jQuery hashchange event #
[http://benalman.com/projects/jquery-hashchange-plugin/](http://benalman.com/projects/jquery-hashchange-plugin/)

Version: 1.4, Last updated: 4/18/2020

This jQuery plugin enables very basic bookmarkable #hash history via a cross-browser window.onhashchange event.

Visit the [project page](http://benalman.com/projects/jquery-hashchange-plugin/) for more information and usage examples!


## Documentation ##
[http://benalman.com/code/projects/jquery-hashchange/docs/](http://benalman.com/code/projects/jquery-hashchange/docs/)


## Examples ##
These working examples, complete with fully commented code, illustrate a few
ways in which this plugin can be used.

[http://benalman.com/code/projects/jquery-hashchange/examples/hashchange/](http://benalman.com/code/projects/jquery-hashchange/examples/hashchange/)  
[http://benalman.com/code/projects/jquery-hashchange/examples/document_domain/](http://benalman.com/code/projects/jquery-hashchange/examples/document_domain/)

## Support and Testing ##
Information about what version or versions of jQuery this plugin has been
tested with, what browsers it has been tested in, and where the unit tests
reside (so you can test it yourself).

### jQuery Versions ###
1.2.6, 1.3.2, 1.4.1, 1.4.2

### Browsers Tested ###
Internet Explorer 6-8, Firefox 2-4, Chrome 5-6, Safari 3.2-5, Opera 9.6-10.60, iPhone 3.1, Android 1.6-2.2, BlackBerry 4.6-5.

### Unit Tests ###
[http://benalman.com/code/projects/jquery-hashchange/unit/](http://benalman.com/code/projects/jquery-hashchange/unit/)


## A more robust solution ##

This plugin is, by design, very basic. If you want to add lot of extra utility around getting and setting the hash as a state, and parsing and merging fragment params, check out the [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) plugin. It includes this plugin at its core, plus a whole lot more, and has thorough documentation and examples as well. You can't have too much of a good thing!


## Known issues ##

While this jQuery hashchange event implementation is quite stable and robust, there are a few unfortunate browser bugs surrounding expected hashchange event-based behaviors, independent of any JavaScript window.onhashchange abstraction. See the following examples for more information:

Chrome: Back Button  
[http://benalman.com/code/projects/jquery-hashchange/examples/bug-chrome-back-button/](http://benalman.com/code/projects/jquery-hashchange/examples/bug-chrome-back-button/)

Firefox: Remote XMLHttpRequest  
[http://benalman.com/code/projects/jquery-hashchange/examples/bug-firefox-remote-xhr/](http://benalman.com/code/projects/jquery-hashchange/examples/bug-firefox-remote-xhr/)

WebKit: Back Button in an Iframe  
[http://benalman.com/code/projects/jquery-hashchange/examples/bug-webkit-hash-iframe/](http://benalman.com/code/projects/jquery-hashchange/examples/bug-webkit-hash-iframe/)

Safari: Back Button from a different domain  
[http://benalman.com/code/projects/jquery-hashchange/examples/bug-safari-back-from-diff-domain/](http://benalman.com/code/projects/jquery-hashchange/examples/bug-safari-back-from-diff-domain/)

Also note that should a browser natively support the window.onhashchange 
event, but not report that it does, the fallback polling loop will be used.


## Release History ##

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

## License ##
Copyright (c) 2010 "Cowboy" Ben Alman  
Dual licensed under the MIT and GPL licenses.  
[http://benalman.com/about/license/](http://benalman.com/about/license/)
