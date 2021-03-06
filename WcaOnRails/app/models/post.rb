# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :post_tags, autosave: true, dependent: :destroy
  include Taggable

  validates :title, presence: true, uniqueness: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true

  validate :unstick_at_must_be_in_the_future, if: :unstick_at
  private def unstick_at_must_be_in_the_future
    if unstick_at <= Date.today
      errors.add(:unstick_at, I18n.t('posts.errors.unstick_at_future'))
    end
  end

  before_validation :clear_unstick_at, unless: :sticky?
  private def clear_unstick_at
    self.unstick_at = nil
  end

  BREAK_TAG_RE = /<!--\s*break\s*-->/.freeze

  def body_full
    body.sub(BREAK_TAG_RE, "")
  end

  def body_teaser
    split = body.split(BREAK_TAG_RE)
    teaser = split.first
    if split.length > 1
      teaser += "\n\n[Read more....](" + Rails.application.routes.url_helpers.post_path(slug) + ")"
    end
    teaser
  end

  before_validation :compute_slug
  private def compute_slug
    self.slug = title.parameterize
  end

  def self.search(query, params: {})
    posts = Post
    query&.split&.each do |part|
      posts = posts.where("title LIKE :part OR body LIKE :part", part: "%#{part}%")
    end
    posts.order(created_at: :desc)
  end

  def serializable_hash(options = nil)
    json = {
      class: self.class.to_s.downcase,

      id: id,
      title: title,
      body: body,
      slug: slug,
      author: author,
    }

    json
  end
end
