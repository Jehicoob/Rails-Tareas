Rails.application.routes.draw do
  devise_for :users
  resources :tasks do
    patch :trigger, on: :member # editar el estado ola instacia de una tarea
    resources :notes, only: [:create], controller: 'tasks/notes'
  end
  resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tasks#index'
end
