#ignore="$@"
ignore=''
marks=$(i3-msg -t get_marks | jq '.[]' | sort | tr --delete '"')

if [[ -n "$ignore" ]]; then
    for i in $ignore; do
        marks=$(echo "$marks" | sed "s/$i//g")
    done
fi

if [[ -n "$marks" ]]; then
    echo "$marks" | tr '\n' ' '
else
    echo ""
fi