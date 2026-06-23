
# Copy bashlib
LIB_TARGET="bin/lib"
if [ ! -d "$LIB_TARGET" ]; then
  task bashlib-cp
fi
