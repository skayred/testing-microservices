require 'sinatra'
require 'benchmark'

set :bind, '0.0.0.0'
set :port, 4000

get '/interface' do
  content_type :json
  {
    params: [
      {
        name: 'repo',
        type: 'string'
      }
    ]
  }.to_json
end

set :lock, true
post '/method' do
  pars = JSON.parse(request.body.read)
  output = ''

  #tmp = `rm -rf tmp && mkdir tmp`

  git_timing = 0#Benchmark.measure { cd tmp && git clone #{pars['repo']} }

  npm_timing = 0#Benchmark.measure { cd tmp && cd * && npm install }
  exe_timing = Benchmark.measure { output = `cd proj && cd * && npm run lint 2>&1` }
  exit_code = $?.success?

  puts exit_code
  puts output

  content_type :json
  {
    status: exit_code ? 'ok' : 'fail',
    message: "#{exit_code ? 'ok' : 'fail'} -> #{JSON.dump({ git: git_timing.real, npm: npm_timing.real, exe: exe_timing.real })}",
    verbose_message: output.encode("iso-8859-1").force_encoding("utf-8")
  }.to_json
end
