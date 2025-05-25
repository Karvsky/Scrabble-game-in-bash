declare -A points=(
    [a]=1
    [b]=3
    [c]=3
    [d]=2
    [e]=1
    [f]=4
    [g]=2
    [h]=4
    [i]=1
    [j]=8
    [k]=5
    [l]=1
    [n]=1
    [m]=3
    [o]=1
    [p]=3
    [r]=1
    [s]=1
    [t]=1
    [u]=1
    [q]=10
    [w]=4
    [y]=4
    [x]=8
    [z]=10
)
clear

show_help() {
    echo "---Scrabble game---"
    echo ""
    echo "Usage: $0 [OPTIONS] [WORDS...]"
    echo ""
    echo "Opcje:"
    echo "  -h, --help          Wyświetl tę pomoc"
    echo "  -d, --dict PATH     Użyj własnego słownika z podanej ścieżki"
    echo "  --no-points         Niepoprawne słowa nie otrzymują wartości punktowej"
    echo "  --hide-invalid      Nie wyświetlaj niepoprawnych słów"
    echo ""
    echo "Jeśli nie podano słów jako parametry, program będzie czytał ze standardowego wejścia."
    echo "Zakończ wprowadzanie słów naciskając Ctrl+D."
    exit 0
}

NO_POINTS=false
HIDE_INVALID=false
CUSTOM_DICT=""
WORD_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -d|--dict)
            CUSTOM_DICT="$2"
            shift 2
            ;;
        --no-points)
            NO_POINTS=true
            shift
            ;;
        --hide-invalid)
            HIDE_INVALID=true
            shift
            ;;
        *)
            WORD_ARGS+=("$1")
            shift
            ;;
    esac
done

PLIK="/usr/share/dict/words"

if [ -n "$CUSTOM_DICT" ]; then
    if [ -f "$CUSTOM_DICT" ]; then
        PLIK="$CUSTOM_DICT"
    else
        echo "Błąd: Plik słownika '$CUSTOM_DICT' nie istnieje."
        exit 1
    fi
    mapfile -t DATA < "$PLIK"
elif [ "${#WORD_ARGS[@]}" -eq 0 ]; then
    mapfile -t DATA < "$PLIK"
    variable="nothing"
    echo "---Scrabble game---"
    echo ""
    echo "Jeśli chcesz użyć własnej biblioteki wpisz TAK, natomiast jeśli chcesz użyć wbudowanej biblioteki wpisz NIE: "
    read VARIABLE
    VARIABLE="$(echo "$VARIABLE" | tr '[:upper:]' '[:lower:]')"
    while [[ "$VARIABLE" != "tak" && "$VARIABLE" != "nie" ]]; do
        echo "Podałeś złą możliwą odpowiedź. Napisz jeszcze raz: "
        read VARIABLE
        VARIABLE="$(echo "$VARIABLE" | tr '[:upper:]' '[:lower:]')"
    done
    if [ "$VARIABLE" = "tak" ]; then
        while true; do
            echo "Podaj ścieżkę do twojego słownika: "
            read PLIK
            if [ -f "$PLIK" ]; then
                mapfile -t DATA < "$PLIK"
                break
            else
                echo "Plik nie istnieje. Spróbuj ponownie."
            fi
        done
    fi
else
    mapfile -t DATA < "$PLIK"
fi

clear
echo "---Scrabble game---"
echo ""
if [ "${#WORD_ARGS[@]}" -eq 0 ]; then
    echo "Podaj slowa linijka po linijce. Jak chcesz zakonczyc nacisnij ctrl+D:"
    mapfile -t WORDS
else
    WORDS=("${WORD_ARGS[@]}")
fi
clear
echo "---Scrabble game---"
echo ""
printf "%-21s %-15s %s\n" "SŁOWO" "STATUS" "PUNKTY"
printf "%-20s %-15s %s\n" "-----" "------" "------"

for i in "${WORDS[@]}"; do
    INDICTIONARY="NONE"
    I_LOWER="${i,,}"
    SUMA=0
    for (( a=0; a<${#I_LOWER}; a++ )); do
        z="${I_LOWER:a:1}"
        if [[ -n "${points[$z]}" ]]; then
            SUMA=$(( SUMA + ${points[$z]} ))
        fi
    done
    for j in "${DATA[@]}"; do
        J_LOWER="${j,,}"
        if [ "$I_LOWER" = "$J_LOWER" ]; then
            INDICTIONARY="YES"
            break
        fi
    done
    if [ "$INDICTIONARY" = "NONE" ]; then
        INDICTIONARY="NO"
    fi
    
    if [ "$INDICTIONARY" = "NO" ]; then
        if [ "$HIDE_INVALID" = true ]; then
            continue
        fi
        if [ "$NO_POINTS" = true ]; then
            SUMA=""
        fi
    fi
    
    STATUS="POPRAWNE"
    if [ "$INDICTIONARY" = "NO" ]; then
        STATUS="NIEPOPRAWNE"
    fi
    
    printf "%-20s %-15s %s\n" "$I_LOWER" "$STATUS" "$SUMA"
done
