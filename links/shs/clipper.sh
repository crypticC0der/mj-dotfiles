#!/bin/bash
curl "$QUTE_URL" | xclip -selection clipboard -t image/png -i
