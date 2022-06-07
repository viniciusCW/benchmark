Rails.application.routes.draw do
  get "/execute", to: "task#execute"
end
