PLIK="/usr/share/dict/words"
mapfile -t DATA < "$PLIK"
echo "${DATA[@]}"