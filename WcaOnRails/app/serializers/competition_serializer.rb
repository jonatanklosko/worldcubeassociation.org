class CompetitionSerializer < ActiveModel::Serializer
  attributes :id, :name, :website
  attribute :cellName, key: :short_name
  attribute :cityName, key: :city
  attribute :country_iso2 { object.country.iso2 }
  attributes :start_date, :end_date

  has_many :delegates
  has_many :organizers

  link(:self) { competition_url object } # Note should lead to /api competitions instead
end
