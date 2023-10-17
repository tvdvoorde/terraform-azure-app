sleep 60
inspec exec --chef-license=accept-silent --input=HOST=$1 --reporter html:test.html -- $2/profiles/access 
if [ $? -eq 0 ] 
then
  echo '{"passed": "true"}'|jq .
  exit 0
else
  echo '{"passed": "false"}'|jq .
  exit 1
fi
