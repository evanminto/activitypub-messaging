require 'http'

module Factories
  class AccountFactory
    def self.from_activitystreams2_url(url)
      object = JsonLd::Object.new(json_ld_for_url(url)[0])
      account = Account.new

      return unless object

      raise StandardError.new('Profile must be of type Person.') unless object.activitystreams2.type_is('Person')

      assign_properties(account, object)

      account
    end

    private

    def self.json_ld_for_url(url_string)
      return unless url_string

      uri = URI(url_string)
      response_body = HTTP.headers(Accept: 'application/activity+json').get(uri).to_s
      raw_person_data = JSON.parse response_body
      JSON::LD::API.expand(raw_person_data)
    end

    def self.assign_properties(account, object)
      account.activitystreams2_url = object.id

      if object.activitystreams2.respond_to?(:name)
        account.display_name = object.activitystreams2.name[0]
      end

      if object.activitystreams2.respond_to?(:preferredUsername)
        account.username = object.activitystreams2.preferredUsername[0]
      end

      if object.activitystreams2.respond_to?(:url)
        first_url = object.activitystreams2.url[0]

        if first_url.is_a?(JsonLd::Object) &&
           first_url.activitystreams2.respond_to?(:href)
          account.profile_url = first_url.activitystreams2.href[0].id
        else
          account.profile_url = first_url
        end
      else
        account.profile_url = account.activitystreams2_url
      end
    end
  end
end
