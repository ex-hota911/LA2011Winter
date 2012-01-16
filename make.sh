#! /bin/sh

platex -halt-on-error fulltext && dvipdfmx fulltext
