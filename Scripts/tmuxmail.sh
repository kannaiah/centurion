#!/bin/bash

# Set maildirs
maildirs="$HOME/Mail/*/INBOX/new/"

find $maildirs -type f | wc -l
                
exit 0
