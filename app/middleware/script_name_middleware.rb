class ScriptNameMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if (script_name = env["HTTP_X_SCRIPT_NAME"])
      env["SCRIPT_NAME"] = script_name
    end
    @app.call(env)
  end
end
