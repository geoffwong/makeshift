#!/bin/sh
#
# _MK.SH	--Create the fallback ".mk" file for the ARCH directory
#
date=$(date)
arch_list=$(echo *.mk| sed -e s/.mk//g)
cat <<EOF
#
# .MK --Fallback make definitions for ARCH customisation.
#
# Remarks:
# Do not edit this file!
# it was automatically generated on $date
#
\$(info "ARCH" must have one of the following values:)
\$(info $arch_list)
\$(error The variable "ARCH" is not defined. )
EOF
