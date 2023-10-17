sleep 60
inspec exec --chef-license=accept-silent --input=HOST=$1 --reporter html:test.html -- $2/profiles/access 
# this needs work for better checking if all checks were valid
if [ $? -eq 0 ] 
then
  echo '{"passed": "true"}'|jq .
else
  echo '{"passed": "false"}'|jq .
fi
exit 0
