module Satellite
  class JWTUserDecoder
    def user_uid
      payload["id"].to_s
    end
  end
end
