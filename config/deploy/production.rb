# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
set :ssh_options, {
  user: 'ubuntu', # overrides user setting above
  forward_agent: true,
  auth_methods: %w(publickey),
  keys: %w(~/workspace/deployment/WebServer.pem)
}
#
# The server-based syntax can be used to override options:
# ------------------------------------

set :deploy_selection, ask("\n1) Deploy To Test Server\n2) Deploy To Backend ERP\n3) Deploy To Frontend Application\n", nil)

def deploy_to_test_server
  set :branch, :master
  server 'test.caodoo.com',
    user: 'ubuntu',
    roles: %w{web app db batch},
    ssh_options: {}
end

def deploy_to_backend_erp
  server 'backend.caodoo.com',
    user: 'ubuntu',
    roles: %w{web app},
    ssh_options: {}
end

def deploy_to_frontend_app
  server '54.223.140.135',
    user: 'ubuntu',
    roles: %w{web app db batch},
    ssh_options: {}

  #server '54.223.190.117',
  #user: 'ubuntu',
  #roles: %w{web app},
  #ssh_options: {}

  server '123.59.53.54',
    user: 'ubuntu',
    roles: %w{web app},
    ssh_options: {
      keys: %w(~/.ssh/id_rsa)
    }
end

case fetch(:deploy_selection).to_i
when 1
  deploy_to_test_server
when 2
  deploy_to_backend_erp
when 3
  deploy_to_frontend_app
end
