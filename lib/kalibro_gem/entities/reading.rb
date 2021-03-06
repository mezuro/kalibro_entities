# This file is part of KalibroGem
# Copyright (C) 2013  it's respectives authors (please see the AUTHORS file)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module KalibroGem
  module Entities
    class Reading < Model

      attr_accessor :id, :label, :grade, :color, :group_id

      def id=(value)
        @id = value.to_i
      end

      def grade=(value)
        @grade = value.to_f
      end

      def self.find(id)
        begin
          new request(:get_reading, {:reading_id => id})[:reading]
        rescue Savon::SOAPFault
          raise KalibroGem::Errors::RecordNotFound
        end
      end

      def self.readings_of(group_id)
        create_objects_array_from_hash request(:readings_of, {:group_id => group_id})[:reading]
      end

      def self.all
        reading_groups = ReadingGroup.all
        readings = []

        reading_groups.each do |reading_group|
          readings.concat(readings_of(reading_group.id))
        end
        return readings
      end

      def self.exists?(id)
        begin
          return true unless find(id).nil?
        rescue KalibroGem::Errors::RecordNotFound
          return false
        end
      end

      private

      def save_params
        {:reading => self.to_hash, :group_id => group_id}
      end

    end
  end
end
