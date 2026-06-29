Rswag::Ui.configure do |c|
  prefix = ENV.fetch('RAILS_RELATIVE_URL_ROOT', '')
  c.openapi_endpoint "#{prefix}/api-docs/v1/swagger.yaml", 'API V1 Docs'
end
