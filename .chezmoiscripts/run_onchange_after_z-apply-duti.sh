#!/bin/sh
# apply-duti.sh hash: {{ include ".config/duti/config" | sha256sum }}
duti ~/.config/duti/config
