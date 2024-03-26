class CardsController < ApplicationController
  before_action :verificar_logueado
  before_action :verificar_autorizacion_usuario
  before_action :monto_presente_formato, only: [:confirmar]
  before_action :validarCarga, only: [:carga]

  def index
    @cards = Card.all
  end

  def new
    @card = Card.new
  end

  def create
    @card= Card.new(card_params)
    if @card.save
      redirect_to usuario_path(usuario_actual), notice:"Tarjeta agregada exitosamente"          #Después cambiar esto, debería redirigir a un lugar significativo
    else
      render :new, status: :see_other
    end
  end

  def special_create
    @card= Card.new
    @card.numero= params[:numero]
    @card.codigo= params[:codigo]
    @card.titular= params[:titular]
    @card.fecha_vencimiento= Date.civil(params[:year].to_i,params[:month].to_i,-1)
    @card.usuario_id= params[:usuario_id]
    if @card.save
      redirect_to usuario_path(usuario_actual), notice:"Tarjeta agregada exitosamente"          #Después cambiar esto, debería redirigir a un lugar significativo
    else
      render :new, status: :see_other
    end
  end

  #Hace render de la vista para cargar saldo
  def cargarSaldo
  end

  #Hace render de la vista para confirmar
  def confirmar
    @monto= params[:monto].to_i
    @usuario= usuario_actual
  end

  #Validación
  def monto_presente_formato
    monto= params[:monto]
    ok=true
    if monto.blank?
      #redirect_to cargar_saldo_path, alert:"El monto no puede estar vacío"
      flash.alert="Este campo no puede estar vacío"
      ok=false
    else
      if !(monto=~/\A\d+\Z/)
        flash.alert="El saldo a cargar debe consistir de números"
        ok=false
      elsif (monto.to_i <= 0)
        flash.alert="El saldo a cargar debe ser mayor a 0"
        ok=false
      end
    end
    if !ok
      redirect_to cargar_saldo_path
    end
  end

  #Antes de ejecutar la carga final, se ejecuta esto
  def validarCarga
    tarjeta= usuario_actual.card
    if !tarjeta.nil?
      if tarjeta.fecha_vencimiento.month < 10
        mes= "0"+tarjeta.fecha_vencimiento.month.to_s
      else
        mes= tarjeta.fecha_vencimiento.month.to_s
      end
      respuesta= HTTParty.post("https://alquilapp.is.k-pb.com.ar/grupo03/api/pay",
        body: {
            "credit_card_holder_name": tarjeta.titular,
            "credit_card_number": tarjeta.numero.to_i,
            "credit_card_code": tarjeta.codigo.to_i,
            "credit_card_expiration": mes+tarjeta.fecha_vencimiento.strftime("%y"),
            "amount": params[:monto].to_i
        }.to_json,
        basic_auth:{
            username: "g3",
            password: "58orq2"
        },
        headers: { 'Content-Type' => 'application/json' })
      resultado= respuesta["result"]
      #if resultado == "payment_rejected_insufficient_balance"
      #  redirect_to "/cargarSaldo", alert:"Carga de saldo rechazada"
      #end
      if resultado != "payment_accepted"
        if resultado == "payment_rejected_insufficient_balance"
          redirect_to cargar_saldo_path, alert:"Fondos insuficientes"
        else
          redirect_to usuario_path(usuario_actual), alert:"Tarjeta inválida"
        end
      end
    end
  end

  #El método que se ejecuta al confirmar la carga
  def carga
    monto= params[:monto].to_i
    usuario= usuario_actual
    creditos_act= usuario.creditos
    usuario.update(creditos:(creditos_act+monto))
    redirect_to usuario_path(usuario), notice:"Carga de saldo exitosa"
  end

  def confirmarQuitarTarjeta
    @card= usuario_actual.card
  end

  def destroy
    @card= Card.find(params[:id])
    usuario_id= @card.usuario_id
    if @card.destroy
      redirect_to usuario_path(usuario_id), notice: "Se ha quitado la tarjeta exitosamente"
    else
      redirect_to usuario_path(usuario_id), notice: "Hubo un error al eliminar la tarjeta"
    end
  end

  private

    def card_params
      params.require(:card).permit(:numero,:codigo,:titular,:fecha_vencimiento,:usuario_id)
    end

end
