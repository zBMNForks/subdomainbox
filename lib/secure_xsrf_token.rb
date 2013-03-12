require 'digest/sha1'

module ActionController #:nodoc:

  module RequestForgeryProtection

    protected

      alias_method :original_form_authenticity_token, :form_authenticity_token
      # Sets the token value for the current session.
      def form_authenticity_token
        raise 'XSRF token secret must be defined' if XSRF_TOKEN_SECRET.nil? || XSRF_TOKEN_SECRET.empty?
        if request.session_options[:id]
          Digest::SHA1.hexdigest("#{XSRF_TOKEN_SECRET}#{request.session_options[:id]}#{request.subdomain}")
        else
          original_form_authenticity_token
        end
      end

  end
end