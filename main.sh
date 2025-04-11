PLIK="/usr/share/dict/words"
mapfile -t DATA < "$PLIK"
#echo "${DATA[@]}"
if [ "$#" -eq 0 ]; then
    echo "Podaj slowa linijak po linijce. Jak chcesz zakonczyc nacisnij ctrl+D:"
    mapfile -t WORDS
else
    WORDS=("$@")
fi

for i in "${WORDS[@]}"; do
    I_LOWER="${i,,}"
    for j in "${DATA[@]}"; do
        J_LOWER="${j,,}"
        if [ "$I_LOWER" = "$J_LOWER" ]; then
            echo "YES $I_LOWER"
            break
        fi
    done
done

