P_USER="root" 
P_PASS="rootroot" 
P_URL="http://10.11.9.200:9000" 
P_PRUNE="false"

if [ -z ${1+x} ]; then
  echo "Parameter #1 missing: stack name "
  exit 1
fi
TARGET="$1"

if [ -z ${2+x} ]; then
  echo "Parameter #2 missing: path to yml"
  exit
fi
TARGET_YML="$2"

echo "Updating $TARGET"

echo "Loging in..."
P_TOKEN=$(curl -s -X POST -H "Content-Type: application/json;charset=UTF-8" -d "{\"username\":\"$P_USER\",\"password\":\"$P_PASS\"}" "$P_URL/api/auth")
if [[ $P_TOKEN = *"jwt"* ]]; then
  echo " ... success"
else
  echo "Result: failed to login"
  exit 1
fi
T=$(echo $P_TOKEN | awk -F '"' '{print $4}')
echo "Token: $T"

INFO=$(curl -s -H "Authorization: Bearer $T" "$P_URL/api/endpoints/1/docker/info")
CID=$(echo "$INFO" | awk -F '"Cluster":{"ID":"' '{print $2}' | awk -F '"' '{print $1}')
echo "Cluster ID: $CID"

echo "Getting stacks..."
STACKS=$(curl -s -H "Authorization: Bearer $T" "$P_URL/api/endpoints/1/stacks")

#echo "/---" && echo $STACKS && echo "\\---"

found=0

for stack in $(echo "$STACKS" | jq -c '.[]')
do
  sid=$(echo $stack | jq ".Id")
  sid="${sid%\"}"
  sid="${sid#\"}"
  name=$(echo $stack | jq ".Name")
  name="${name%\"}"
  name="${name#\"}"

  # name is "name" with quotes
  if [ "${name,,}" == "${TARGET,,}" ]; then
    found=1
    echo "Identified stack: $sid / $name"

    dcompose=$(cat "$TARGET_YML")
    dcompose="${dcompose//$'\r'/''}"
    dcompose="${dcompose//$'"'/'\"'}"
    dcompose="${dcompose//$"'"/"\'"}"
    echo "/-----READ_YML--------"
    echo "$dcompose"
    echo "\---------------------"
    dcompose="${dcompose//$'\n'/'\n'}"
    data_prefix="{\"Id\":\"$sid\",\"StackFileContent\":\""
    data_suffix="\",\"Env\":[],\"Prune\":$P_PRUNE}"
    sep="'"
    echo "/~~~~CONVERTED_JSON~~~~~~"
    echo "$data_prefix$dcompose$data_suffix"
    echo "\~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "$data_prefix$dcompose$data_suffix" > json.tmp
    cat json.tmp | jq .

    echo "Updating stack..."
    UPDATE=$(curl -s \
		"$P_URL/api/endpoints/1/stacks/$sid" \
		-X PUT \
		-H "Authorization: Bearer $T" \
		-H "Content-Type: application/json;charset=UTF-8" \
                -H 'Cache-Control: no-cache'  \
                --data-binary "@json.tmp"
            )
    echo "Got response: $UPDATE"
    if [ -z ${UPDATE+x} ]; then
      echo "Result: failure  to update"
      exit 1
    else
      echo "Result: successfully updated"
      exit 0
    fi
  fi
done

if [ "$found" == "1" ]; then
  echo "Result: found stack but failed to process"
  exit 1
else 
  echo "Result: fail"
  exit 1
fi
