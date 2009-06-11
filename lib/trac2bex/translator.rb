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

# %w{id time changetime component severity priority owner reporter cc version milestone status resolution summary description}
# %w{type totalhours i_links hours remaining_time rd_points estimatedhours sprint ranking}
# 

    # currently agilo/sage repository specific -- break apart when have time
    def map_ticket_hash_to_timeslip(ticket_hash, default_attrs={})
      attrs = {
        "foreignAppName" => "trac",
        "foreignAppEntityName" => "ticket",
        "category.name" => 'Trac Ticket',
        "activeForTiming" => true
      }.merge(default_attrs)
      
      timeslip = Trac2bex::Billings::Timeslip.new(attrs)

      timeslip['foreignAppImportID'] = ticket_hash[:id]
      timeslip['dueDate'] = Time.at(ticket_hash[:sprint_end])
      timeslip['createDate'] = Time.now
      timeslip['name'] = "##{ticket_hash[:id]}: #{ticket_hash[:summary]}"
      timeslip['comment'] = ticket_hash[:description]
      timeslip
    end

  end
end