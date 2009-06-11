require 'rubygems'
require 'cgi'
require 'mechanize'

module Trac2bex
  module Trac
    class Repository
      attr_accessor :url
      attr_accessor :agent
      attr_accessor :user
      attr_accessor :password
      attr_accessor :ticket_columns
      
      DefaultTicketColumns = %w{id time changetime component severity priority owner reporter cc version milestone status resolution summary description}
      
      def initialize(url)
        @url = url
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
        @agent.basic_auth(user, password) if user && password
        @agent.get(url+'/login')
      end
      
      def ticket_columns
        @ticket_columns ||= DefaultTicketColumns
      end
      
      def tickets(columns=nil)
        columns ||= ticket_columns
        query(:col => columns)
      end
    end
  end
end
  