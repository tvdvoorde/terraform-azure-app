describe http('https://'+input('HOST'), ssl_verify: true) do
     its('status') { should cmp 200 }
  end

describe host(input('HOST'), port: 443, protocol: 'tcp') do
     it { should be_reachable }
     it { should be_resolvable }
  end

describe command('dig '+input('HOST')) do
     its('stdout') { should_not match 'IN A 10.' }
  end