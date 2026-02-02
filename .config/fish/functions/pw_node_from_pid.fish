function pw_node_from_pid
    pw-dump | jq -r "
        .[] | select(.type==\"PipeWire:Interface:Node\") |
        select(.info.props[\"application.process.id\"]==\"$argv[1]\") |
        .info.id
    "
end
