require 'rubygems'
require 'cgi'
require 'mechanize'

module Trac2bex
  module Trac
    class Repository
      attr_accessor :url
      attr_accessor :agent
      attr_accessor :user
      attr_accessor :ticket_columns
      attr_accessor :auth
      
      DefaultTicketColumns = %w{id time changetime component severity priority owner reporter cc version milestone status resolution summary description}
      
      def initialize(conf)
        case conf
        when String,URI
          @url = conf
        when Hash
          @url = conf[:url]
          @user = conf[:user]
          @password = conf[:password]
          @auth = conf[:auth]
        end
      end
      
      def report(id, params={})
        params[:format] ||= "csv"
        params[:USER] ||= user
        uri = new_uri
        query = hash_to_query(params)
        uri.query = query
        uri.path += "/report/" + id.to_s
        agent.get(uri).body
      end
      
      def tickets(params={})
        params[:format] ||= "csv"
        params[:col] ||= ticket_columns
        uri = new_uri
        query = hash_to_query(params)
        uri.query = query
        uri.path += "/query"
        puts "reading #{uri.to_s}"
        
        agent.get(uri).body
      end
      
      def new_uri
        URI.parse(url)
      end

      def hash_to_query(hash)
        pairs = []
        hash.each do |k, vals|
          vals = [vals].flatten
          vals.each {|v| pairs << "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}
        end
        pairs.join("&")
      end

      def user_tickets(params={})
        params[:owner] = user
        tickets(params)
      end
      
      def agent
        unless @agent
          authenticate
        end
        @agent
      end
      
      def authenticate
        @agent = WWW::Mechanize.new
        pass = password
        case auth
        when :basic, nil
          @agent.basic_auth(user, pass) if user && pass
          @agent.get(url+'/login')
        when :form
          page = @agent.get(url+'/login')
          # form = page.form_with(:id => 'acctmgr_loginform')
          # Mechanize can't do form_with(:id)????
          page.forms.each{|f| puts "f.form_node.attributes['id']: #{f.form_node.attributes['id'].inspect}"}
          form = page.forms.detect{|f| f.form_node.attributes['id'].value == 'acctmgr_loginform'}
          form.field_with(:name => 'user').value = user
          form.field_with(:name => 'password').value = pass
          @agent.submit(form)
        end
      end
      
      def ticket_columns
        @ticket_columns ||= DefaultTicketColumns
      end
      
      def tickets(columns=nil)
        columns ||= ticket_columns
        query(:col => columns)
      end
      
      def password
        if @password == :keychain
          require 'uri'
          uri = URI.parse(@url)
          match = `security 2>&1 >/dev/null find-internet-password -g -s #{uri.host} -a #{user}`.match(/password: "([^"]+)"/)
          match[1]
        else
          @password
        end
      end
        
    end
  end
end
  