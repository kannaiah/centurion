#!/usr/bin/env bash

# Set maildirs
maildirs="$HOME/Mail/*/INBOX/new/"

find $maildirs -type f | wc -l

