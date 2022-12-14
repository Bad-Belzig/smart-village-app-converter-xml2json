class Record < ApplicationRecord
  def load_xml_data
    raise "Abstract Method"
  end

  def convert_to_json(hash_data)
    hash_data.to_json
  end

  def convert_xml_to_hash
    raise "Abstract Method"
  end

  def geo_location_input(latitude, longitude)
    {
      latitude: latitude.to_f,
      longitude: longitude.to_f
    }
  end

  def is_true?(value)
    [1, true, '1', 'true', 't'].include?(value)
  end

  def select_target_servers(location, potential_target_servers)
    p "#{location[:district]}, #{location[:department]}, #{location[:region_name]}"
    store_locations(location)

    selected_servers = potential_target_servers.select { |_server_name, options|
      options[:districts].include?(location[:district].to_s.strip) ||
        options[:departments].include?(location[:department].to_s.strip) ||
        options[:regions].include?(location[:region_name].to_s.strip)
    }
    selected_servers.try(:keys)
  end

  def store_locations(location)
    Resource.where(title: location[:district], type: 'district').first_or_create if location[:district].present?
    Resource.where(title: location[:department], type: 'department').first_or_create if location[:department].present?
    Resource.where(title: location[:region_name], type: 'region').first_or_create if location[:region_name].present?
  end

end

# == Schema Information
#
# Table name: records
#
#  id          :bigint           not null, primary key
#  external_id :string
#  json_data   :jsonb
#  xml_data    :text
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
