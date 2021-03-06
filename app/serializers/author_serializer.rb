class AuthorSerializer < ApplicationSerializer
  attributes :id, :name, :email, :username, :avatar_initials, :avatar_kind,
             :avatar_url, :email_hash, :time_zone, :locale, :created_at, :titles,
             :placeholder_name

  def include_email?
    scope[:current_user_id] == object.id || scope[:include_email] 
  end

  def titles
    object.experiences['titles'] || {}
  end

  def email_hash
    Digest::MD5.hexdigest(object.email.to_s.downcase)
  end

  def include_email_hash?
    object.avatar_kind == 'gravatar'
  end

  def avatar_kind
    if !object.email_verified && !object.name
      'mdi-email-outline'
    else
      object.avatar_kind
    end
  end

  def avatar_url
    {
      large:    object.avatar_url(:large)
    }
  end

  def include_avatar_url?
    object.avatar_kind == 'uploaded'
  end

  def placeholder_name
    I18n.t("user.placeholder_name", hostname: object.email.to_s.split('@').last, locale: object.locale)
  end

  def include_placeholder_name?
    object.name.nil?
  end

  private

  def scope
    super || {}
  end
end
