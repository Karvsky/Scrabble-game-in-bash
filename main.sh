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
PLIK="/usr/share/dict/words"
mapfile -t DATA < "$PLIK"
#echo "${DATA[@]}"
variable="nothing"
echo "Jeśli chcesz użyć własnej biblioteki wpisz TAK, natomiast jeśli chcesz użyć wbudowanej biblioteki wpisz NIE: "
read VARIABLE
while [[ "$(echo "$VARIABLE" | tr '[:upper:]' '[:lower:]')" != "tak" && "$(echo "$VARIABLE" | tr '[:upper:]' '[:lower:]')" != "nie" ]]; do
    echo "Podałeś złą możliwą odpowiedź. Napisz jeszcze raz: "
    read VARIABLE
done
VARIABLE="$(echo "$VARIABLE" | tr '[:upper:]' '[:lower:]')"
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


if [ "$#" -eq 0 ]; then
    echo "Podaj slowa linijka po linijce. Jak chcesz zakonczyc nacisnij ctrl+D:"
    mapfile -t WORDS
else
    WORDS=("$@")
fi

for i in "${WORDS[@]}"; do
    INDICTIONARY="NONE"
    I_LOWER="${i,,}"
    SUMA=0
    for (( a=0; a<${#I_LOWER}; a++ )); do
        z="${I_LOWER:a:1}"
        SUMA=$(( SUMA + ${points[$z]} ))
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
    echo "$INDICTIONARY $I_LOWER $SUMA"
done
