require 'plist'

module Trac2bex
  module Billings
    class Timeslip
      attr_accessor :attributes
      def initialize(attributes={})
        @attributes = {
          "project.name" => nil,
          "project.client.derivedName" => nil,
          "project.projectCode" => nil,
          "units" => nil,
          "startDateTime" => nil,
          "roundTime" => nil,
          "rate" => nil,
          "nature" => Trac2bex::Billings::TimeslipNatures::Billable,
          "name" => nil,
          "mileageType" => nil,
          "markup" => nil,
          "endDateTime" => nil,
          "dueDate" => nil,
          "distance" => nil,
          "discount" => nil,
          "createDate" => nil,
          "comment" => nil,
          "type.typeCode" => Trac2bex::Billings::TimeslipTypes::Timed,
          "category.name" => nil,
          "owner.name" => nil,
          "activeForTiming" => 1,
          "foreignAppName" => nil,
          "foreignAppEntityName" => nil,
          "foreignAppImportID" => nil,
          "project.client.firstName" => nil,
          "project.client.lastName" => nil,
          "project.client.clientABRef" => nil,
          "project.client.email" => nil,
          "project.client.company" => nil,
          "project.foreignAppName" => nil,
          "project.foreignAppEntityName" => nil,
          "project.foreignAppImportID" => nil
        }.merge(attributes)
      end
      
      def [](key)
        @attributes[key.to_s]
      end
      
      def []=(key,value)
        @attributes[key.to_s] = value
      end
      
      def project_attributes
        @attributes.reject{ |k,v|  k.index("project.").nil? }
      end
      
      def to_hash
        @attributes
      end
      
      def to_plist
        wrapper = {
          "entityName" => "TimeSlip",
          "objects" => [attributes.reject{ |k,v| v.nil? }]
        }
        Plist::Emit.dump(wrapper, true)
      end
      
      def to_plist_node
        Plist::Emit.dump(attributes.reject{ |k,v| v.nil? }, false)
      end
    end
  end
end

