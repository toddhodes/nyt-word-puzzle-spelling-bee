#
# solve NYT "spelling bee" puzzles
#
# cat /usr/share/dict/words  |egrep -iv "[bcdehjklmopqrstvxyz]" |egrep [Aa] |sort

case "$1" in
"") echo "Usage: $0 <letters>"
    echo "          (required letter first)"
    exit 1 ;;
esac

cat <<EOF > /tmp/wpsolver.kts

import java.io.BufferedReader
import java.io.InputStreamReader

val letters = "$1"
val required = letters[0] + letters[0].toString().toUpperCase()
var o = ""
for (i in "abcdefghijklmnopqrstuvwxyz") {
   if (i !in letters) o += i
}
val command = "cat /usr/share/dict/words | egrep -iv '[" +
    o + "]' | egrep [" + required + "] | awk 'length(\$0) > 3' | sort"
System.out.println(command)

val cmd = arrayOf( "/bin/sh", "-c", command)
val process = Runtime.getRuntime().exec(cmd)
val reader = BufferedReader(InputStreamReader(process.inputStream))
val line = reader.readText();
print(line)
EOF

kotlinc -script /tmp/wpsolver.kts 2>/dev/null

