module Ruseo
  class DataError < StandardError; end
  class ConnectionError < StandardError; end
  class ConnectionLimit < StandardError; end
  class NotFoundError < StandardError; end          
  class ResponseError < StandardError; end
end