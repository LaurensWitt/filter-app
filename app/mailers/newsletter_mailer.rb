class NewsletterMailer < ActionMailer::Base
  layout 'newsletter'
  default from: Setting.get('from')

  def newsletter(mailing, tracking_token)
    @mailing = mailing
    @title = 'Newsletter'

    @tracking_token = tracking_token
    @categories = mailing.categories
    names = @categories.map(&:name)
    names = if names.count > 5
              "aus #{names.count} Themen"
            else
              "zum Thema " + names.to_sentence
            end
    mail to: mailing.full_email, subject: "[#{Setting.site_name}] #{@mailing.count} Beiträge #{names}"
  end

  def initial_mail(subscription)
    @subscription = subscription
    mail to: subscription.full_email, subject: "Mit dem neuen Empfehlungsbund-Newsletter alle HR-News auf einen Blick"
  end
end
