MessageBus.configure(backend: :redis, url: ENV['REDIS_URL'])

# might this for devise
# Rails.application.config do |config|
#   # See https://github.com/rails/rails/issues/26303#issuecomment-442894832
#   MyAppMessageBusMiddleware = Class.new(MessageBus::Rack::Middleware)
#   config.middleware.delete(MessageBus::Rack::Middleware)
#   config.middleware.insert_after(Warden::Manager, MyAppMessageBusMiddleware)
# end

MessageBus.configure(on_middleware_error: proc do |env, e|
  # env contains the Rack environment at the time of error
  # e contains the exception that was raised
  if Errno::EPIPE === e
    [422, {}, [""]]
  else
    raise e
  end
end)
