require 'fastercsv'

module Trac2bex
  class Translator
    
    attr_accessor :ticket_map
    
    def tickets_csv_to_timeslips(ticket_csv, default_attrs={})
      Trac2bex::Billings::TimeslipArray.new(tickets_csv_to_hashes(ticket_csv).map{|ticket| map_ticket_hash_to_timeslip(ticket,default_attrs)})
    end
    
    def tickets_csv_to_hashes(ticket_csv)
      f_table = FasterCSV.parse(ticket_csv, { :headers => true, :converters => :all, :header_converters => :symbol })
      arr = []
      f_table.each{|row| arr << row.to_hash}
    end

    # currently agilo/sage repository specific -- break apart when have time
    def map_ticket_hash_to_timeslip(ticket_hash, default_attrs={})
      ticket = Trac2bex::OpenStructWithId.new(ticket_hash)
      ticket.id = ticket.id.to_s
      attrs = {
        "foreignAppName" => "trac",
        "foreignAppEntityName" => "ticket",
        "category.name" => 'Trac Ticket',
        "activeForTiming" => true,
        "name" => "##{ticket.id}: #{ticket.summary}",
        "foreignAppImportID" => "#{ticket.id}",
        "dueDate" => Time.at(ticket.sprint_end),
        "createDate" => Time.now,
        "comment" => "#{ticket.description}"
      }.merge(default_attrs)

      sprint = ticket.sprint
      def sprint.number
        m=self.match(/Sprint (\d+)/i)
        puts "m.inspect"
        m[1]
      end
      
      interpolated_attrs = {}
      attrs.each_pair do |k, v|
        if v.is_a?(String) and (match = v.match(/^%\{(.*)\}$/))
          interpolated_attrs[k] = eval(match[1])
        else
          interpolated_attrs[k] = v
        end
      end
      
      timeslip = Trac2bex::Billings::Timeslip.new(interpolated_attrs)

    end

  end
  
  
end
