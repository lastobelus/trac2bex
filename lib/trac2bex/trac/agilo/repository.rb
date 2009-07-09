module Trac2bex
  module Trac
    module Agilo
      class Repository < ::Trac2bex::Trac::Repository
        attr_accessor :current_sprint_report_id
        attr_accessor :current_sprint_by_owner_report_id
        
        def ticket_columns
          super + %w{type totalhours i_links hours remaining_time rd_points estimatedhours sprint ranking}
        end

        
        def tickets_for_current_sprint_sql
          "SELECT * FROM ticket t 
          JOIN ticket_custom tc ON tc.ticket = t.id AND tc.name = 'sprint'
          JOIN agilo_sprint asp ON asp.name = tc.value
          where asp.sprint_end > strftime('%s','now')"
        end

        def tickets_for_current_sprint(owner=nil)
          if owner
            report(current_sprint_by_owner_report_id, {:OWNER => owner})
          else
            report(current_sprint_report_id)
          end
        end
        
        def my_tickets_for_current_sprint
          tickets_for_current_sprint user
        end
        
        def initialize(conf)
          case conf
          when String,URI
            super
          when Hash
            super
            agilo_conf = conf[:agilo] || {}
            @current_sprint_report_id = agilo_conf[:current_sprint_report_id]
            @current_sprint_by_owner_report_id = agilo_conf[:current_sprint_by_owner_report_id]
          end
        end
        
      end
    end
  end
end
