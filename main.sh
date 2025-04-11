PLIK="/usr/share/dict/words"
mapfile -t DATA < "$PLIK"
#echo "${DATA[@]}"
if [ "$#" -eq 0 ]; then
    echo "Podaj slowa linijak po linijce. Jak chcesz zakonczyc nacisnij ctrl+D:"
    mapfile -t WORDS
else
    WORDS=("$@")
fi

