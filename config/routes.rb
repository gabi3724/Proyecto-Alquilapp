Rails.application.routes.draw do
  resources :lics
  resources :docs
  
  resources :cards
  resources :incidences
  resources :admins
  resources :sups
  resources :alquilers
  resources :problemas
  resources :cancelados

  resources :usuarios

  get "listaValidacion", to: "sups#listaValidacion"
  get "verDni", to: "sups#verDni"
  get "verLicencia", to: "sups#verLicencia"
  get "actualizarDocumentos", to: "sups#actualizarDocumentos"
  get "actualizarDocumentos(.:format)", to: "sups#actualizarDocumentos"
  get "darAlta", to: "sups#darAlta"

  get 'autos/actualizar_datos(.:format)', to: 'autos#actualizar_datos'
  resources :autos

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy"

  get "eliminar", to: "alquilers#eliminar"
  get "advertencia", to: "alquilers#advertencia"
  get "licencia", to: "alquilers#licencia"
  get "aviso", to: "alquilers#aviso"

  get "showProblemasTomados", to: "problemas#showProblemasTomados"
  get "dejarProblema", to: "problemas#dejarProblema"
  get "explicacionDejar", to: "problemas#explicacionDejar"
  get "resolucion", to: "problemas#resolucion"
  get "solucionarProblema", to: "problemas#solucionarProblema"

  get 'alquiler/confirmarAlquiler(.:format)', to: 'alquiler#confirmarAlquiler'
  get 'alquiler/confirmarExtenderAlquiler(.:format)', to: 'alquiler#confirmarExtenderAlquiler'
  get 'alquiler/alquilerActual(.:format)', to: 'alquiler#alquilerActual'
  get 'alquiler/cancelarAlquiler(.:format)', to: 'alquiler#cancelarAlquiler'
  get 'alquiler/cancelacion(.:format)', to: 'alquiler#cancelacion'

  get "special_create", to: "cards#special_create"
  get "cargar_saldo", to: "cards#cargarSaldo"
  get "confirmar", to: "cards#confirmar"
  get "carga", to: "cards#carga"
  get "confirmarQuitarTarjeta", to: "cards#confirmarQuitarTarjeta"

  get "confirmar_borrar_incidencia", to: "incidences#confirmacion" 

  get "confirmar_quitar_auto", to: "autos#confirmar"
  get "confirmar_quitar_supervisor", to: "sups#confirmar"

  get "edit_pass", to: "pass#edit_pass"
  get "update_pass", to: "pass#update_pass"

  get "edit_perfil", to: "edition#edit"
  get "pedir_pass", to: "edition#pedirPass"
  get "update_perfil", to: "edition#update"
  get "editarAuto", to: "autos#editar"
  get "editar_preview", to: "autos#preview"
  get "editar_foto", to: "autos#editar_foto"
  patch "update_foto", to: "autos#update_foto"

  get "costo_alquiler", to: "costos#costoAlquiler"
  get "costo_combustible", to: "costos#costoCombustible"
  get "confirmar_costo_alquiler", to: "costos#confirmarCostoAlquiler"
  get "confirmar_costo_combustible", to: "costos#confirmarCostoCombustible"
  get "cambiar_costo_alquiler", to: "costos#cambiarCostoAlquiler"

  resources :alquiler
  resources :home

  get "info_alquiler", to: "alquiler#alquilerActual"

  get "unauthorized", to: "home#unauthorized"

  # Defines the root path route ("/")
  root "home#index"

end
