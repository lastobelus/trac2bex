module Trac2bex
  class Importer
    require 'yaml'
    require 'activesupport'

    ConfigFileName = '.trac2bex.yml'
    
    attr_accessor :config_file, :trac_cfg, :agilo_cfg, :billings_cfg, :agilo
    def initialize
      if File.exists?(config_file)
        configure
      end
    end
    
    def export_ticket_hours
      # given an export file
      export_file = "/tmp/slips.bex"
      # open it and unmarshal it
      plist = Plist::parse_xml(export_file).with_indifferent_access
      # puts plist.inspect
      plist
    end
    
    def import_tickets_for_current_sprint(forreal=false)
      require 'tempfile'
      require 'appscript'
      
      billings = Trac2bex::Translator.new
      tickets_csv = agilo.my_tickets_for_current_sprint
      btickets = billings.tickets_csv_to_timeslips(tickets_csv, billings_cfg[:timeslip])
      
      tmpfile_path = nil
      Tempfile.open('current_sprint') do |f|
        tmpfile_path = f.path
        f.write btickets.to_plist
      end

      if forreal
        billings = Appscript.app("Billings")
        billings.ImportBEXFile(:filename => tmpfile_path)
      else
        puts btickets.to_plist
      end
    end
    
    def configure(filename=nil)
      @agilo = nil
      @config_file = filename unless filename.nil?
      raise "cannot find a config file at #{filename}" unless File.exists?(config_file)
      config = YAML::load_file(config_file).with_indifferent_access
      @trac_cfg = config[:trac] || {}
      @agilo_cfg = trac_cfg[:agilo] || {}
      @billings_cfg = config[:billings] || {}
    end
    

    def config_file
      @config_file ||= File.join(ENV['HOME'], ConfigFileName)
    end
    
    def agilo
      @agilo ||=  Trac2bex::Trac::Agilo::Repository.new(trac_cfg)
    end
    
  end
end