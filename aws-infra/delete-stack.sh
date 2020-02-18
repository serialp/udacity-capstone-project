# Auhor: Cheick GUITI
# delete-stack.sh
# run me with `bash delete-stack.sh`
#!/bin/bash

aws cloudformation delete-stack \
  --stack-name $1