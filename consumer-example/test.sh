inspec exec --chef-license=accept-silent --input=HOST=x$* --reporter html:test.html -- ../tests/inspec/profiles/access 
if [ $? -eq 0 ] 
then
  echo '{"passed": "true"}'|jq .
  exit 0
else
  echo '{"passed": "false"}'|jq .
  exit 1
fi

