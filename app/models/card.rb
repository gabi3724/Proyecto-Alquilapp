class Card < ApplicationRecord
    include HTTParty

    belongs_to :usuario

    validate :presencia_formato_numero
    validate :presencia_formato_codigo
    validate :correspondencia
    validates_presence_of :fecha_vencimiento, message: "La fecha de vencimiento no puede estar vacía"
    validates_presence_of :titular, message: "El nombre del titular no puede estar vacío"
    validate :fecha_adecuada
    validate :tarjeta_existente

    def presencia_formato_numero
        if numero.blank?
            errors.add(:numero,message:"El número de la tarjeta no puede estar vacío")
        else
            if !(numero=~/\A\d+\Z/)
                errors.add(:numero,message:"La número de la tarjeta debe estar compuesto solamente por números")
            else
                if !(numero.length >=15 && numero.length <=16 && numero=~/\A\d+\Z/)
                    errors.add(:numero,message:"La tarjeta debe tener un número de 15 o 16 dígitos")
                end
            end
        end
    end

    def presencia_formato_codigo
        if codigo.blank?
            errors.add(:codigo,message:"El código de la tarjeta no puede estar vacío")
        else
            if !(codigo=~/\A\d+\Z/)
                errors.add(:codigo,message:"El código de la tarjeta debe estar compuesto solamente por números")
            else
                if !(codigo.length >=3 && codigo.length <=4)
                    errors.add(:codigo,message:"La tarjeta debe tener un código de 3 o 4 dígitos")
                end
            end
        end
    end

    #Este choclo de código debería poder mejorarse de alguna manera
    def correspondencia
        if !numero.blank? && !codigo.blank? && numero.length >=15 && numero.length <=16 && numero=~/\A\d+\Z/ && codigo.length >=3 && codigo.length <=4 && codigo=~/\A\d+\Z/
            if !((numero=~/\A\d{15}\Z/ && codigo=~/\A\d{4}\Z/) || (numero=~/\A\d{16}\Z/ && codigo=~/\A\d{3}\Z/))
                errors.add(:base,message:"Tarjeta inválida")
            end
        end
    end

    def fecha_adecuada
        if fecha_vencimiento < Date.today
            errors.add(:fecha_vencimiento,message:"La fecha de vencimiento no puede estar en el pasado")
        end
    end

    def tarjeta_existente
        if !errors.any?
            if fecha_vencimiento.month < 10
                mes= "0"+fecha_vencimiento.month.to_s
            else
                mes= fecha_vencimiento.month.to_s
            end
            respuesta= HTTParty.post("https://alquilapp.is.k-pb.com.ar/grupo03/api/pay",
                body: {
                    "credit_card_holder_name": titular,
                    "credit_card_number": numero.to_i,
                    "credit_card_code": codigo.to_i,
                    "credit_card_expiration": mes+fecha_vencimiento.strftime("%y"),
                    "amount": 0
                }.to_json,
                basic_auth:{
                    username: "g3",
                    password: "58orq2"
                },
                headers: { 'Content-Type' => 'application/json' })
            resultado= respuesta["result"]
            if resultado != "payment_accepted"
                errors.add(:base,message:"Tarjeta rechazada")
            end
        end
    end
end
