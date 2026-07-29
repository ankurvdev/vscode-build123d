 /app/vscodium-web/bin/codium-server \
    --host 0.0.0.0 \
    --port 8080 \
    --accept-server-license-terms \
    --without-connection-token \
    /data
exit $?
