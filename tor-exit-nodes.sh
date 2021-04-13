#!/usr/bin/env bash

################################################################################
#
# This script retrieves the current list of exit nodes from the TOR website,
# and writes their IP addresses to a PHP array.
#
# For more info:
#   https://www.ohreally.nl/2020/08/01/external-ip-address
#   https://ip.ohreally.nl/
#
################################################################################
#
# Copyright (c) 2020 Rob LA LAU < https://www.ohreally.nl/ >
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
################################################################################

# The directory where the file should be saved.
# The complete path to the file will be
#     ${dir}/tor-exit-nodes.php
dir="/srv/www/ip.example.com/htdocs"

################################################################################
# Do not change anything below this line.

# Applications we need.
WGET=`which wget`   || exit 1
GREP=`which grep`   || exit 1
AWK=`which awk`     || exit 1
MV=`which mv`       || exit 1
CHMOD=`which chmod` || exit 1

# Filenames.
tmp="${dir}/tor-exit-nodes.tmp"
php="${tmp/tmp/php}"

# Create the array and write it to a file.
echo '<?php' > "${tmp}"
echo '$exitnodes = array(' >> "${tmp}"
"${WGET}" -q -O - https://check.torproject.org/exit-addresses | "${GREP}" '^ExitAddress ' | "${AWK}" "{printf \"'%s',\", \$2}" >> "${tmp}"
echo ');' >> "${tmp}"
echo '?>' >> "${tmp}"

# Replace the previous file with the new file.
"${CHMOD}" 644 "${tmp}"
"${MV}" "${tmp}" "${php}"
