require 'sinatra'

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

post '/method' do
  pars = JSON.parse(request.body.read)

  tmp = `rm -rf tmp && mkdir tmp`
  output = `cd tmp && git clone #{pars['repo']} && cd * && npm install && npm run lint 2>&1`
  exit_code = $?.success?

  content_type :json
  {
    status: exit_code ? 'ok' : 'fail',
    message: exit_code ? 'ok' : 'fail',
    verbose_message: output
  }.to_json
end
