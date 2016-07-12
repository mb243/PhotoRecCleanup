#!/bin/bash
#
# PhotoRec Cleanup Script for Linux - Written by Mike Beach http://mikebeach.org
# Last update: 2013-06-03
#
# This script is designed to clean up the mix of files stored in recup_dir directories
# created after a PhotoRec recovery of a large number of files. This script traverses the
# directories and sorts the files into new locations based on the file's extension,
# creating the new directories where needed. CAUTION: This script doesn't do nearly as
# much error checking as it should, so naturally, use at your own risk.
#
# This script should be run from the parent of any recup_dir.* directories
#
# Behavior:
# By default, this is set to 'cp' (copy) for safety.
# Change to 'mv' (move) if you want that behavior.
# Valid values are ONLY 'cp' or 'mv'.
# Anything else will generate a fatal error and a non-zero exit code.
BEHAVIOR='mv'
#
# Only edit anything below this line if you know what you are doing. If you do feel the need
# to edit something, please drop me a line to explain why so that I can improve the script.
# http://mikebeach.org/2011/08/21/cleaning-up-after-photorec/
#
echo
echo "PhotoRec Cleanup Script for Linux - Written by Mike Beach http://mikebeach.org"
echo
B=$BEHAVIOR
if [[ $B != 'cp' && $B != 'mv' ]]; then
echo "[E] Invalid behavior set. This can cause undesirable/unpredictable behavior.";
echo "[E] Please edit the script, check the behavior setting, and re-run.";
exit 1;
fi
P=$PWD
# Check for any recup_dir directory
GO=0
for z in recup_dir.*; do
GO=1;
done
if [[ $GO == 1 ]];
then echo "[I] $P/recup_dir.* exists, proceeding as planned.";
else echo "[E] $P/recup_dir.* not found.";
echo "Are you in the right directory? Stopping.";
exit 1;
fi
for x in recup_dir.*; do
echo "[I] Entering $x...";
cd $x;
for y in *; do
# E is the extension of the file we're working on.
# Convert all extensions to lowercase
E=`echo $y | awk -F. '{print $2}' | tr '[:upper:]' '[:lower:]'`;
# fix for recovered files without extensions
if [[ "$E" == "" ]]; then E="no_ext"; fi
# C is the counter number; the 'number' of the directory that we're on
C=`echo $x | awk -F. '{print $2}'`;
# D is the destination pathspec. $P/$E/$E.$C -&gt; (jpg) $PWD/jpg/jpg.1
D="$P/$E/$E.$C";
if [[ ! -d $D ]];
then
mkdir -p $D;
if [[ ! -d $D ]]; then
echo "[E] Creating directory $D failed. Aborting.";
exit 255;
fi
fi
$B -f "$y" "$D"; echo -n "."
done
cd ..;
if [[ $B == 'mv' ]]; then
echo "[I] Attempting to remove now-empty directory $x."
rmdir $x;
fi
done
echo "[I] Complete."
