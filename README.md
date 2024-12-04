# Ink Node Sync Monitor

A bash script to monitor the synchronization progress of your Ink Network node with real-time updates and detailed block information.

## Overview

This tool helps you monitor your Ink node synchronization progress with a user-friendly interface. It compares your local node's block height with the network's current height and provides detailed information about the synchronization process.

## Features

- Real-time sync progress monitoring
- Visual progress bar showing synchronization completion
- Detailed Ink node statistics:
  - Local vs Network block height comparison
  - Blocks behind calculation
  - Processing speed (blocks/second)
- Latest synced block details:
  - Block hash
  - Block timestamp
  - Number of transactions
- Color-coded output for better readability
- Smooth display updates (no flickering)

## Prerequisites

The script requires the following:
- A running Ink node
- `bash` (version 4 or later)
- `curl`
- `jq`
- `awk`
- `tput`

## Installation

1. Clone the repository:
```bash
git clone [your-repository-url]
cd ink-node-monitor
```

2. Make the script executable:
```bash
chmod +x ink-monitor.sh
```

## Configuration

The script is pre-configured for Ink Network, but you can edit these variables if needed:

```bash
LOCAL_RPC="http://localhost:8545"  # Your Ink node's RPC endpoint
REMOTE_RPC="https://rpc-gel-sepolia.inkonchain.com"  # Ink Network RPC endpoint
```

## Usage

Run the script:

```bash
./ink-monitor.sh
```

The display updates every 2 seconds showing:
- Synchronization progress percentage
- Number of blocks behind network
- Block processing speed
- Details of the latest synchronized block

## Sample Output

```
Node Sync Monitor
===================

Sync Status
My Node Block:        4056513
Network Latest Block: 4338507
Blocks behind:        281994
Sync progress:        93.45%

Performance
Blocks processed:     +59
Processing speed:     29.5 blocks/sec

My Node Latest Block Details
Block hash:          0x02cab7ff7a13ab6a4d0c04af803985fbce41dbc648e30550e85441a9895e2f5d
Block timestamp:     2024-12-01 15:23:47
Block transactions:  1

Progress
[##############################################....]
```

## Relationship with Ink Node

This monitoring tool is designed specifically for Ink Network nodes. It helps node operators monitor their node's synchronization progress with the Ink blockchain. For more information about running an Ink node, please refer to the [official Ink documentation](https://docs.inkonchain.com).

## Contributing

Feel free to submit issues and enhancement requests! Pull requests are welcome.

## License

MT

## Author
@KrimDevNode
https://krimdevnode.ovh
