module Trac2bex
  module Trac
    module Agilo
      class Repository < Repository
        attr_accessor :current_sprint_report_id
        
        def ticket_columns
          super + %w{type totalhours i_links hours remaining_time rd_points estimatedhours sprint ranking}
        end

        
        def tickets_for_current_sprint_sql
          "SELECT * FROM ticket t 
          JOIN ticket_custom tc ON tc.ticket = t.id AND tc.name = 'sprint'
          JOIN agilo_sprint asp ON asp.name = tc.value
          where asp.sprint_end > strftime('%s','now')"
        end

        def tickets_for_current_sprint
          report(current_sprint_report_id)
        end
        
      end
    end
  end
end
