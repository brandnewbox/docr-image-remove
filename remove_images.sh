DIGESTS=$(doctl registry repository lm $1 --format Digest,UpdatedAt,Tags | tail -n +2 | sort -rk2 | grep -v -E "$4" | awk '{print $1}' | tail -n +$(($2+1)))
for DIGEST in $DIGESTS; do
  doctl registry repository delete-manifest $1 $DIGEST --force
done
echo Manifest Digests removed: $DIGESTS

# Start garbage collection if perform_gc is true
if [ "$3" = true ]; then
    doctl registry garbage-collection start --include-untagged-manifests --force
else
    echo "Garbage collection is skipped."
fi
