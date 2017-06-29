class User < ActiveRecord::Base
  has_one :account
  accepts_nested_attributes_for :account

  acts_as_authentic do |c|
    c.login_field = :email
  end

  def populate_remote
    return unless activitystreams2_url

    url = URI(activitystreams2_url)
    result = Net::HTTP.get url
    raw_person_data = JSON.parse result
    json_ld = JSON::LD::API.expand(raw_person_data)

    if not json_ld.empty? && json_ld[0]['@id']
      person_rdf = json_ld[0]
      self.activitystreams2_url = person_rdf['@id']
      self.name = as2_field person_rdf, 'name'
      self.username = as2_field person_rdf, 'preferredUsername'
    end
  end

  private

  def as2_field(rdf_data, name)
    value = rdf_data["https://www.w3.org/ns/activitystreams##{name}"]

    return if value.blank? || value[0].blank?

    value[0]['@value']
  end
end
