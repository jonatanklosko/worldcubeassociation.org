class ApiException < StandardError
  attr_reader :data
  def initialize(data)
    @data = data
  end
end

class Api::V1::Base < ApplicationController
  PAGINATION_PAGE_SIZE = 20

  rescue_from ApiException do |exception|
    render json: { errors: [exception.data] }, status: exception.data[:status]
  end

  def ensure_found(object)
    raise ApiException.new(not_found) unless object
  end

  def parameter(name, options)
    if options[:required] && params[:name].blank?
      raise ApiException.new(bad_parameter("The `#{name}` parameter is missing."))
    end
    if options[:default]
      _params = params
      *chain, innermost_key = name.split('.')
      chain.each { |key| _params = (_params[key] ||= {}) }
      _params[innermost_key] ||= options[:default]
    end
  end

  private
    def bad_parameter(detail)
      { status: 400, title: "Invalid parameter", detail: detail }
    end

    def not_found
      { status: 404, title: "Not found", detail: "Resource not found." }
    end
end
