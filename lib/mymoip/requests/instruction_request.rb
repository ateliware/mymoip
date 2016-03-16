module MyMoip
  class InstructionRequest < Request
    HTTP_METHOD  = :get
    PATH          = "/ws/alpha/ConsultarInstrucao/"
    REQUIRES_AUTH = true

    attr_reader :token

    def initialize(token)
      @token = token
    end

    def api_call(opts = {})
      params = {
        http_method:   HTTP_METHOD,
        requires_auth: REQUIRES_AUTH,
        path:          PATH + @token
      }

      super(params, opts)
    end

    def success?
      @response.present? && @response["ConsultarTokenResponse"]["RespostaConsultar"]["Status"] == 'Sucesso'
    end

    def result
      @response["ConsultarTokenResponse"]["RespostaConsultar"]["Autorizacao"]
    end

    def buyer_name
      result["Pagador"]["Nome"]
    end

    def buyer_email
      result["Pagador"]["Email"]
    end

    def date
      DateTime.parse(payment["Data"])
    end

    def credited_date
      DateTime.parse(payment["DataCredito"]) if payment["DataCredito"]
    end

    def gross_amount
      payment["TotalPago"]["__content__"]
    end

    def fee_amount
      payment["TaxaMoIP"]["__content__"]
    end

    def net_amount
      payment["ValorLiquido"]["__content__"]
    end

    def payment_type
      payment["FormaPagamento"]
    end

    def payment_institution
      payment["InstituicaoPagamento"]
    end

    def status
      payment["Status"]["Tipo"]
    end

    def status_name
      payment["Status"]["__content__"]
    end

    def id
      payment["CodigoMoIP"]
    end

    def payment
      InstructionRequest.last_payment(result["Pagamento"])
    end

    def installments
      payment['Parcela']['TotalParcelas'].to_i
    end

    def card_brand
      payment['Bandeira']
    end

    def card_number
      payment['Cartao']
    end

    def self.last_payment(result_payment)
      if result_payment.kind_of?(Hash)
        result_payment
      else
        result_payment.max_by do |installment|
          DateTime.parse(installment["Data"])
        end
      end
    end
  end
end
