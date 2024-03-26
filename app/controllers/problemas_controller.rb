class ProblemasController < ApplicationController
  before_action :verificar_autorizacion_sup, only: [:index,:show]
  #before_action :verificar_sup, only: [:index]
  before_action :verificar_autorizacion_usuario, only: [:new]

  def verificar_sup
    if !sup_actual.problema.nil?
      redirect_to sup_actual.problema
    end
  end

  def index
    @autos = Auto.order(Arel.sql("point(#{sup_actual.ubicacion.x}, #{sup_actual.ubicacion.y}) <-> ubicacion"))
    #@autos=Auto.all
    problems=nil                              #Arreglo de todos los problemas de los autos contenidos en @autos, solucionados y no solucionados
    @problemas=nil                            #Arreglo de problemas de los autos contenidos en @autos, que no fueron tomados todavía
    @autos.each do |auto|
      if problems == nil
        problems = auto.problemas
      else
        problems = problems + auto.problemas
      end
    end
    problems.each do |problema|
      if problema.sup_dni.nil?                 #El problema tiene un sup_dni nulo cuando no fue tomado por ningún supervisor todavía
        if @problemas == nil
          @problemas = [problema]
        else
          @problemas = @problemas + [problema]
        end
      end
    end
  end

  def show
    @problema = Problema.find_by(id: params[:id])
    if !@problema.resuelto
      if sup_actual.problema==nil || sup_actual.problema==@problema
        if sup_actual.problema==nil
          @problema.sup_dni = sup_actual.dni               #Al tomar un problema, este último se guarda el dni del supervisor
          @problema.save
          sup_actual.problema=@problema
        end
      else
        redirect_to sup_actual.problema
      end
    else
      redirect_to problemas_path
    end
  end

  def showProblemasTomados
    @problemas = Problema.where.not(sup_dni: nil).order(updated_at: :desc)
  end

  def new
    if usuario_actual.auto_id.nil?
      redirect_to root_path
    end
    @problema= Problema.new
  end
  
  def create
    @problema = Problema.new(problema_params)
    usuario = Usuario.find_by(global_id:session[:global_id])
    if !usuario.auto_id.nil?
      @problema.auto = Auto.find_by(id: usuario.auto_id)
      if @problema.save
        redirect_to root_path
      else
        render :new, status: :see_other
      end
    end
  end

  #No destruye el problema, solo lo marca como solucionado
  def solucionarProblema
    @problema = Problema.find_by(id: params[:problema_id])
    @problema.resuelto = true
    @problema.sup_id=sup_actual.id                            #Al solucionar un problema, este último toma el id del supervisor
    @problema.resolucion = params[:resolucion]
    @problema.save
    sup_actual.problema=nil
    if sup_actual.save
      redirect_to showProblemasTomados_path #problemas resueltos ordenado por update_at
    end
  end

  def explicacionDejar
    @problema = Problema.find(params[:problema_id])
  end

  def dejarProblema
    problema= Problema.find(params[:problema_id])
    problema.sup.update(problema:nil)
    problema.update(sup_dni:nil, sup_id:nil)
    redirect_to problemas_path
  end

  def problema_params
    params.require(:problema).permit(:descripcion,:foto)
  end

  def resolucion
    @problema = Problema.find(params[:problema_id])
  end

end