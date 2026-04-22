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
WHITE='\033[1;37m'

# --- 0. CONFIGURATION ---
export OLLAMA_MODELS="/media/muks/Aser06/agent/.ollama"
SERVER_DIR="$OLLAMA_MODELS"
DEFAULT_GREETING_MODEL="rnj-1:8b-cloud"
LOG_FILE="$SERVER_DIR/ollama_server.log"

# Enable debug mode? (set DEBUG=1 before running)
if [[ "$DEBUG" == "1" ]]; then
    set -x
    echo -e "${YELLOW}[DEBUG] Debug mode enabled${NC}"
fi

# --- 1. PRE-FLIGHT SAFETY CHECKS ---
if [[ "$OLLAMA_MODELS" == *" "* ]] || [[ -L "$OLLAMA_MODELS" ]]; then
    echo -e "${RED}❌ Error: Path '$OLLAMA_MODELS' is unsafe (contains spaces or is a symlink)."
    echo "Please use a real directory path (e.g., /home/user/.ollama).${NC}"
    exit 1
fi

# Ensure directory exists
if [[ ! -d "$OLLAMA_MODELS" ]]; then
    echo -e "${YELLOW}⚠️  Model directory does not exist.${NC}"
    read -p "Create '$OLLAMA_MODELS' now? (y/n): " create_dir
    [[ "$create_dir" =~ ^[Yy]$ ]] && mkdir -p "$OLLAMA_MODELS" || { echo -e "${RED}Aborted.${NC}"; exit 1; }
fi

# Warn if on external media
if [[ "$OLLAMA_MODELS" == /media/* ]]; then
    echo -e "${YELLOW}⚠️  Warning: Models stored on external media ($OLLAMA_MODELS)."
    echo "Performance may be reduced; models may fail if drive unmounts.${NC}"
    sleep 3
fi

# --- 2. OLLAMA & SYSTEM CHECK ---
check_system() {
    if ! command -v ollama &> /dev/null; then
        echo -e "${RED}⚠️  Ollama not found.${NC}"
        read -p "Install it now? (y/n): " inst
        [[ "$inst" =~ ^[Yy]$ ]] && curl -fsSL https://ollama.com/install.sh | sh || exit 1
    fi
    
    # Print version
    echo -e "${BLUE}✅ Ollama version: $(ollama --version | head -1)${NC}"
    
    if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
        export WSL_MODE=true
        echo -e "${PURPLE}ℹ️  WSL environment detected${NC}"
    fi
}

# --- 3. CLEANUP ON EXIT ---
cleanup() {
    echo -e "\n${YELLOW}⏳ Stopping Ollama server...${NC}"
    pkill -x ollama 2>/dev/null || true
    echo -e "${GREEN}✅ Cleanup complete. Safe to unmount.${NC}"
}
trap cleanup EXIT

# --- 4. DEDICATION FUNCTION ---
print_dedication() {
    clear
    echo -e "\n\n"
    echo -e "${WHITE}${BOLD}----------------------------------------------------${NC}"
    echo -e "${CYAN}${BOLD}  اهداء الي والدي رحمه الله${NC}"
    echo -e "${CYAN}${BOLD}  Dedicated to my father, may ALLAH forgive him ${NC}"
    echo -e "${WHITE}${BOLD}----------------------------------------------------${NC}"
    echo -e "\n\n"
    sleep 6
    clear
}

# --- 5. ASCII HEADER (robust to terminal width <80) ---
print_header() {
    local width=$(tput cols 2>/dev/null || echo 80)
    if (( width < 70 )); then width=70; fi  # fallback minimum

    local line1="  _      ____  __  __          "
    local line2=" | |    / __ \|  \/  |   /\    "
    local line3=" | |   | |  | | \  / |  /  \   "
    local line4=" | |   | |  | | |\/| | / /\ \  "
    local line5=" | |___| |__| | |  | |/ ____ \ "
    local line6=" |______\____/|_|  |_/_/    \_\ "
 __    __     __  __     __  __        __    __     ______     _____     ______        __     ______  
/\ "-./  \   /\ \/\ \   /\ \/ /       /\ "-./  \   /\  __ \   /\  __-.  /\  ___\      /\ \   /\__  _\ 
\ \ \-./\ \  \ \ \_\ \  \ \  _"-.     \ \ \-./\ \  \ \  __ \  \ \ \/\ \ \ \  __\      \ \ \  \/_/\ \/ 
 \ \_\ \ \_\  \ \_____\  \ \_\ \_\     \ \_\ \ \_\  \ \_\ \_\  \ \____-  \ \_____\     \ \_\    \ \_\ 
  \/_/  \/_/   \/_____/   \/_/\/_/      \/_/  \/_/   \/_/\/_/   \/____/   \/_____/      \/_/     \/_/ 
                                                                                                      
    echo -e "${CYAN}"
    printf "%*s\n" $(((${#line1} + width) / 2)) "$line1"
    printf "%*s\n" $(((${#line2} + width) / 2)) "$line2"
    printf "%*s\n" $(((${#line3} + width) / 2)) "$line3"
    printf "%*s\n" $(((${#line4} + width) / 2)) "$line4"
    printf "%*s\n" $(((${#line5} + width) / 2)) "$line5"
    printf "%*s\n" $(((${#line6} + width) / 2)) "$line6"
    echo -e "${NC}"

    local title1="LOMA-CLI"
    local title2="mUk🗽 mADE iT"
    local sig="© 2026 eCh👁️ mUk66™ proj$ *Magic and Beauty* "
    local famous_line="Made in Giza with F "

    printf "%*s\n" $(((${#title1} + width) / 2)) "$title1"
    
    local colors=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$PURPLE" "$CYAN")
    for i in {1..10}; do
        local color=${colors[$((RANDOM % 6 ))]}
        printf "\r$(printf "%*s" $(((${#title2} + width) / 2)) "")"
        printf "\r${color}${BOLD}%*s${NC}" $(((${#title2} + width) / 2)) "$title2"
        sleep 0.1
    done
    echo -e "\n"
    
    printf "%*s\n" $(((${#famous_line} + width) / 2)) "$famous_line"
    printf "%*s\n" $(((${#sig} + width) / 2)) "$sig"
    echo -e "${PURPLE}${BOLD}====================================================${NC}\n"
}

# --- 6. WISE MAN QUOTE ---
print_quote() {
    echo -e "\n"
    echo -e "${WHITE}  __________________________________________________________"
    echo -e " /                                                                  \\"
    echo -e " |  ${YELLOW}${BOLD}💡 Wise Man Said:${NC}${CYAN} \"With Great Power, Comes Great Compute...\"${WHITE}  |"
    echo -e " \\__________________________________________________________/"
    echo -e "\n"
}

# --- 7. AI AUTO-GREETING (robust, fallback, cache) ---
generate_ai_welcome() {
    local user_name=$(whoami)
    echo -ne "${BLUE}🤖 AI is preparing a welcome message...${NC}\r"
    sleep 0.8  # give user time to read
    
    local GREETING_CACHE="$OLLAMA_MODELS/.last_greeting"
    local CACHE_EXPIRY=$(( 60 * 60 * 24 ))  # 1 day
    local now=$(date +%s)
    local cache_mtime=0

    if [[ -f "$GREETING_CACHE" ]]; then
        cache_mtime=$(stat -c %Y "$GREETING_CACHE" 2>/dev/null || echo 0)
    fi

    if [[ $((now - cache_mtime)) -lt $CACHE_EXPIRY ]]; then
        local cached_msg=$(cat "$GREETING_CACHE" 2>/dev/null)
        if [[ -n "$cached_msg" ]]; then
            echo -ne "\r"
            echo -e "${PURPLE}${BOLD}✨ AI MESSAGE (cached):${NC}"
            echo -e "${WHITE}💬 \"$cached_msg\"${NC}"
            return
        fi
    fi

    # Attempt real AI greeting
    local prompt="Write a very short, one-sentence warm and professional welcome greeting for $user_name. No quotes."
    local welcome_msg=$(ollama run "$DEFAULT_GREETING_MODEL" "$prompt" 2>/dev/null | head -1)

    if [[ -z "$welcome_msg" ]] || [[ "$welcome_msg" =~ ^[[:space:]]*$ ]]; then
        welcome_msg="Welcome back, $user_name! Ready to code, create, and conquer."
        echo -e "\r"  # clear loader
        echo -e "${YELLOW}⚠️  AI greeting unavailable (network/model issue). Using fallback.${NC}"
    else
        echo -ne "\r"  # clear loader
        echo "$welcome_msg" > "$GREETING_CACHE"
    fi

    echo -e "${PURPLE}${BOLD}✨ AI MESSAGE:${NC}"
    echo -e "${WHITE}💬 \"$welcome_msg\"${NC}"
    echo -e "${PURPLE}----------------------------------------------------${NC}\n"
}

# --- 8. SERVER STARTUP (with readiness check & logs) ---
start_ollama_server() {
    if pgrep -x "ollama" > /dev/null; then
        echo -e "${GREEN}✅ Ollama server is already running.${NC}"
        return
    fi

    echo -e "${YELLOW}⚙️  Starting Ollama server...${NC}"
    mkdir -p "$SERVER_DIR"
    
    # Start server *with correct environment*
    (export OLLAMA_MODELS="$OLLAMA_MODELS"; cd "$SERVER_DIR"; ollama serve > "$LOG_FILE" 2>&1) &
    server_pid=$!

    echo -e "${BLUE}⏳ Waiting for Ollama server (max 10 sec)...${NC}"
    for i in {1..20}; do
        if curl -s http://localhost:11434 > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Ollama server is ready.${NC}"
            return
        fi
        sleep 0.5
    done

    # Fallback: show last lines of log if still not ready
    echo -e "${RED}❌ Server failed to start.${NC}"
    echo -e "${RED}Logs (last 5 lines):${NC}"
    tail -n 5 "$LOG_FILE" 2>/dev/null | while read -r line; do
        echo -e "   ${RED}   ❌ $line${NC}"
    done
    exit 1
}

# --- 9. MODEL SELECTION (DYNAMIC & SAFE) ---
select_model() {
    echo -e "${BLUE}🔍 Scanning available models...${NC}"
    sleep 0.5

    # Get local + remote models (only names, no extra fields)
    local raw_models=()
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        raw_models+=("$line")
    done < <(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')

    # Fallback: suggest popular models if empty
    if [[ ${#raw_models[@]} -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  No models found. Suggested: ${BOLD}ollama pull rnj-1:8b-cloud${NC}"
        echo -e "${CYAN}Press any key to pull it now (or Ctrl+C to quit)...${NC}"
        read -sn1
        ollama pull "$DEFAULT_GREETING_MODEL" 2>/dev/null || echo -e "${RED}Pull failed.${NC}"
    fi

    # Ensure array non-empty
    if [[ ${#raw_models[@]} -eq 0 ]]; then
        raw_models=("$DEFAULT_GREETING_MODEL")
    fi

    # Build arrays for menu
    local display_names=()
    local tags=()

    for model in "${raw_models[@]}"; do
        display_names+=("$model")
        tags+=("$model")
    done

    # Add exit option
    display_names+=("❌ Exit")
    tags+=("")

    PS3=$(echo -e "\n${CYAN}👉 Select model: ${NC}")
    
    select choice in "${display_names[@]}"; do
        if [[ "$choice" == "❌ Exit" ]]; then
            echo -e "${RED}Shutting down launcher... Goodbye!${NC}"
            return 1
        elif [[ -n "$choice" ]]; then
            local idx=$(printf '%s\n' "${!display_names[@]}" | while read i; do
                [[ "${display_names[$i]}" == "$choice" ]] && echo "$i" && break
            done)

            local tag="${tags[$idx]}"
            echo -e "\n${PURPLE}----------------------------------------------------"
            echo -e "${YELLOW}🚀 LAUNCHING:${NC} ${BOLD}$choice${NC}"
            echo -e "${BLUE}🏷️  TAG:${NC} $tag"
            echo -e "${PURPLE}----------------------------------------------------${NC}"
            
            # Allow user to add args (e.g., --temp 0.7)
            read -rp "Extra args (e.g., --temp 0.8, or leave empty): " extra
            ollama run $extra "$tag"
            
            echo -e "\n${GREEN}✨ Session ended. Returning to menu...${NC}"
            break
        else
            echo -e "${RED}⚠️  Invalid selection. Try again.${NC}"
        fi
    done
}

# --- 10. MAIN EXECUTION ---
print_dedication
print_header
check_system
start_ollama_server

# Slogan & Quote
echo -e "${CYAN}${BOLD}Loma: Chat with the most powerful LLMs with just one button${NC}"
echo -e "${PURPLE}${BOLD}====================================================${NC}"
print_quote

# AI greeting
generate_ai_welcome

# Paths & status
echo -e "${PURPLE}${BOLD}🚀  OLLAMA CLOUD COMMAND CENTER${NC}"
echo -e "📍 Models path: ${CYAN}$OLLAMA_MODELS${NC}"
echo -e "📄 Server log: ${CYAN}$LOG_FILE${NC}"
echo -e "${PURPLE}${BOLD}====================================================${NC}"

# Launch selection menu
if ! select_model; then
    trap - EXIT  # skip cleanup if user exited manually
    exit 0
fi
