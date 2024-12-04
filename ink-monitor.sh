#!/bin/bash


LOCAL_RPC="http://localhost:8545"
REMOTE_RPC="https://rpc-gel-sepolia.inkonchain.com"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

move_cursor_home() {
    tput cup 0 0
}

clean_to_end() {
    tput ed
}

get_block_info() {
    local rpc_url=$1
    local block_type=$2
    curl -s -X POST "$rpc_url" \
        -H "Content-Type: application/json" \
        --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBlockByNumber\",\"params\":[\"$block_type\", true],\"id\":1}"
}

get_latest_block_info() {
    local rpc_url=$1
    local block_info=$(get_block_info "$rpc_url" "latest")
    echo "$block_info"
}

get_block_number() {
    local block_info=$1
    local block_num=$(echo "$block_info" | jq -r '.result.number // empty')
    if [ -z "$block_num" ]; then
        return 1
    fi
    echo $((block_num))
}

clear

last_local_block=0
start_time=$(date +%s)
last_update_time=$start_time
last_processed_blocks=0

monitor_sync() {
    while true; do
        current_time=$(date +%s)
        local_block_info=$(get_latest_block_info "$LOCAL_RPC")
        remote_block_info=$(get_latest_block_info "$REMOTE_RPC")
        
        local_block=$(get_block_number "$local_block_info")
        remote_block=$(get_block_number "$remote_block_info")
        
        if [ $? -eq 0 ] && [ ! -z "$local_block" ] && [ ! -z "$remote_block" ]; then
            blocks_behind=$((remote_block - local_block))
            progress=$(awk "BEGIN {printf \"%.2f\", ($local_block/$remote_block)*100}")
            
            blocks_processed=$((local_block - last_local_block))
            time_diff=$((current_time - last_update_time))
            
            if [ $time_diff -gt 0 ]; then
                blocks_per_second=$(awk "BEGIN {printf \"%.2f\", $blocks_processed/$time_diff}")
            else
                blocks_per_second=0
            fi
            
            local_timestamp=$(echo "$local_block_info" | jq -r '.result.timestamp // empty')
            if [ ! -z "$local_timestamp" ]; then
                local_timestamp=$((local_timestamp))
                local_date=$(date -d "@$local_timestamp" "+%Y-%m-%d %H:%M:%S")
            else
                local_date="N/A"
            fi
            
            local_hash=$(echo "$local_block_info" | jq -r '.result.hash // "N/A"')
            local_txs=$(echo "$local_block_info" | jq -r '.result.transactions | length // 0')
            
            move_cursor_home
            clean_to_end
            
            echo -e "${BOLD}${BLUE}Node Sync Monitor${NC}"
            echo -e "${BLUE}===================${NC}"
            
            echo -e "\n${BOLD}Sync Status${NC}"
            echo -e "${CYAN}My Node Block:        ${NC}${local_block}"
            echo -e "${CYAN}Network Latest Block: ${NC}${remote_block}"
            echo -e "${CYAN}Blocks behind:        ${NC}${blocks_behind}"
            echo -e "${CYAN}Sync progress:        ${NC}${progress}%"
            
            echo -e "\n${BOLD}Performance${NC}"
            echo -e "${YELLOW}Blocks processed:     ${NC}+${blocks_processed}"
            echo -e "${YELLOW}Processing speed:     ${NC}${blocks_per_second} blocks/sec"
            
            echo -e "\n${BOLD}My Node Latest Block Details${NC}"
            echo -e "${PURPLE}Block hash:          ${NC}${local_hash}"
            echo -e "${PURPLE}Block timestamp:     ${NC}${local_date}"
            echo -e "${PURPLE}Block transactions:  ${NC}${local_txs}"
            
            # Visual progress bar
            echo -e "\n${BOLD}Progress${NC}"
            progress_int=${progress%.*}
            progress_bar=$((progress_int/2))
            printf "["
            for ((i=0; i<50; i++)); do
                if [ $i -lt $progress_bar ]; then
                    printf "${GREEN}#${NC}"
                else
                    printf "."
                fi
            done
            printf "]\n"
            
            last_local_block=$local_block
            last_update_time=$current_time
        else
            move_cursor_home
            clean_to_end
            echo -e "${RED}Error: Failed to get block numbers${NC}"
        fi
        
        sleep 2
    done
}

# Start monitoring
monitor_sync
