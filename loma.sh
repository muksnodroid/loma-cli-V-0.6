#!/bin/bash

# --- COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' 
BOLD='\033[1m'

# --- 0. CONFIGURATION ---
export OLLAMA_MODELS="/media/muks/Aser06/agent/.ollama"
SERVER_DIR="/media/muks/Aser06/agent/.ollama"

# --- 1. OLLAMA & SYSTEM CHECK ---
check_system() {
    if ! command -v ollama &> /dev/null; then
        echo -e "${RED}⚠️  Ollama not found.${NC}"
        read -p "Install it now? (y/n): " inst
        [[ "$inst" =~ ^[Yy]$ ]] && curl -fsSL https://ollama.com/install.sh | sh || exit 1
    fi
    
    # WSL Specific Check (Pre-emptive)
    if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
        export WSL_MODE=true
    fi
}

# --- 2. ANIMATED HEADER FUNCTION ---
animate_header() {
    local text="mUk66 mADE iT"
    local colors=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$PURPLE" "$CYAN")
    
    # Simple flicker animation (runs 15 times)
    for i in {1..15}; do
        local color=${colors[$((RANDOM % 15 ))]}
        echo -ne "\r${color}${BOLD}  >>> $text <<<  ${NC}"
        sleep 0.1
    done
    echo -e "\n"
}

# --- 3. THE WISE MAN QUOTE ---
print_quote() {
    local quote="\"With Great Power, Comes Great Compute...\""
    echo -ne "${YELLOW}${BOLD}💡 Wise Man Said: ${NC}${CYAN}"
    for (( i=0; i<${#quote}; i++ )); do
        echo -ne "${quote:$i:1}"
        sleep 0.03
    done
    echo -e "${NC}\n"
}

# --- EXECUTION START ---
clear
check_system
animate_header

# Display Slogan
echo -e "${CYAN}${BOLD}loma : mintion chat with most powerfull lm with just button${NC}"
echo -e "${PURPLE}${BOLD}====================================================${NC}"

print_quote

# --- SIGNUP VERIFICATION ---
while true; do
    echo -e "\n${YELLOW}⚠️  CLOUD ACCESS CHECK:${NC}"
    read -p "Are you signed up on the Ollama website? (y/n): " signup_resp
    
    if [[ "$signup_resp" == "y" || "$signup_resp" == "Y" ]]; then
        echo -e "${GREEN}✅ Verification confirmed. Accessing cloud models...${NC}"
        break
    elif [[ "$signup_resp" == "n" || "$signup_resp" == "N" ]]; then
        echo -e "\n${RED}❌ You must be signed up to use cloud models!${NC}"
        echo -e "${BLUE}👉 Please visit: ${BOLD}https://ollama.com/signup${NC}"
        echo -e "${YELLOW}Once you have created an account, please run this script again.${NC}"
        echo -e "${PURPLE}----------------------------------------------------${NC}"
        exit 0
    else
        echo -e "${RED}Please enter 'y' for Yes or 'n' for No.${NC}"
    fi
done

echo -e "\n${PURPLE}${BOLD}🚀  OLLAMA CLOUD COMMAND CENTER${NC}"
echo -e "📍 Path: ${CYAN}$OLLAMA_MODELS${NC}"
echo -e "${PURPLE}${BOLD}====================================================${NC}"

# 4. Model Mapping: "Display Name | Actual Tag"
model_data=(
    "🌐 GPT-OSS (120B Cloud) | gpt-oss:120b-cloud"
    "🌟 GLM-5.1 (Cloud) | glm-5.1:cloud"
    "💎 Gemma 4 (31B Cloud) | gemma4:31b-cloud"
    "⚡ Minimax-M2.7 (Cloud) | minimax-m2.7:cloud"
    "🐋 Qwen 3.5 (122B Cloud) | qwen3.5:122b-cloud"
    "💻 Qwen 3 Coder Next (Cloud) | qwen3-coder-next:cloud"
    "🍃 Ministral-3 (14B Cloud) | ministral-3:14b-cloud"
    "🛠️ Devstral Small-2 (24B Cloud) | devstral-small-2:24b-cloud"
    "🚀 Nemotron-3 Super (120B Cloud) | nemotron-3-super:120b-cloud"
    "🌌 Qwen 3 Next (80B Cloud) | qwen3-next:80b-cloud"
    "🛡️ GLM-5 (Cloud) | glm-5:cloud"
    "🤖 Kimi-K2.5 (Agentic Cloud) | kimi-k2.5:cloud"
    "🎯 RNJ-1 (8B Cloud) | rnj-1:8b-cloud"
)

# --- 4. Handle Ollama Serve ---
if pgrep -x "ollama" > /dev/null
then
    echo -e "${GREEN}✅ Ollama server is already active.${NC}"
else
    echo -e "${YELLOW}⚙️  Starting Ollama server in background...${NC}"
    mkdir -p "$SERVER_DIR"
    cd "$SERVER_DIR" || { echo -e "${RED}❌ Error: Directory not found!${NC}"; exit 1; }
    OLLAMA_MODELS=$OLLAMA_MODELS ollama serve > ollama_server.log 2>&1 &
    
    # Wait for server to be ready (up to 15 seconds)
    echo -ne "${YELLOW}⏳ Waiting for server to initialize...${NC}"
    for i in {1..15}; do
        if ollama list &> /dev/null; then
            echo -e "\n${GREEN}✅ Server started successfully.${NC}"
            break
        fi
        echo -ne "${YELLOW}.${NC}"
        sleep 1
        if [ $i -eq 15 ]; then
            echo -e "\n${RED}❌ Error: Ollama server failed to start in time.${NC}"
            echo -e "${YELLOW}Please check ollama_server.log for details.${NC}"
            exit 1
        fi
    done
fi

# 6. Selection Menu
echo -e "\n${BOLD}Please select your AI Model:${NC}"

display_names=()
for item in "${model_data[@]}"; do
    display_names+=("${item%%|*}")
done

PS3=$(echo -e "\n${CYAN}👉 Enter selection number: ${NC}")

select choice in "${display_names[@]}" "❌ Exit"; do
    if [ "$choice" == "❌ Exit" ]; then
        echo -e "${RED}Shutting down launcher... Goodbye!${NC}"
        break
    elif [ -n "$choice" ]; then
        for item in "${model_data[@]}"; do
            if [[ "$item" == "$choice"* ]]; then
                tag="${item#*| }"
                
                echo -e "\n${PURPLE}----------------------------------------------------"
                echo -e "${YELLOW}🚀 LAUNCHING:${NC} ${BOLD}$choice${NC}"
                echo -e "${BLUE}🏷️  TAG:${NC} $tag"
                echo -e "${BLUE}🚫 MODE:${NC} No-Download / Cloud-Only"
                echo -e "${PURPLE}----------------------------------------------------${NC}"
                
                ollama run "$tag"
                
                echo -e "\n${GREEN}✨ Session ended. Returning to menu...${NC}"
                break 
            fi
        done
    else
        echo -e "${RED}⚠️  Invalid selection, please try again.${NC}"
    fi
done
