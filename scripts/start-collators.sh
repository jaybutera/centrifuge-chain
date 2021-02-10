function cleanup() {
    kill $alice_pid
    kill $bob_pid
    echo ""
    echo "Stopped the collators. Goodbye"
    exit
}

# Parachain id of collators
parachain_id=10001
# Paths to chain spec files
#relay_config=../../polkadot/rococo-local-cfde-real-overseer.json
#relay_config=../../polkadot/rococo-local-custom-relay.json
relay_config=../../polkadot/tmp1.json
collator_config=''
# Output files for collator processes
col_1_log=/tmp/collator1.log
col_2_log=/tmp/collator2.log

# Start collator 1
../target/release/centrifuge-chain \
    --collator \
    --tmp \
    --parachain-id $parachain_id \
    --chain "$collator_config" \
    --port 40335 \
    --node-key-file collator1.key \
    --ws-port 9946 \
    -- \
    --execution wasm \
    --chain $relay_config \
    --port 30335 \
    --bootnodes /ip4/127.0.0.1/tcp/30333/p2p/12D3KooWAf7iThMCPgkAncjTfiqPb2Q6nBakwY92shW347ucVbXB \
        &> $col_1_log &

alice_pid=$!
echo "collator 1 is running - output at $col_1_log..."

# Start collator 2
../target/release/centrifuge-chain \
    --collator \
    --tmp \
    --parachain-id $parachain_id \
    --port 40336 \
    --chain "$collator_config" \
    --bootnodes /ip4/127.0.0.1/tcp/40335/p2p/12D3KooWABE1PTn4S1ZRohkpDm4hSjYc5gxefUxn6ySf4z6KF96E \
    --ws-port 9947 \
    -- \
    --execution wasm \
    --chain $relay_config \
    --port 30336 \
    --bootnodes /ip4/127.0.0.1/tcp/30333/p2p/12D3KooWAf7iThMCPgkAncjTfiqPb2Q6nBakwY92shW347ucVbXB \
        &> $col_2_log &

bob_pid=$!
echo "collator 2 is running - output at $col_2_log..."

# Kill processes on ctrl-c
trap cleanup SIGINT

# UI control loop
while true
do
    sleep 100
done
