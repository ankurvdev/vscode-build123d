/usr/bin/code-server \
    --bind-addr 0.0.0.0:8080 \
    --config /root/.config/code-server/config.yaml \
    --auth none \
    --disable-workspace-trust \
    --disable-getting-started-override \
    --disable-telemetry \
    --disable-update-check \
    /data
exit $?
