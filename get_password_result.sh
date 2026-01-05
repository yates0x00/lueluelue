awk '/"password_attack":/ {
    getline next_line
    if (next_line !~ /^[[:space:]]*$/ && next_line !~ /^[[:space:]]*}/) {
        print "文件: " FILENAME
        print $0
        print next_line
        getline; print $0
        print "-------------------------"
    }
}' tmp/*.json
