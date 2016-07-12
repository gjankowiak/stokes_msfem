#!/bin/bash

archive_name=$(date +data_%Y%m%d).zip
zip --symlinks -r $archive_name CR2*_data CR3*_data REF*_data
scp $archive_name aur:
