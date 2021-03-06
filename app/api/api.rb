class API < Grape::API
  mount Resources::NewsItems

  get 'legal' do
    {
      datenschutz: I18n.t("datenschutz.#{Setting.key}"),
      impressum: I18n.t("impressum.#{Setting.key}"),
      faq: ApplicationController.renderer.render('static_pages/faq', layout: false),
      explanation: Setting.explanation,
      person: Setting.email
    }
  end
end
