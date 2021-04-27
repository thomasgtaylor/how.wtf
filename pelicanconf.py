#!/usr/bin/env python
# -*- coding: utf-8 -*- #

##################
# General Config #
##################

AUTHOR = "Thomas Taylor"
SITENAME = "how.wtf"
SITEURL = "https://how.wtf"
PATH = "how.wtf/content"
ARTICLE_PATHS = ["blog"]
TIMEZONE = "America/New_York"
DEFAULT_LANG = "en"
PAGE_URL = "{slug}.html"
PAGE_SAVE_AS = "{slug}.html"
DELETE_OUTPUT_DIRECTORY = True
RELATIVE_URLS = True

# Feed
FEED_ALL_ATOM = None
FEED_ALL_RSS = None
CATEGORY_FEED_ATOM = None

################
# Theme Config #
################

THEME = "how.wtf/themes/brutalist"
FAVICON = "icon.png"
LOGO = "icon.png"
SITEIMAGE = "cover.png"
SITEDESCRIPTION = "A blog focused on providing how-to articles & updates about various development languages and cloud technologies."
GOOGLE_ANALYTICS = "G-0W6GZ3EH9R"
ATTRIBUTION = False
GITHUB = "https://github.com/t-h-o/how.wtf"
RSS = "/feeds/all.rss.xml"
UTTERANCES = {"repo": "t-h-o/how.wtf", "label": "💬 Comments"}

#################
# Plugin Config #
#################

SITEMAP = {
    "format": "xml",
    "priorities": {"articles": 0.99, "pages": 0.75, "indexes": 0.5},
    "changefreqs": {"articles": "daily", "pages": "daily", "indexes": "daily"},
}
